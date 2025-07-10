import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  CreateDateColumn,
  JoinColumn,
  Unique,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Anteproject } from '../../anteprojects/entities/anteproject.entity';
import { AnteprojectEvaluationCriteria } from './anteproject_evaluation_criteria.entity';

@Entity('anteproject_evaluations')
@Unique(['anteprojectId', 'criteriaId'])
export class AnteprojectEvaluation {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column()
  anteprojectId: number;

  @Column()
  criteriaId: number;

  @Column()
  evaluatedById: number;

  @Column({ type: 'decimal', precision: 3, scale: 1, nullable: true })
  score?: number;

  @Column({ type: 'text', nullable: true })
  comments?: string;

  @CreateDateColumn({ type: 'timestamp' })
  evaluatedAt: Date;

  // --- Relaciones ---

  @ManyToOne(() => Anteproject)
  @JoinColumn({ name: 'anteprojectId' })
  anteproject: Anteproject;

  @ManyToOne(() => AnteprojectEvaluationCriteria)
  @JoinColumn({ name: 'criteriaId' })
  criteria: AnteprojectEvaluationCriteria;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'evaluatedById' })
  evaluatedBy: User;
}
