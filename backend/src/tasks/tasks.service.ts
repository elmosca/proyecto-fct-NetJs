import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Task } from './entities/task.entity';
import { User } from '../users/entities/user.entity';
import { Project } from '../projects/entities/project.entity';
import { RoleEnum } from '../roles/roles.enum';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';

@Injectable()
export class TasksService {
  constructor(
    @InjectRepository(Task) private tasksRepository: Repository<Task>,
    @InjectRepository(Project) private projectsRepository: Repository<Project>,
    @InjectRepository(User) private usersRepository: Repository<User>,
  ) {}

  private async checkProjectAccess(projectId: number, user: User): Promise<Project> {
    const project = await this.projectsRepository.findOne({
      where: { id: projectId },
      relations: ['tutor', 'students'],
    });
    if (!project) {
      throw new NotFoundException(`Project with ID ${projectId} not found`);
    }

    const isUserAdmin = user.role === RoleEnum.ADMIN;
    const isUserTutor = project.tutor.id === user.id;
    const isUserStudent = project.students.some(s => s.id === user.id);

    if (!isUserAdmin && !isUserTutor && !isUserStudent) {
      throw new ForbiddenException('You do not have permission to access this project.');
    }
    return project;
  }

  async findAllByProject(projectId: number, currentUser: User): Promise<Task[]> {
    await this.checkProjectAccess(projectId, currentUser);
    return this.tasksRepository.find({
      where: { projectId },
      relations: ['assignees', 'createdBy'],
    });
  }

  async findOne(id: number, currentUser: User): Promise<Task> {
    const task = await this.tasksRepository.findOne({ where: { id }, relations: ['project'] });
    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }
    await this.checkProjectAccess(task.projectId, currentUser);
    return task;
  }

  async create(createTaskDto: CreateTaskDto, currentUser: User): Promise<Task> {
    const project = await this.checkProjectAccess(createTaskDto.projectId, currentUser);

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutor = currentUser.id === project.tutor.id;

    if (!isAdmin && !isTutor) {
      throw new ForbiddenException('Only admins and the project tutor can create tasks.');
    }

    const { assigneeIds, ...taskData } = createTaskDto;
    let assignees: User[] = [];
    if (assigneeIds && assigneeIds.length > 0) {
        const projectStudentIds = project.students.map(s => s.id);
        const allAssigneesInProject = assigneeIds.every(id => projectStudentIds.includes(id));
      
        if (!allAssigneesInProject) {
            throw new ForbiddenException('You can only assign tasks to students who are part of the project.');
        }

      assignees = await this.usersRepository.find({ where: { id: In(assigneeIds) }});
    }

    const newTask = this.tasksRepository.create({
      ...taskData,
      createdById: currentUser.id, // Set createdById
      project: project,
      assignees,
    });

    return this.tasksRepository.save(newTask);
  }

  async update(id: number, updateTaskDto: UpdateTaskDto, currentUser: User): Promise<Task> {
    const task = await this.findOne(id, currentUser);
    const project = await this.checkProjectAccess(task.projectId, currentUser);

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutor = currentUser.id === project.tutor.id;
    const isCreator = currentUser.id === task.createdById;
    const isAssignee = task.assignees.some(a => a.id === currentUser.id);

    // General update permission
    if (!isAdmin && !isTutor && !isCreator) {
        // Allow assignees to update only status
        if (isAssignee) {
            const allowedUpdates: (keyof UpdateTaskDto)[] = ['status'];
            const requestedUpdates = Object.keys(updateTaskDto);
            const isUpdateAllowed = requestedUpdates.every(key => allowedUpdates.includes(key as any));
            if (!isUpdateAllowed || requestedUpdates.length === 0) {
                 throw new ForbiddenException('As an assignee, you can only update the task status.');
            }
        } else {
            throw new ForbiddenException('You do not have permission to update this task.');
        }
    }
    
    // Validate and update assignees if provided
    if (updateTaskDto.assigneeIds) {
        const projectStudentIds = project.students.map(s => s.id);
        const allAssigneesInProject = updateTaskDto.assigneeIds.every(id => projectStudentIds.includes(id));
        if (!allAssigneesInProject) {
            throw new ForbiddenException('You can only assign tasks to students who are part of the project.');
        }
        task.assignees = await this.usersRepository.find({ where: { id: In(updateTaskDto.assigneeIds) }});
    }
    
    const { assigneeIds, ...otherUpdates } = updateTaskDto;
    Object.assign(task, otherUpdates);
    return this.tasksRepository.save(task);
  }

  async remove(id: number, currentUser: User): Promise<void> {
    const task = await this.findOne(id, currentUser);
    const project = await this.checkProjectAccess(task.projectId, currentUser);

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutor = currentUser.id === project.tutor.id;
    const isCreator = currentUser.id === task.createdById;

    if (!isAdmin && !isTutor && !isCreator) {
        throw new ForbiddenException('You do not have permission to delete this task.');
    }
    
    await this.tasksRepository.softDelete(id);
  }

  async assignUser(taskId: number, userId: number, currentUser: User): Promise<Task> {
    const task = await this.findOne(taskId, currentUser);
    const project = await this.checkProjectAccess(task.projectId, currentUser);

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutor = currentUser.id === project.tutor.id;

    if (!isAdmin && !isTutor) {
      throw new ForbiddenException('Only admins and the project tutor can assign tasks.');
    }

    const userToAssign = project.students.find(s => s.id === userId);
    if (!userToAssign) {
      throw new NotFoundException(`Student with ID ${userId} is not part of this project.`);
    }

    const isAlreadyAssigned = task.assignees.some(a => a.id === userId);
    if (isAlreadyAssigned) {
      return task; // Idempotent: user already assigned
    }

    task.assignees.push(userToAssign);
    return this.tasksRepository.save(task);
  }

  async removeAssignee(taskId: number, userId: number, currentUser: User): Promise<Task> {
    const task = await this.findOne(taskId, currentUser);
    const project = await this.checkProjectAccess(task.projectId, currentUser);

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutor = currentUser.id === project.tutor.id;

    if (!isAdmin && !isTutor) {
      throw new ForbiddenException('Only admins and the project tutor can unassign tasks.');
    }
    
    const assigneeIndex = task.assignees.findIndex(a => a.id === userId);
    if (assigneeIndex === -1) {
      return task; // Idempotent: user not assigned
    }

    task.assignees.splice(assigneeIndex, 1);
    return this.tasksRepository.save(task);
  }
} 