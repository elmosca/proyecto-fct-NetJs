import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TasksService } from './tasks.service';
import { Task, TaskStatusEnum, TaskPriorityEnum, TaskComplexityEnum } from './entities/task.entity';
import { Project, ProjectStatusEnum } from '../projects/entities/project.entity';
import { User, UserStatus } from '../users/entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';

// Mocks
const mockAdminUser: User = { id: 1, role: RoleEnum.ADMIN, email: 'admin@test.com', fullName: 'Admin', passwordHash: '', status: UserStatus.ACTIVE, createdAt: new Date(), updatedAt: new Date() };
const mockTutorUser: User = { id: 2, role: RoleEnum.TUTOR, email: 'tutor@test.com', fullName: 'Tutor', passwordHash: '', status: UserStatus.ACTIVE, createdAt: new Date(), updatedAt: new Date() };
const mockStudentUser: User = { id: 3, role: RoleEnum.STUDENT, email: 'student@test.com', fullName: 'Student', passwordHash: '', status: UserStatus.ACTIVE, createdAt: new Date(), updatedAt: new Date() };
const mockProject: Project = { id: 1, title: 'Test Project', description: 'Desc', tutor: mockTutorUser, students: [mockStudentUser], status: ProjectStatusEnum.PLANNING, githubMainBranch: 'main', lastActivityAt: new Date(), createdAt: new Date(), updatedAt: new Date(), tutorId: mockTutorUser.id };
const mockTask: Task = { 
  id: 1, 
  title: 'Test Task', 
  description: 'Test', 
  projectId: mockProject.id, 
  project: mockProject,
  createdById: mockTutorUser.id,
  createdBy: mockTutorUser,
  assignees: [mockStudentUser], 
  status: TaskStatusEnum.PENDING, 
  priority: TaskPriorityEnum.MEDIUM, 
  complexity: TaskComplexityEnum.MEDIUM, 
  kanbanPosition: 0, 
  createdAt: new Date(), 
  updatedAt: new Date(),
};

describe('TasksService', () => {
  let service: TasksService;
  let taskRepository: Repository<Task>;
  let projectRepository: Repository<Project>;
  let userRepository: Repository<User>;

  const mockTaskRepository = { save: jest.fn(), create: jest.fn(), find: jest.fn(), findOne: jest.fn(), softDelete: jest.fn() };
  const mockProjectRepository = { findOne: jest.fn() };
  const mockUserRepository = { find: jest.fn() };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TasksService,
        { provide: getRepositoryToken(Task), useValue: mockTaskRepository },
        { provide: getRepositoryToken(Project), useValue: mockProjectRepository },
        { provide: getRepositoryToken(User), useValue: mockUserRepository },
      ],
    }).compile();

    service = module.get<TasksService>(TasksService);
    taskRepository = module.get<Repository<Task>>(getRepositoryToken(Task));
    projectRepository = module.get<Repository<Project>>(getRepositoryToken(Project));
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));

    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    const createTaskDto: CreateTaskDto = {
        title: 'New Task',
        description: 'New Description',
        projectId: mockProject.id,
    };

    it('should allow admin to create a task', async () => {
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await service.create(createTaskDto, mockAdminUser);
        expect(taskRepository.save).toHaveBeenCalled();
    });

    it('should allow project tutor to create a task', async () => {
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await service.create(createTaskDto, mockTutorUser);
        expect(taskRepository.save).toHaveBeenCalled();
    });

    it('should prevent student from creating a task', async () => {
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await expect(service.create(createTaskDto, mockStudentUser)).rejects.toThrow(ForbiddenException);
    });

    it('should throw NotFoundException if project does not exist', async () => {
        mockProjectRepository.findOne.mockResolvedValue(null);
        await expect(service.create(createTaskDto, mockAdminUser)).rejects.toThrow(NotFoundException);
    });
  });

  describe('findAllByProject', () => {
    it('should return tasks for a project if user has access', async () => {
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        mockTaskRepository.find.mockResolvedValue([mockTask]);
        const result = await service.findAllByProject(mockProject.id, mockTutorUser);
        expect(result).toEqual([mockTask]);
        expect(taskRepository.find).toHaveBeenCalledWith({
            where: { projectId: mockProject.id },
            relations: ['assignees', 'createdBy'],
        });
    });

    it('should throw ForbiddenException if user cannot access project', async () => {
        const otherTutor = { ...mockTutorUser, id: 99 };
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await expect(service.findAllByProject(mockProject.id, otherTutor)).rejects.toThrow(ForbiddenException);
    });
  });

  describe('findOne', () => {
    it('should return a task if user has access to the project', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        const result = await service.findOne(mockTask.id, mockTutorUser);
        expect(result).toEqual(mockTask);
    });

    it('should throw ForbiddenException if user cannot access the project of the task', async () => {
        const otherTutor = { ...mockTutorUser, id: 99 };
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await expect(service.findOne(mockTask.id, otherTutor)).rejects.toThrow(ForbiddenException);
    });
  });

  describe('update', () => {
    const updateDto: UpdateTaskDto = { title: 'Updated Task' };

    it('should allow admin to update a task', async () => {
      mockTaskRepository.findOne.mockResolvedValue(mockTask);
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockTaskRepository.save.mockResolvedValue({ ...mockTask, ...updateDto });
      await service.update(mockTask.id, updateDto, mockAdminUser);
      expect(taskRepository.save).toHaveBeenCalledWith(expect.objectContaining(updateDto));
    });

    it('should allow project tutor to update a task', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        mockTaskRepository.save.mockResolvedValue({ ...mockTask, ...updateDto });
        await service.update(mockTask.id, updateDto, mockTutorUser);
        expect(taskRepository.save).toHaveBeenCalledWith(expect.objectContaining(updateDto));
    });

    it('should allow task creator to update a task', async () => {
        // Assuming mockTutorUser is the creator
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        mockTaskRepository.save.mockResolvedValue({ ...mockTask, ...updateDto });
        await service.update(mockTask.id, updateDto, mockTutorUser);
        expect(taskRepository.save).toHaveBeenCalledWith(expect.objectContaining(updateDto));
    });

    it('should allow task assignee to update status', async () => {
        const statusUpdate: UpdateTaskDto = { status: TaskStatusEnum.IN_PROGRESS };
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        mockTaskRepository.save.mockResolvedValue({ ...mockTask, ...statusUpdate });
        await service.update(mockTask.id, statusUpdate, mockStudentUser);
        expect(taskRepository.save).toHaveBeenCalledWith(expect.objectContaining(statusUpdate));
    });

    it('should prevent assignee from updating other fields', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await expect(service.update(mockTask.id, updateDto, mockStudentUser)).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('should allow admin to soft delete a task', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await service.remove(mockTask.id, mockAdminUser);
        expect(taskRepository.softDelete).toHaveBeenCalledWith(mockTask.id);
    });

    it('should allow project tutor to soft delete a task', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await service.remove(mockTask.id, mockTutorUser);
        expect(taskRepository.softDelete).toHaveBeenCalledWith(mockTask.id);
    });

    it('should prevent student from deleting a task', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        await expect(service.remove(mockTask.id, mockStudentUser)).rejects.toThrow(ForbiddenException);
    });
  });

  describe('assignUser', () => {
    const anotherStudent: User = { id: 4, role: RoleEnum.STUDENT, email: 'student2@test.com', fullName: 'Student Two', passwordHash: '', status: UserStatus.ACTIVE, createdAt: new Date(), updatedAt: new Date() };
    const projectWithMoreStudents = { ...mockProject, students: [mockStudentUser, anotherStudent] };

    it('should allow project tutor to assign a student of the project', async () => {
        mockTaskRepository.findOne.mockResolvedValue({ ...mockTask, assignees: [] });
        mockProjectRepository.findOne.mockResolvedValue(projectWithMoreStudents);
        mockTaskRepository.save.mockResolvedValue({ ...mockTask, assignees: [anotherStudent]});

        const result = await service.assignUser(mockTask.id, anotherStudent.id, mockTutorUser);
        expect(result.assignees).toContainEqual(anotherStudent);
        expect(taskRepository.save).toHaveBeenCalled();
    });

    it('should prevent assigning a student not in the project', async () => {
        const studentNotInProject: User = { id: 5, role: RoleEnum.STUDENT, email: 'student3@test.com', fullName: 'Student Three', passwordHash: '', status: UserStatus.ACTIVE, createdAt: new Date(), updatedAt: new Date() };
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject); // This project only has mockStudentUser

        await expect(service.assignUser(mockTask.id, studentNotInProject.id, mockTutorUser)).rejects.toThrow(NotFoundException);
    });

    it('should prevent a student from assigning another student', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(projectWithMoreStudents);

        await expect(service.assignUser(mockTask.id, anotherStudent.id, mockStudentUser)).rejects.toThrow(ForbiddenException);
    });
  });

  describe('removeAssignee', () => {
    it('should allow project tutor to remove an assignee', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask); // mockTask has mockStudentUser as assignee
        mockProjectRepository.findOne.mockResolvedValue(mockProject);
        mockTaskRepository.save.mockResolvedValue({ ...mockTask, assignees: [] });

        const result = await service.removeAssignee(mockTask.id, mockStudentUser.id, mockTutorUser);
        expect(result.assignees).not.toContainEqual(mockStudentUser);
        expect(taskRepository.save).toHaveBeenCalled();
    });

    it('should prevent a student from removing an assignee', async () => {
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);

        await expect(service.removeAssignee(mockTask.id, mockStudentUser.id, mockStudentUser)).rejects.toThrow(ForbiddenException);
    });

    it('should not change task if user to remove is not an assignee', async () => {
        const studentNotAssigned: User = { id: 99, role: RoleEnum.STUDENT, email: 'student99@test.com', fullName: 'Student 99', passwordHash: '', status: UserStatus.ACTIVE, createdAt: new Date(), updatedAt: new Date() };
        mockTaskRepository.findOne.mockResolvedValue(mockTask);
        mockProjectRepository.findOne.mockResolvedValue(mockProject);

        const result = await service.removeAssignee(mockTask.id, studentNotAssigned.id, mockTutorUser);
        expect(result.assignees.length).toBe(mockTask.assignees.length);
        expect(taskRepository.save).not.toHaveBeenCalled();
    });
  });
}); 