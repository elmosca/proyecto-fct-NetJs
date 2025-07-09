import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  JoinColumn,
  OneToMany,
  ManyToMany,
  JoinTable,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Project } from '../../projects/entities/project.entity';
import { Milestone } from '../../milestones/entities/milestone.entity';
// import { Comment } from 'src/comments/entities/comment.entity';

/**
 * Enumeración para el estado de la tarea.
 */
export enum TaskStatusEnum {
  PENDING = 'pending',
  IN_PROGRESS = 'in_progress',
  UNDER_REVIEW = 'under_review',
  COMPLETED = 'completed',
}

/**
 * Enumeración para la prioridad de la tarea.
 */
export enum TaskPriorityEnum {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
}

/**
 * Enumeración para la complejidad de la tarea.
 */
export enum TaskComplexityEnum {
  SIMPLE = 'simple',
  MEDIUM = 'medium',
  COMPLEX = 'complex',
}

@Entity('tasks')
export class Task {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column()
  projectId: number;

  @Column({ nullable: true })
  milestoneId?: number;

  @Column()
  createdById: number;

  @Column({ type: 'varchar', length: 500 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({
    type: 'enum',
    enum: TaskStatusEnum,
    default: TaskStatusEnum.PENDING,
  })
  status: TaskStatusEnum;

  @Column({
    type: 'enum',
    enum: TaskPriorityEnum,
    default: TaskPriorityEnum.MEDIUM,
  })
  priority: TaskPriorityEnum;

  @Column({ type: 'date', nullable: true })
  dueDate?: Date;

  @Column({ type: 'timestamp', nullable: true })
  completedAt?: Date;

  @Column({ default: 0 })
  kanbanPosition: number;

  @Column({ type: 'int', nullable: true })
  estimatedHours?: number;

  @Column({ type: 'int', nullable: true })
  actualHours?: number;

  @Column({
    type: 'enum',
    enum: TaskComplexityEnum,
    default: TaskComplexityEnum.MEDIUM,
  })
  complexity: TaskComplexityEnum;

  @Column({ type: 'json', nullable: true })
  tags?: object; // Array de strings

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @DeleteDateColumn({ type: 'timestamp', nullable: true })
  deletedAt?: Date;

  // --- Relaciones ---

  @ManyToOne(() => Project)
  @JoinColumn({ name: 'projectId' })
  project: Project;

  @ManyToOne(() => Milestone)
  @JoinColumn({ name: 'milestoneId' })
  milestone?: Milestone;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'createdById' })
  createdBy: User;

  @ManyToMany(() => User)
  @JoinTable({
    name: 'task_assignees',
    joinColumn: { name: 'taskId', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'userId', referencedColumnName: 'id' },
  })
  assignees: User[];

  // @OneToMany(() => Comment, (comment) => comment.task)
  // comments: Comment[];
} 