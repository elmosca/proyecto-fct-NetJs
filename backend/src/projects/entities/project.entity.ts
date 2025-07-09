import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  JoinColumn,
  ManyToMany,
  JoinTable,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
// import { Anteproject } from 'src/anteprojects/entities/anteproject.entity';
// import { Milestone } from 'src/milestones/entities/milestone.entity';
// import { Task } from 'src/tasks/entities/task.entity';

/**
 * Enumeración para el estado del proyecto.
 */
export enum ProjectStatusEnum {
  ANTEPROJECT = 'anteproject',
  PLANNING = 'planning',
  IN_DEVELOPMENT = 'in_development',
  UNDER_REVIEW = 'under_review',
  COMPLETED = 'completed',
}

@Entity('projects')
export class Project {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ type: 'varchar', length: 500 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({
    type: 'enum',
    enum: ProjectStatusEnum,
    default: ProjectStatusEnum.ANTEPROJECT,
  })
  status: ProjectStatusEnum;

  @Column({ type: 'date', nullable: true })
  startDate?: Date;

  @Column({ type: 'date', nullable: true })
  estimatedEndDate?: Date;

  @Column({ type: 'date', nullable: true })
  actualEndDate?: Date;

  @Column({ type: 'varchar', length: 500, nullable: true })
  githubRepositoryUrl?: string;

  @Column({ type: 'varchar', length: 100, default: 'main' })
  githubMainBranch: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  lastActivityAt: Date;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @DeleteDateColumn({ type: 'timestamp', nullable: true })
  deletedAt?: Date;

  // --- Relaciones ---

  @ManyToOne(() => User) // Un proyecto tiene un tutor
  @JoinColumn({ name: 'tutorId' })
  tutor: User;

  @Column()
  tutorId: number;

  @ManyToMany(() => User)
  @JoinTable({
    name: 'project_students',
    joinColumn: { name: 'projectId', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'studentId', referencedColumnName: 'id' },
  })
  students: User[];

  // @OneToOne(() => Anteproject) // Un proyecto se origina de un anteproyecto
  // @JoinColumn({ name: 'anteprojectId' })
  // anteproject: Anteproject;

  // @Column({ nullable: true })
  // anteprojectId?: number;

  // @ManyToMany(() => User) // Un proyecto tiene muchos estudiantes
  // @JoinTable({
  //   name: 'project_students',
  //   joinColumn: { name: 'projectId', referencedColumnName: 'id' },
  //   inverseJoinColumn: { name: 'studentId', referencedColumnName: 'id' },
  // })
  // students: User[];

  // @OneToMany(() => Milestone, (milestone) => milestone.project)
  // milestones: Milestone[];

  // @OneToMany(() => Task, (task) => task.project)
  // tasks: Task[];
} 