import {
  IsString,
  IsNotEmpty,
  IsInt,
  IsOptional,
  IsArray,
  IsEnum,
  IsDateString,
  IsUrl,
} from 'class-validator';
import { ProjectStatusEnum } from '../entities/project.entity';

export class CreateProjectDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsInt()
  tutorId: number;

  @IsArray()
  @IsInt({ each: true })
  @IsOptional()
  studentIds?: number[];

  @IsEnum(ProjectStatusEnum)
  @IsOptional()
  status?: ProjectStatusEnum;

  @IsDateString()
  @IsOptional()
  startDate?: Date;

  @IsDateString()
  @IsOptional()
  estimatedEndDate?: Date;

  @IsUrl()
  @IsOptional()
  githubRepositoryUrl?: string;

  @IsString()
  @IsOptional()
  githubMainBranch?: string;
}
