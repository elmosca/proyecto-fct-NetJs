import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { FilesService } from '../files/files.service';
import { RoleEnum } from '../roles/roles.enum';
import { User, UserStatus } from '../users/entities/user.entity';
import { AnteprojectsService } from './anteprojects.service';
import { CreateAnteprojectDto } from './dto';
import { RejectAnteprojectDto } from './dto/reject-anteproject.dto';
import { ScheduleDefenseDto } from './dto/schedule-defense.dto';
import { UpdateAnteprojectDto } from './dto/update-anteproject.dto';
import {
    Anteproject,
    AnteprojectStatusEnum,
    AnteprojectTypeEnum,
} from './entities/anteproject.entity';

// Mocks
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

describe('AnteprojectsService', () => {
  let service: AnteprojectsService;
  let anteprojectRepository: Repository<Anteproject>;
  let userRepository: Repository<User>;

  let mockAnteproject: Anteproject;

  const mockAnteprojectRepository = {
    save: jest.fn(),
    create: jest.fn().mockReturnValue({
      id: 1,
      title: 'Test',
      tutor: mockTutorUser,
      students: [mockStudentUser],
      status: AnteprojectStatusEnum.DRAFT,
    }),
    find: jest.fn(),
    findOne: jest.fn(),
    createQueryBuilder: jest.fn().mockReturnValue({
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      innerJoin: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue([]),
    }),
    softDelete: jest.fn(),
  };
  const mockUserRepository = { findOne: jest.fn(), find: jest.fn() };

  beforeEach(async () => {
    mockAnteproject = {
      id: 1,
      title: 'Test',
      tutor: mockTutorUser,
      students: [mockStudentUser],
      status: AnteprojectStatusEnum.DRAFT,
    } as Anteproject;

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AnteprojectsService,
        {
          provide: getRepositoryToken(Anteproject),
          useValue: mockAnteprojectRepository,
        },
        { provide: getRepositoryToken(User), useValue: mockUserRepository },
        {
          provide: FilesService,
          useValue: {
            createFileRecord: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<AnteprojectsService>(AnteprojectsService);
    anteprojectRepository = module.get<Repository<Anteproject>>(
      getRepositoryToken(Anteproject),
    );
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));

    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    const createDto: CreateAnteprojectDto = {
      title: 'New Anteproject',
      projectType: AnteprojectTypeEnum.EXECUTION,
      description: 'Desc',
      academicYear: '2024',
      tutorId: mockTutorUser.id,
      studentIds: [mockStudentUser.id],
    };

    it('should allow a student to create an anteproject', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockTutorUser);
      mockUserRepository.find.mockResolvedValue([mockStudentUser]);
      await service.create(createDto, mockStudentUser);
      expect(anteprojectRepository.save).toHaveBeenCalled();
    });

    it('should prevent non-students from creating an anteproject', async () => {
      await expect(service.create(createDto, mockTutorUser)).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should prevent a student from creating an anteproject they are not part of', async () => {
      const otherStudent = { ...mockStudentUser, id: 99 };
      await expect(service.create(createDto, otherStudent)).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should throw NotFoundException if tutor is not found', async () => {
      mockUserRepository.findOne.mockResolvedValue(null);
      await expect(service.create(createDto, mockStudentUser)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('findAll', () => {
    it('should return all anteprojects for an admin', async () => {
      const queryBuilder = {
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        getMany: jest.fn().mockResolvedValue([mockAnteproject]),
      };
      mockAnteprojectRepository.createQueryBuilder.mockReturnValue(
        queryBuilder as any,
      );
      await service.findAll(mockAdminUser);
      expect(anteprojectRepository.createQueryBuilder).toHaveBeenCalledWith(
        'anteproject',
      );
    });

    it('should return only supervised anteprojects for a tutor', async () => {
      const queryBuilder = {
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        where: jest.fn().mockReturnThis(),
        getMany: jest.fn().mockResolvedValue([mockAnteproject]),
      };
      mockAnteprojectRepository.createQueryBuilder.mockReturnValue(
        queryBuilder as any,
      );
      await service.findAll(mockTutorUser);
      expect(anteprojectRepository.createQueryBuilder).toHaveBeenCalledWith(
        'anteproject',
      );
    });

    it('should return only own anteprojects for a student', async () => {
      const queryBuilder = {
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        innerJoin: jest.fn().mockReturnThis(),
        where: jest.fn().mockReturnThis(),
        getMany: jest.fn().mockResolvedValue([mockAnteproject]),
      };
      mockAnteprojectRepository.createQueryBuilder.mockReturnValue(
        queryBuilder as any,
      );
      await service.findAll(mockStudentUser);
      expect(anteprojectRepository.createQueryBuilder).toHaveBeenCalledWith(
        'anteproject',
      );
    });
  });

  describe('findOne', () => {
    it('should return an anteproject if user has access', async () => {
      mockAnteprojectRepository.findOne.mockResolvedValue(mockAnteproject);
      const result = await service.findOne(mockAnteproject.id, mockAdminUser);
      expect(result).toEqual(mockAnteproject);
    });

    it('should throw ForbiddenException if user cannot access', async () => {
      const otherUser = { ...mockTutorUser, id: 99 };
      mockAnteprojectRepository.findOne.mockResolvedValue(mockAnteproject);
      await expect(
        service.findOne(mockAnteproject.id, otherUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('update', () => {
    const updateDto: UpdateAnteprojectDto = { title: 'Updated Title' };

    it('should allow student to update their draft anteproject', async () => {
      mockAnteprojectRepository.findOne.mockResolvedValue(mockAnteproject);
      mockAnteprojectRepository.save.mockResolvedValue({
        ...mockAnteproject,
        ...updateDto,
      });
      await service.update(mockAnteproject.id, updateDto, mockStudentUser);
      expect(anteprojectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(updateDto),
      );
    });

    it('should allow tutor to update a draft anteproject', async () => {
      mockAnteprojectRepository.findOne.mockResolvedValue(mockAnteproject);
      mockAnteprojectRepository.save.mockResolvedValue({
        ...mockAnteproject,
        ...updateDto,
      });
      await service.update(mockAnteproject.id, updateDto, mockTutorUser);
      expect(anteprojectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(updateDto),
      );
    });

    it('should prevent updating if not in draft status (and user is not admin)', async () => {
      const submittedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.SUBMITTED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(submittedAnteproject);
      await expect(
        service.update(submittedAnteproject.id, updateDto, mockTutorUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('should allow student to remove their draft anteproject', async () => {
      mockAnteprojectRepository.findOne.mockResolvedValue(mockAnteproject);
      await service.remove(mockAnteproject.id, mockStudentUser);
      expect(anteprojectRepository.softDelete).toHaveBeenCalledWith(
        mockAnteproject.id,
      );
    });

    it('should prevent removing if not in draft status (and user is not admin)', async () => {
      const submittedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.SUBMITTED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(submittedAnteproject);
      await expect(
        service.remove(submittedAnteproject.id, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('submit', () => {
    it('should allow a student to submit their draft anteproject', async () => {
      const anteproject = { ...mockAnteproject };
      mockAnteprojectRepository.findOne.mockResolvedValue(anteproject);
      mockAnteprojectRepository.save.mockResolvedValue({
        ...anteproject,
        status: AnteprojectStatusEnum.SUBMITTED,
      });

      const result = await service.submit(anteproject.id, mockStudentUser);

      expect(result.status).toEqual(AnteprojectStatusEnum.SUBMITTED);
    });

    it('should prevent submitting if not in draft status', async () => {
      const submittedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.SUBMITTED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(submittedAnteproject);
      await expect(
        service.submit(submittedAnteproject.id, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should prevent a non-student of the project from submitting', async () => {
      const otherStudent = { ...mockStudentUser, id: 99 };
      mockAnteprojectRepository.findOne.mockResolvedValue(mockAnteproject);
      await expect(
        service.submit(mockAnteproject.id, otherStudent),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('review', () => {
    it('should allow tutor to put a submitted anteproject under review', async () => {
      const submittedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.SUBMITTED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(submittedAnteproject);
      mockAnteprojectRepository.save.mockResolvedValue({
        ...submittedAnteproject,
        status: AnteprojectStatusEnum.UNDER_REVIEW,
      });
      await service.review(submittedAnteproject.id, mockTutorUser);
      expect(anteprojectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({ status: AnteprojectStatusEnum.UNDER_REVIEW }),
      );
    });

    it('should prevent review if not submitted', async () => {
      const draftAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.DRAFT,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(draftAnteproject);
      await expect(
        service.review(draftAnteproject.id, mockTutorUser),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should prevent student from reviewing', async () => {
      const submittedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.SUBMITTED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(submittedAnteproject);
      await expect(
        service.review(submittedAnteproject.id, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('approve', () => {
    it('should allow tutor to approve an anteproject under review', async () => {
      const underReviewAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.UNDER_REVIEW,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(
        underReviewAnteproject,
      );
      await service.approve(underReviewAnteproject.id, mockTutorUser);
      expect(anteprojectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({ status: AnteprojectStatusEnum.APPROVED }),
      );
    });
  });

  describe('reject', () => {
    const rejectDto: RejectAnteprojectDto = {
      tutorComments: 'Not good enough',
    };

    it('should allow tutor to reject an anteproject under review', async () => {
      const underReviewAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.UNDER_REVIEW,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(
        underReviewAnteproject,
      );
      await service.reject(underReviewAnteproject.id, rejectDto, mockTutorUser);
      expect(anteprojectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({
          status: AnteprojectStatusEnum.REJECTED,
          tutorComments: rejectDto.tutorComments,
        }),
      );
    });
  });

  describe('scheduleDefense', () => {
    const scheduleDto: ScheduleDefenseDto = {
      defenseDate: new Date('2024-08-15T10:00:00.000Z'),
      defenseLocation: 'Room 404',
    };

    it('should allow tutor to schedule defense for an approved anteproject', async () => {
      const approvedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.APPROVED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(approvedAnteproject);

      await service.scheduleDefense(
        approvedAnteproject.id,
        scheduleDto,
        mockTutorUser,
      );

      expect(anteprojectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({
          status: AnteprojectStatusEnum.DEFENSE_SCHEDULED,
          defenseDate: scheduleDto.defenseDate,
          defenseLocation: scheduleDto.defenseLocation,
        }),
      );
    });

    it('should prevent scheduling defense if not approved', async () => {
      const draftAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.DRAFT,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(draftAnteproject);
      await expect(
        service.scheduleDefense(
          draftAnteproject.id,
          scheduleDto,
          mockTutorUser,
        ),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should prevent student from scheduling defense', async () => {
      const approvedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.APPROVED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(approvedAnteproject);
      await expect(
        service.scheduleDefense(
          approvedAnteproject.id,
          scheduleDto,
          mockStudentUser,
        ),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('completeDefense', () => {
    it('should allow tutor to complete defense for a scheduled anteproject', async () => {
      const scheduledAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.DEFENSE_SCHEDULED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(scheduledAnteproject);

      await service.completeDefense(scheduledAnteproject.id, mockTutorUser);

      expect(anteprojectRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({
          status: AnteprojectStatusEnum.COMPLETED,
        }),
      );
    });

    it('should prevent completing defense if not scheduled', async () => {
      const approvedAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.APPROVED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(approvedAnteproject);
      await expect(
        service.completeDefense(approvedAnteproject.id, mockTutorUser),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should prevent student from completing defense', async () => {
      const scheduledAnteproject = {
        ...mockAnteproject,
        status: AnteprojectStatusEnum.DEFENSE_SCHEDULED,
      };
      mockAnteprojectRepository.findOne.mockResolvedValue(scheduledAnteproject);
      await expect(
        service.completeDefense(scheduledAnteproject.id, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });
});
