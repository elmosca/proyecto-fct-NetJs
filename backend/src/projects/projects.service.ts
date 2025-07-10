import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Project } from './entities/project.entity';
import { User } from '../users/entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';

@Injectable()
export class ProjectsService {
  constructor(
    @InjectRepository(Project)
    private projectsRepository: Repository<Project>,
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async findAll(currentUser: User): Promise<Project[]> {
    if (currentUser.role === RoleEnum.ADMIN) {
      return this.projectsRepository.find({ relations: ['tutor', 'students'] });
    }
    if (currentUser.role === RoleEnum.TUTOR) {
      return this.projectsRepository.find({
        where: { tutorId: currentUser.id },
        relations: ['tutor', 'students'],
      });
    }
    // For students, find projects they are part of
    return this.projectsRepository
      .createQueryBuilder('project')
      .leftJoinAndSelect('project.tutor', 'tutor')
      .leftJoinAndSelect('project.students', 'student')
      .where('student.id = :studentId', { studentId: currentUser.id })
      .getMany();
  }

  async findOne(id: number, currentUser: User): Promise<Project> {
    const project = await this.projectsRepository.findOne({
      where: { id },
      relations: ['tutor', 'students'],
    });

    if (!project) {
      throw new NotFoundException(`Project with ID ${id} not found`);
    }

    const isUserAdmin = currentUser.role === RoleEnum.ADMIN;
    const isUserTutorOfTheProject = project.tutor.id === currentUser.id;
    const isUserStudentOfTheProject = project.students.some(
      (student) => student.id === currentUser.id,
    );

    if (
      !isUserAdmin &&
      !isUserTutorOfTheProject &&
      !isUserStudentOfTheProject
    ) {
      throw new ForbiddenException(
        'You do not have permission to view this project.',
      );
    }

    return project;
  }

  async create(
    createProjectDto: CreateProjectDto,
    currentUser: User,
  ): Promise<Project> {
    if (
      currentUser.role !== RoleEnum.ADMIN &&
      currentUser.role !== RoleEnum.TUTOR
    ) {
      throw new ForbiddenException(
        'You do not have permission to create projects.',
      );
    }

    const { studentIds, tutorId, ...projectData } = createProjectDto;

    // A tutor can only create projects for themselves
    if (currentUser.role === RoleEnum.TUTOR && currentUser.id !== tutorId) {
      throw new ForbiddenException(
        'You can only create projects for yourself.',
      );
    }

    // Validate tutor
    const tutor = await this.usersRepository.findOne({
      where: { id: tutorId, role: RoleEnum.TUTOR },
    });
    if (!tutor) {
      throw new NotFoundException(
        `Tutor with ID ${tutorId} not found or is not a tutor.`,
      );
    }

    let students: User[] = [];
    if (studentIds && studentIds.length > 0) {
      students = await this.usersRepository.find({
        where: {
          id: In(studentIds),
          role: RoleEnum.STUDENT,
        },
      });
      if (students.length !== studentIds.length) {
        throw new NotFoundException(
          'One or more students were not found or are not students.',
        );
      }
    }

    const newProject = this.projectsRepository.create({
      ...projectData,
      tutor,
      students,
    });
    return this.projectsRepository.save(newProject);
  }

  async update(
    id: number,
    updateProjectDto: UpdateProjectDto,
    currentUser: User,
  ): Promise<Project> {
    const project = await this.findOne(id, currentUser); // This already checks view permissions

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutor = currentUser.role === RoleEnum.TUTOR;
    const isTutorOfTheProject = project.tutor.id === currentUser.id;
    const isStudentOfTheProject = project.students.some(
      (student) => student.id === currentUser.id,
    );

    // Only admins or the project tutor can update general project info
    if (!isAdmin && !isTutorOfTheProject) {
      // Allow students to update only specific fields
      if (isStudentOfTheProject) {
        const allowedStudentUpdates: (keyof UpdateProjectDto)[] = [
          'githubRepositoryUrl',
          'githubMainBranch',
        ];
        const requestedUpdates = Object.keys(updateProjectDto);
        const isUpdateAllowed = requestedUpdates.every((key) =>
          allowedStudentUpdates.includes(key as any),
        );
        if (!isUpdateAllowed) {
          throw new ForbiddenException(
            'As a student, you can only update the GitHub repository URL and main branch.',
          );
        }
      } else {
        throw new ForbiddenException(
          'You do not have permission to update this project.',
        );
      }
    }

    // Validate and update tutor if provided
    if (
      updateProjectDto.tutorId &&
      updateProjectDto.tutorId !== project.tutorId
    ) {
      if (!isAdmin) {
        throw new ForbiddenException(
          'Only admins can change the project tutor.',
        );
      }
      const newTutor = await this.usersRepository.findOne({
        where: { id: updateProjectDto.tutorId, role: RoleEnum.TUTOR },
      });
      if (!newTutor) {
        throw new NotFoundException(
          `Tutor with ID ${updateProjectDto.tutorId} not found or is not a tutor.`,
        );
      }
      project.tutor = newTutor;
    }

    // Validate and update students if provided
    if (updateProjectDto.studentIds) {
      if (!isAdmin && !isTutorOfTheProject) {
        throw new ForbiddenException(
          'Only admins and the project tutor can change students.',
        );
      }
      const newStudents = await this.usersRepository.find({
        where: { id: In(updateProjectDto.studentIds), role: RoleEnum.STUDENT },
      });
      if (newStudents.length !== updateProjectDto.studentIds.length) {
        throw new NotFoundException(
          'One or more students were not found or are not students.',
        );
      }
      project.students = newStudents;
    }

    // Apply other updates
    const { tutorId, studentIds, ...otherUpdates } = updateProjectDto;
    Object.assign(project, otherUpdates);

    return this.projectsRepository.save(project);
  }

  async remove(id: number, currentUser: User): Promise<void> {
    const project = await this.findOne(id, currentUser); // Ensures user has at least view permission

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutorOfTheProject = project.tutor.id === currentUser.id;

    if (!isAdmin && !isTutorOfTheProject) {
      throw new ForbiddenException(
        'You do not have permission to delete this project.',
      );
    }

    const result = await this.projectsRepository.softDelete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Project with ID ${id} not found`);
    }
  }

  async addStudent(
    projectId: number,
    studentId: number,
    currentUser: User,
  ): Promise<Project> {
    const project = await this.findOne(projectId, currentUser);

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutorOfTheProject = project.tutor.id === currentUser.id;

    if (!isAdmin && !isTutorOfTheProject) {
      throw new ForbiddenException(
        'You do not have permission to add students to this project.',
      );
    }

    const studentToAdd = await this.usersRepository.findOne({
      where: { id: studentId, role: RoleEnum.STUDENT },
    });

    if (!studentToAdd) {
      throw new NotFoundException(
        `Student with ID ${studentId} not found or is not a student.`,
      );
    }

    const isStudentAlreadyInProject = project.students.some(
      (student) => student.id === studentId,
    );

    if (isStudentAlreadyInProject) {
      // Opcional: podrías lanzar un BadRequestException o simplemente devolver el proyecto tal cual.
      // Devolver el proyecto sin cambios es más idempotente.
      return project;
    }

    project.students.push(studentToAdd);
    return this.projectsRepository.save(project);
  }

  async removeStudent(
    projectId: number,
    studentId: number,
    currentUser: User,
  ): Promise<Project> {
    const project = await this.findOne(projectId, currentUser);

    const isAdmin = currentUser.role === RoleEnum.ADMIN;
    const isTutorOfTheProject = project.tutor.id === currentUser.id;

    if (!isAdmin && !isTutorOfTheProject) {
      throw new ForbiddenException(
        'You do not have permission to remove students from this project.',
      );
    }

    const studentIndex = project.students.findIndex(
      (student) => student.id === studentId,
    );

    if (studentIndex === -1) {
      // El estudiante no está en el proyecto, no hay nada que hacer.
      return project;
    }

    project.students.splice(studentIndex, 1);
    return this.projectsRepository.save(project);
  }
}
