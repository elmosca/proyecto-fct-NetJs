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

@Entity('notifications')
@Index(['userId', 'readAt'])
export class Notification {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column()
  userId: number;

  @Column({ type: 'varchar', length: 50 })
  type: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  message: string;

  @Column({ type: 'varchar', length: 500, nullable: true })
  actionUrl?: string;

  @Column({ type: 'json', nullable: true })
  metadata?: object;

  @Column({ type: 'timestamp', nullable: true })
  readAt?: Date;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  // --- Relaciones ---

  @ManyToOne(() => User)
  @JoinColumn({ name: 'userId' })
  user: User;
}
