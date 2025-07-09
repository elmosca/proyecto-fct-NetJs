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

/**
 * Enumeración para los tipos de entidades a las que se puede adjuntar un archivo.
 */
export enum AttachableTypeEnum {
  TASK = 'task',
  COMMENT = 'comment',
  ANTEPROJECT = 'anteproject',
}

@Entity('files')
@Index(['attachableType', 'attachableId'])
export class File {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ type: 'varchar', length: 255 })
  filename: string;

  @Column({ type: 'varchar', length: 255 })
  originalFilename: string;

  @Column({ type: 'varchar', length: 500 })
  filePath: string;

  @Column({ type: 'bigint' })
  fileSize: number;

  @Column({ type: 'varchar', length: 100 })
  mimeType: string;

  @Column()
  uploadedById: number;

  @Column({
    type: 'enum',
    enum: AttachableTypeEnum,
  })
  attachableType: AttachableTypeEnum;

  @Column()
  attachableId: number;

  @CreateDateColumn({ type: 'timestamp' })
  uploadedAt: Date;

  // --- Relaciones ---

  @ManyToOne(() => User)
  @JoinColumn({ name: 'uploadedById' })
  uploadedBy: User;
} 