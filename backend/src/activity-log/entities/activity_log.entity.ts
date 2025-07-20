import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  CreateDateColumn,
  JoinColumn,
  Index,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('activity_log')
@Index(['entityType', 'entityId'])
@Index(['userId', 'createdAt'])
export class ActivityLog {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column()
  userId: number;

  @Column({ type: 'varchar', length: 100 })
  action: string;

  @Column({ type: 'varchar', length: 50 })
  entityType: string;

  @Column()
  entityId: number;

  @Column({ type: 'json', nullable: true })
  oldValues?: object;

  @Column({ type: 'json', nullable: true })
  newValues?: object;

  @Column({ type: 'varchar', length: 45, nullable: true })
  ipAddress?: string;

  @Column({ type: 'text', nullable: true })
  userAgent?: string;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  // --- Relaciones ---

  @ManyToOne(() => User)
  @JoinColumn({ name: 'userId' })
  user: User;
}
