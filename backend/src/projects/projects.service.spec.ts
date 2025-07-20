import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProjectsService } from './projects.service';
import { Project, ProjectStatusEnum } from './entities/project.entity';
import { User, UserStatus } from '../users/entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';

// Mock data
const mockAdminUser: User = {
  id: 1,
  role: RoleEnum.ADMIN,
  email: 'admin@test.com',
  fullName: 'Admin',
  passwordHash: '',
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};
const mockTutorUser: User = {
  id: 2,
  role: RoleEnum.TUTOR,
  email: 'tutor@test.com',
  fullName: 'Tutor',
  passwordHash: '',
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};
const mockStudentUser: User = {
  id: 3,
  role: RoleEnum.STUDENT,
  email: 'student@test.com',
  fullName: 'Student',
  passwordHash: '',
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};
const mockProject: Project = {
  id: 1,
  title: 'Test Project',
  description: 'Test Desc',
  tutor: mockTutorUser,
  students: [mockStudentUser],
  status: ProjectStatusEnum.PLANNING,
  githubMainBranch: 'main',
  lastActivityAt: new Date(),
  createdAt: new Date(),
  updatedAt: new Date(),
  tutorId: 2,
};

describe('ProjectsService', () => {
  let service: ProjectsService;
  let projectRepository: Repository<Project>;
  let userRepository: Repository<User>;

  const mockProjectRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    softDelete: jest.fn(),
    createQueryBuilder: jest.fn(),
  };

  const mockUserRepository = {
    findOne: jest.fn(),
    find: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProjectsService,
        {
          provide: getRepositoryToken(Project),
          useValue: mockProjectRepository,
        },
        { provide: getRepositoryToken(User), useValue: mockUserRepository },
      ],
    }).compile();

    service = module.get<ProjectsService>(ProjectsService);
    projectRepository = module.get<Repository<Project>>(
      getRepositoryToken(Project),
    );
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));

    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    const createProjectDto: CreateProjectDto = {
      title: 'New Project',
      description: 'New Description',
      tutorId: mockTutorUser.id,
      studentIds: [mockStudentUser.id],
    };

    it('should allow an admin to create a project', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockTutorUser);
      mockUserRepository.find.mockResolvedValue([mockStudentUser]);
      mockProjectRepository.create.mockReturnValue(mockProject);
      mockProjectRepository.save.mockResolvedValue(mockProject);

      await service.create(createProjectDto, mockAdminUser);
      expect(projectRepository.create).toHaveBeenCalled();
      expect(projectRepository.save).toHaveBeenCalled();
    });

    it('should allow a tutor to create a project for themselves', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockTutorUser);
      mockUserRepository.find.mockResolvedValue([mockStudentUser]);
      mockProjectRepository.create.mockReturnValue(mockProject);
      mockProjectRepository.save.mockResolvedValue(mockProject);

      await service.create(createProjectDto, mockTutorUser);
      expect(projectRepository.save).toHaveBeenCalled();
    });

    it('should prevent a student from creating a project', async () => {
      await expect(
        service.create(createProjectDto, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should prevent a tutor from creating a project for another tutor', async () => {
      const dtoForOtherTutor = { ...createProjectDto, tutorId: 99 };
      await expect(
        service.create(dtoForOtherTutor, mockTutorUser),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw NotFoundException if tutor does not exist', async () => {
      mockUserRepository.findOne.mockResolvedValue(null);
      await expect(
        service.create(createProjectDto, mockAdminUser),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw NotFoundException if any student does not exist', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockTutorUser);
      mockUserRepository.find.mockResolvedValue([]); // Simulate student not found
      await expect(
        service.create(createProjectDto, mockAdminUser),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('findAll', () => {
    it('should return all projects for an admin', async () => {
      mockProjectRepository.find.mockResolvedValue([mockProject]);
      const result = await service.findAll(mockAdminUser);
      expect(result).toEqual([mockProject]);
      expect(projectRepository.find).toHaveBeenCalledWith({
        relations: ['tutor', 'students'],
      });
    });

    it('should return only supervised projects for a tutor', async () => {
      mockProjectRepository.find.mockResolvedValue([mockProject]);
      const result = await service.findAll(mockTutorUser);
      expect(result).toEqual([mockProject]);
      expect(projectRepository.find).toHaveBeenCalledWith({
        where: { tutorId: mockTutorUser.id },
        relations: ['tutor', 'students'],
      });
    });

    it('should return only assigned projects for a student', async () => {
      const queryBuilder = {
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        where: jest.fn().mockReturnThis(),
        getMany: jest.fn().mockResolvedValue([mockProject]),
      };
      mockProjectRepository.createQueryBuilder.mockReturnValue(
        queryBuilder as any,
      );

      const result = await service.findAll(mockStudentUser);
      expect(result).toEqual([mockProject]);
      expect(projectRepository.createQueryBuilder).toHaveBeenCalledWith(
        'project',
      );
      expect(queryBuilder.where).toHaveBeenCalledWith(
        'student.id = :studentId',
        { studentId: mockStudentUser.id },
      );
    });
  });

  describe('findOne', () => {
    it('should return a project if user is admin', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      const result = await service.findOne(mockProject.id, mockAdminUser);
      expect(result).toEqual(mockProject);
    });

    it('should return a project if user is the tutor of the project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      const result = await service.findOne(mockProject.id, mockTutorUser);
      expect(result).toEqual(mockProject);
    });

    it('should return a project if user is a student of the project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      const result = await service.findOne(mockProject.id, mockStudentUser);
      expect(result).toEqual(mockProject);
    });

    it('should throw ForbiddenException if user is not associated with the project', async () => {
      const anotherTutor = { ...mockTutorUser, id: 99 };
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      await expect(
        service.findOne(mockProject.id, anotherTutor),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw NotFoundException if project is not found', async () => {
      mockProjectRepository.findOne.mockResolvedValue(null);
      await expect(service.findOne(999, mockAdminUser)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    const updateDto: UpdateProjectDto = { title: 'Updated Title' };

    it('should allow admin to update a project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockProjectRepository.save.mockResolvedValue({
        ...mockProject,
        ...updateDto,
      });
      await service.update(mockProject.id, updateDto, mockAdminUser);
      expect(projectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(updateDto),
      );
    });

    it('should allow project tutor to update a project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockProjectRepository.save.mockResolvedValue({
        ...mockProject,
        ...updateDto,
      });
      await service.update(mockProject.id, updateDto, mockTutorUser);
      expect(projectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(updateDto),
      );
    });

    it('should allow student to update github url', async () => {
      const githubUpdate: UpdateProjectDto = {
        githubRepositoryUrl: 'http://new.url',
      };
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockProjectRepository.save.mockResolvedValue({
        ...mockProject,
        ...githubUpdate,
      });
      await service.update(mockProject.id, githubUpdate, mockStudentUser);
      expect(projectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(githubUpdate),
      );
    });

    it('should prevent student from updating other fields', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      await expect(
        service.update(mockProject.id, updateDto, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('should allow admin to soft delete a project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockProjectRepository.softDelete.mockResolvedValue({ affected: 1 });
      await service.remove(mockProject.id, mockAdminUser);
      expect(projectRepository.softDelete).toHaveBeenCalledWith(mockProject.id);
    });

    it('should allow project tutor to soft delete a project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockProjectRepository.softDelete.mockResolvedValue({ affected: 1 });
      await service.remove(mockProject.id, mockTutorUser);
      expect(projectRepository.softDelete).toHaveBeenCalledWith(mockProject.id);
    });

    it('should prevent student from deleting a project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      await expect(
        service.remove(mockProject.id, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('addStudent', () => {
    const newStudent: User = {
      id: 4,
      role: RoleEnum.STUDENT,
      email: 'new@student.com',
      fullName: 'New Student',
      passwordHash: '',
      status: UserStatus.ACTIVE,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    it('should allow project tutor to add a student', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockUserRepository.findOne.mockResolvedValue(newStudent);
      mockProjectRepository.save.mockResolvedValue({
        ...mockProject,
        students: [...mockProject.students, newStudent],
      });

      const result = await service.addStudent(
        mockProject.id,
        newStudent.id,
        mockTutorUser,
      );
      expect(result.students).toContainEqual(newStudent);
      expect(projectRepository.save).toHaveBeenCalled();
    });

    it('should allow admin to add a student', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockUserRepository.findOne.mockResolvedValue(newStudent);
      mockProjectRepository.save.mockResolvedValue({
        ...mockProject,
        students: [...mockProject.students, newStudent],
      });

      const result = await service.addStudent(
        mockProject.id,
        newStudent.id,
        mockAdminUser,
      );

      expect(result.students).toContainEqual(newStudent);
      expect(projectRepository.save).toHaveBeenCalled();
    });

    it('should prevent another tutor from adding a student', async () => {
      const anotherTutor = { ...mockTutorUser, id: 99 };
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      await expect(
        service.addStudent(mockProject.id, newStudent.id, anotherTutor),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw NotFoundException if student to add does not exist', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockUserRepository.findOne.mockResolvedValue(null);
      await expect(
        service.addStudent(mockProject.id, 999, mockTutorUser),
      ).rejects.toThrow(NotFoundException);
    });

    it('should not add a student if they are already in the project', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      mockUserRepository.findOne.mockResolvedValue(mockStudentUser);
      // The student to add is already in mockProject.students
      const result = await service.addStudent(
        mockProject.id,
        mockStudentUser.id,
        mockTutorUser,
      );
      expect(result.students.length).toBe(mockProject.students.length);
      expect(projectRepository.save).not.toHaveBeenCalled();
    });
  });

  describe('removeStudent', () => {
    it('should allow project tutor to remove a student', async () => {
      const projectWithStudent = {
        ...mockProject,
        students: [mockStudentUser],
      };
      mockProjectRepository.findOne.mockResolvedValue(projectWithStudent);
      mockProjectRepository.save.mockResolvedValue({
        ...mockProject,
        students: [],
      });

      const result = await service.removeStudent(
        mockProject.id,
        mockStudentUser.id,
        mockTutorUser,
      );
      expect(result.students).not.toContainEqual(mockStudentUser);
      expect(projectRepository.save).toHaveBeenCalled();
    });

    it('should prevent a student from removing another student', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      await expect(
        service.removeStudent(
          mockProject.id,
          mockStudentUser.id,
          mockStudentUser,
        ),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should not change the project if student to remove is not in it', async () => {
      mockProjectRepository.findOne.mockResolvedValue(mockProject);
      // Trying to remove a student who is not in the project
      const result = await service.removeStudent(
        mockProject.id,
        999,
        mockTutorUser,
      );
      expect(result.students.length).toBe(mockProject.students.length);
      expect(projectRepository.save).not.toHaveBeenCalled();
    });
  });
});
