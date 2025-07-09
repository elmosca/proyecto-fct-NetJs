import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
} from 'typeorm';
import { RoleEnum } from '../../roles/roles.enum';
// import { Project } from '../../projects/entities/project.entity';
// import { Task } from '../../tasks/entities/task.entity';
// import { Comment } from '../../comments/entities/comment.entity';
// import { Anteproject } from 'src/anteprojects/entities/anteproject.entity';
// import { Notification } from 'src/notifications/entities/notification.entity';
// import { ActivityLog } from 'src/activity-log/entities/activity_log.entity';

/**
 * Enumeración para el estado del usuario.
 */
export enum UserStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ type: 'varchar', length: 255 })
  fullName: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  email: string;

  @Column({ type: 'varchar', length: 255 })
  passwordHash: string;

  @Column({ type: 'varchar', length: 20, unique: true, nullable: true })
  nre?: string; // NRE es opcional y solo para alumnos

  @Column({
    type: 'enum',
    enum: RoleEnum,
    default: RoleEnum.STUDENT,
  })
  role: RoleEnum;

  @Column({ type: 'varchar', length: 20, nullable: true })
  phone?: string;

  @Column({ type: 'text', nullable: true })
  biography?: string;

  @Column({
    type: 'enum',
    enum: UserStatus,
    default: UserStatus.ACTIVE,
  })
  status: UserStatus;

  @Column({ type: 'timestamp', nullable: true })
  emailVerifiedAt?: Date;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @DeleteDateColumn({ type: 'timestamp', nullable: true })
  deletedAt?: Date;

  // TODO: Habilitar relaciones cuando las entidades existan.

  // @OneToMany(() => Anteproject, (anteproject) => anteproject.tutor)
  // supervisedAnteprojects: Anteproject[];

  // @OneToMany(() => Project, (project) => project.tutor)
  // supervisedProjects: Project[];

  // @OneToMany(() => Task, (task) => task.createdBy)
  // createdTasks: Task[];

  // @OneToMany(() => Comment, (comment) => comment.author)
  // comments: Comment[];

  // @OneToMany(() => Notification, (notification) => notification.user)
  // notifications: Notification[];

  // @OneToMany(() => ActivityLog, (log) => log.user)
  // activityLogs: ActivityLog[];
} 