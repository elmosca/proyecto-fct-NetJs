import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { EvaluationsService } from './evaluations.service';
import { AnteprojectEvaluation } from './entities/anteproject_evaluation.entity';
import { AnteprojectEvaluationCriteria } from './entities/anteproject_evaluation_criteria.entity';
import { AnteprojectsService } from '../anteprojects/anteprojects.service';
import { User, UserStatus } from '../users/entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { CreateEvaluationDto } from './dto/create-evaluation.dto';
import {
  Anteproject,
  AnteprojectStatusEnum,
  AnteprojectTypeEnum,
} from '../anteprojects/entities/anteproject.entity';

// Mocks
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
const mockAnteproject: Anteproject = {
  id: 1,
  title: 'Test Anteproject',
  description: 'Desc',
  status: AnteprojectStatusEnum.SUBMITTED,
  tutorId: mockTutorUser.id,
  students: [mockStudentUser],
  tutor: mockTutorUser,
  createdAt: new Date(),
  updatedAt: new Date(),
  academicYear: '2024',
  projectType: AnteprojectTypeEnum.EXECUTION,
  expectedResults: [],
  timeline: [],
  institution: 'Test Institute',
  modality: 'Test Modality',
  location: 'Test Location',
};
const mockCriteria: AnteprojectEvaluationCriteria = {
  id: 1,
  name: 'Viability',
  displayOrder: 1,
  isActive: true,
  maxScore: 10,
  createdAt: new Date(),
};
const mockEvaluation: AnteprojectEvaluation = {
  id: 1,
  anteprojectId: mockAnteproject.id,
  criteriaId: mockCriteria.id,
  evaluatedById: mockTutorUser.id,
  score: 8,
  comments: 'Good',
  evaluatedAt: new Date(),
  anteproject: mockAnteproject,
  criteria: mockCriteria,
  evaluatedBy: mockTutorUser,
};
const createDto: CreateEvaluationDto = {
  anteprojectId: mockAnteproject.id,
  evaluations: [{ criteriaId: mockCriteria.id, score: 8, comments: 'Good' }],
};

describe('EvaluationsService', () => {
  let service: EvaluationsService;
  let evaluationsRepository: Repository<AnteprojectEvaluation>;
  let criteriaRepository: Repository<AnteprojectEvaluationCriteria>;
  let anteprojectsService: AnteprojectsService;

  const mockEvaluationsRepository = {
    save: jest.fn(),
    find: jest.fn(),
    create: jest.fn().mockImplementation((dto) => dto),
  };
  const mockCriteriaRepository = { find: jest.fn() };
  const mockAnteprojectsService = { findOne: jest.fn() };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EvaluationsService,
        {
          provide: getRepositoryToken(AnteprojectEvaluation),
          useValue: mockEvaluationsRepository,
        },
        {
          provide: getRepositoryToken(AnteprojectEvaluationCriteria),
          useValue: mockCriteriaRepository,
        },
        { provide: AnteprojectsService, useValue: mockAnteprojectsService },
      ],
    }).compile();

    service = module.get<EvaluationsService>(EvaluationsService);
    evaluationsRepository = module.get<Repository<AnteprojectEvaluation>>(
      getRepositoryToken(AnteprojectEvaluation),
    );
    criteriaRepository = module.get<Repository<AnteprojectEvaluationCriteria>>(
      getRepositoryToken(AnteprojectEvaluationCriteria),
    );
    anteprojectsService = module.get<AnteprojectsService>(AnteprojectsService);

    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createOrUpdate', () => {
    it('should allow a tutor to create evaluations', async () => {
      mockAnteprojectsService.findOne.mockResolvedValue(mockAnteproject);
      mockCriteriaRepository.find.mockResolvedValue([mockCriteria]);
      mockEvaluationsRepository.save.mockResolvedValue([mockEvaluation]);

      await service.createOrUpdate(createDto, mockTutorUser);

      expect(anteprojectsService.findOne).toHaveBeenCalledWith(
        createDto.anteprojectId,
        mockTutorUser,
      );
      expect(criteriaRepository.find).toHaveBeenCalledWith({
        where: { id: In([mockCriteria.id]) },
      });
      expect(evaluationsRepository.save).toHaveBeenCalled();
    });

    it('should prevent a student from creating evaluations', async () => {
      mockAnteprojectsService.findOne.mockResolvedValue(mockAnteproject);
      await expect(
        service.createOrUpdate(createDto, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw NotFoundException if a criterion does not exist', async () => {
      mockAnteprojectsService.findOne.mockResolvedValue(mockAnteproject);
      mockCriteriaRepository.find.mockResolvedValue([]); // Simulate criterion not found
      await expect(
        service.createOrUpdate(createDto, mockTutorUser),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('findAllByAnteproject', () => {
    it('should return evaluations if user has permission', async () => {
      mockAnteprojectsService.findOne.mockResolvedValue(mockAnteproject);
      mockEvaluationsRepository.find.mockResolvedValue([mockEvaluation]);

      const result = await service.findAllByAnteproject(
        mockAnteproject.id,
        mockTutorUser,
      );

      expect(result).toEqual([mockEvaluation]);
      expect(anteprojectsService.findOne).toHaveBeenCalledWith(
        mockAnteproject.id,
        mockTutorUser,
      );
    });

    it('should throw ForbiddenException if findOne throws it', async () => {
      // The service delegates permission checks to anteprojectsService.findOne
      mockAnteprojectsService.findOne.mockRejectedValue(
        new ForbiddenException(),
      );
      await expect(
        service.findAllByAnteproject(mockAnteproject.id, mockStudentUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });
});
