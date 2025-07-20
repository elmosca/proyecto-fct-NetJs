import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AnteprojectEvaluationCriteria } from 'src/evaluations/entities/anteproject_evaluation_criteria.entity';
import { AnteprojectEvaluationCriteriaSeedService } from './anteproject-evaluation-criteria-seed.service';

@Module({
  imports: [TypeOrmModule.forFeature([AnteprojectEvaluationCriteria])],
  providers: [AnteprojectEvaluationCriteriaSeedService],
  exports: [AnteprojectEvaluationCriteriaSeedService],
})
export class AnteprojectEvaluationCriteriaSeedModule {}
