import { IsEnum, IsInt, IsNotEmpty, Min } from 'class-validator';
import { TaskStatusEnum } from '../entities/task.entity';

/**
 * DTO para mover una tarea en el tablero Kanban.
 * Especifica el nuevo estado (columna) y la nueva posición.
 */
export class MoveTaskDto {
  @IsEnum(TaskStatusEnum)
  @IsNotEmpty()
  newStatus: TaskStatusEnum;

  @IsInt()
  @Min(0)
  @IsNotEmpty()
  newPosition: number;
} 