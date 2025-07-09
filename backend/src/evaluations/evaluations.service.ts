import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { AnteprojectsService } from '../anteprojects/anteprojects.service';
import { RoleEnum } from '../roles/roles.enum';
import { User } from '../users/entities/user.entity';
import { CreateEvaluationDto } from './dto/create-evaluation.dto';
import { AnteprojectEvaluation } from './entities/anteproject_evaluation.entity';
import { AnteprojectEvaluationCriteria } from './entities/anteproject_evaluation_criteria.entity';

@Injectable()
export class EvaluationsService {
  constructor(
    @InjectRepository(AnteprojectEvaluation)
    private evaluationsRepository: Repository<AnteprojectEvaluation>,
    @InjectRepository(AnteprojectEvaluationCriteria)
    private criteriaRepository: Repository<AnteprojectEvaluationCriteria>,
    private anteprojectsService: AnteprojectsService,
  ) {}

  async createOrUpdate(
    createEvaluationDto: CreateEvaluationDto,
    currentUser: User,
  ) {
    const { anteprojectId, evaluations } = createEvaluationDto;
    // 1. Check if the user has permission to evaluate this anteproject.
    // The findOne method from anteprojectsService already handles permission checks.
    await this.anteprojectsService.findOne(anteprojectId, currentUser);

    // Only tutors and admins can evaluate
    if (
      currentUser.role !== RoleEnum.ADMIN &&
      currentUser.role !== RoleEnum.TUTOR
    ) {
      throw new ForbiddenException('You are not allowed to evaluate anteprojects.');
    }

    // 2. Validate all criteria IDs exist
    const criteriaIds = evaluations.map((e) => e.criteriaId);
    const existingCriteria = await this.criteriaRepository.find({
      where: { id: In(criteriaIds) },
    });
    if (existingCriteria.length !== criteriaIds.length) {
      throw new NotFoundException('One or more evaluation criteria were not found.');
    }

    // 3. Create or update evaluations
    const evaluationsToSave = evaluations.map((evaluationDto) => {
      return this.evaluationsRepository.create({
        anteprojectId,
        criteriaId: evaluationDto.criteriaId,
        score: evaluationDto.score,
        comments: evaluationDto.comments,
        evaluatedById: currentUser.id,
      });
    });

    // TypeORM's save can handle both insert and update (upsert)
    // We need a way to identify existing records. A composite key on (anteprojectId, criteriaId) is ideal.
    // Assuming such a constraint exists, this will work.
    return this.evaluationsRepository.save(evaluationsToSave);
  }

  async findAllByAnteproject(anteprojectId: number, currentUser: User) {
    // Check if the user has permission to view this anteproject's evaluations.
    await this.anteprojectsService.findOne(anteprojectId, currentUser);

    return this.evaluationsRepository.find({
      where: { anteprojectId },
      relations: ['criteria', 'evaluator'],
      order: {
        criteria: {
          displayOrder: 'ASC',
        },
      },
    });
  }
} 