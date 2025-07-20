import {
  IsString,
  IsNotEmpty,
  IsInt,
  IsOptional,
  IsArray,
  IsEnum,
  IsDateString,
} from 'class-validator';
import {
  TaskStatusEnum,
  TaskPriorityEnum,
  TaskComplexityEnum,
} from '../entities/task.entity';

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsInt()
  projectId: number;

  @IsInt()
  @IsOptional()
  milestoneId?: number;

  @IsArray()
  @IsInt({ each: true })
  @IsOptional()
  assigneeIds?: number[];

  @IsEnum(TaskStatusEnum)
  @IsOptional()
  status?: TaskStatusEnum;

  @IsEnum(TaskPriorityEnum)
  @IsOptional()
  priority?: TaskPriorityEnum;

  @IsDateString()
  @IsOptional()
  dueDate?: Date;

  @IsInt()
  @IsOptional()
  kanbanPosition?: number;

  @IsInt()
  @IsOptional()
  estimatedHours?: number;

  @IsEnum(TaskComplexityEnum)
  @IsOptional()
  complexity?: TaskComplexityEnum;

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  tags?: string[];
}
