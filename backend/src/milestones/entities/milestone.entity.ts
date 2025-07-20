import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  JoinColumn,
  Unique,
} from 'typeorm';
import { Project } from '../../projects/entities/project.entity';
// import { Task } from 'src/tasks/entities/task.entity';

/**
 * Enumeración para el estado del hito.
 */
export enum MilestoneStatusEnum {
  PENDING = 'pending',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  DELAYED = 'delayed',
}

/**
 * Enumeración para el tipo de hito.
 */
export enum MilestoneTypeEnum {
  PLANNING = 'planning',
  EXECUTION = 'execution',
  REVIEW = 'review',
  FINAL = 'final',
}

@Entity('milestones')
@Unique(['projectId', 'milestoneNumber'])
export class Milestone {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column()
  projectId: number;

  @Column()
  milestoneNumber: number;

  @Column({ type: 'varchar', length: 500 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'date' })
  plannedDate: Date;

  @Column({ type: 'date', nullable: true })
  completedDate?: Date;

  @Column({
    type: 'enum',
    enum: MilestoneStatusEnum,
    default: MilestoneStatusEnum.PENDING,
  })
  status: MilestoneStatusEnum;

  @Column({
    type: 'enum',
    enum: MilestoneTypeEnum,
    default: MilestoneTypeEnum.EXECUTION,
  })
  milestoneType: MilestoneTypeEnum;

  @Column({ default: false })
  isFromAnteproject: boolean;

  @Column({ type: 'json', nullable: true })
  expectedDeliverables?: object; // Array de strings

  @Column({ type: 'text', nullable: true })
  reviewComments?: string;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @DeleteDateColumn({ type: 'timestamp', nullable: true })
  deletedAt?: Date;

  // --- Relaciones ---

  @ManyToOne(() => Project) // Un hito pertenece a un proyecto
  @JoinColumn({ name: 'projectId' })
  project: Project;

  // @OneToMany(() => Task, (task) => task.milestone)
  // tasks: Task[];
}
