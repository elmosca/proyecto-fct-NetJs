import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EvaluationsService } from './evaluations.service';
import { EvaluationsController } from './evaluations.controller';
import { AnteprojectEvaluation } from './entities/anteproject_evaluation.entity';
import { AnteprojectEvaluationCriteria } from './entities/anteproject_evaluation_criteria.entity';
import { AnteprojectsModule } from '../anteprojects/anteprojects.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      AnteprojectEvaluation,
      AnteprojectEvaluationCriteria,
    ]),
    AnteprojectsModule,
  ],
  controllers: [EvaluationsController],
  providers: [EvaluationsService],
})
export class EvaluationsModule {}
