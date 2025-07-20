import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  UpdateDateColumn,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

/**
 * Enumeración para el tipo de valor de la configuración.
 */
export enum SettingTypeEnum {
  STRING = 'string',
  INTEGER = 'integer',
  BOOLEAN = 'boolean',
  JSON = 'json',
}

@Entity('system_settings')
export class SystemSetting {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ type: 'varchar', length: 100, unique: true })
  settingKey: string;

  @Column({ type: 'text' })
  settingValue: string;

  @Column({
    type: 'enum',
    enum: SettingTypeEnum,
    default: SettingTypeEnum.STRING,
  })
  settingType: SettingTypeEnum;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ default: true })
  isEditable: boolean;

  @Column({ nullable: true })
  updatedById?: number;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  // --- Relaciones ---

  @ManyToOne(() => User)
  @JoinColumn({ name: 'updatedById' })
  updatedBy: User;
}
