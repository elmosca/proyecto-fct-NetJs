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
import { File } from '../../files/entities/file.entity';
// import { AnteprojectObjective } from './anteproject-objective.entity';
// import { AnteprojectEvaluation } from './anteproject-evaluation.entity';

/**
 * Enumeración para el tipo de proyecto.
 */
export enum AnteprojectTypeEnum {
  EXECUTION = 'execution',
  RESEARCH = 'research',
  BIBLIOGRAPHIC = 'bibliographic',
  MANAGEMENT = 'management',
}

/**
 * Enumeración para el estado del anteproyecto.
 */
export enum AnteprojectStatusEnum {
  DRAFT = 'draft',
  SUBMITTED = 'submitted',
  UNDER_REVIEW = 'under_review',
  APPROVED = 'approved',
  REJECTED = 'rejected',
  DEFENSE_SCHEDULED = 'defense_scheduled',
  COMPLETED = 'completed',
}

@Entity('anteprojects')
export class Anteproject {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ type: 'varchar', length: 500 })
  title: string;

  @Column({
    type: 'enum',
    enum: AnteprojectTypeEnum,
  })
  projectType: AnteprojectTypeEnum;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'varchar', length: 20 })
  academicYear: string;

  @Column({
    type: 'varchar',
    length: 255,
    default: 'CIFP Carlos III de Cartagena',
  })
  institution: string;

  @Column({ type: 'varchar', length: 100, default: 'modalidad distancia' })
  modality: string;

  @Column({ type: 'varchar', length: 100, default: 'Cartagena' })
  location: string;

  @Column({ type: 'json' })
  expectedResults: object; // Se almacenará como un array de strings

  @Column({ type: 'json' })
  timeline: object; // Se almacenará como un objeto con fechas clave

  @Column({
    type: 'enum',
    enum: AnteprojectStatusEnum,
    default: AnteprojectStatusEnum.DRAFT,
  })
  status: AnteprojectStatusEnum;

  @Column({ type: 'timestamp', nullable: true })
  submittedAt?: Date;

  @Column({ type: 'date', nullable: true })
  submissionDate?: Date;

  @Column({ type: 'timestamp', nullable: true })
  reviewedAt?: Date;

  @Column({ type: 'date', nullable: true })
  evaluationDate?: Date;

  @Column({ type: 'timestamp', nullable: true })
  defenseDate?: Date;

  @Column({ type: 'varchar', length: 255, nullable: true })
  defenseLocation?: string;

  @Column({ type: 'text', nullable: true })
  tutorComments?: string;

  @DeleteDateColumn({ type: 'timestamp', nullable: true })
  deletedAt?: Date;

  // --- Relaciones ---

  @ManyToOne(() => User)
  @JoinColumn({ name: 'tutorId' })
  tutor: User;

  @Column()
  tutorId: number;

  @ManyToMany(() => User)
  @JoinTable({
    name: 'anteproject_students',
    joinColumn: { name: 'anteprojectId', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'studentId', referencedColumnName: 'id' },
  })
  students: User[];

  @OneToMany(() => File, (file) => file.anteproject)
  files: File[];

  // @OneToMany(() => AnteprojectObjective, (objective) => objective.anteproject)
  // objectives: AnteprojectObjective[];

  // @OneToMany(() => AnteprojectEvaluation, (evaluation) => evaluation.anteproject)
  // evaluations: AnteprojectEvaluation[];

  // @OneToMany(() => File, (file) => file.attachableId) // Relación polimórfica
  // files: File[];
}
