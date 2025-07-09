import {
  IsString,
  IsNotEmpty,
  IsInt,
  IsEnum,
  IsArray,
  IsOptional,
  IsObject,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { AnteprojectTypeEnum } from '../entities/anteproject.entity';

class TimelineDto {
  @IsString()
  @IsNotEmpty()
  phase: string;

  @IsString()
  @IsNotEmpty()
  date: string; // Using string for simplicity, can be DateString
}

export class CreateAnteprojectDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsEnum(AnteprojectTypeEnum)
  projectType: AnteprojectTypeEnum;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsString()
  @IsNotEmpty()
  academicYear: string;

  @IsInt()
  tutorId: number;

  @IsArray()
  @IsInt({ each: true })
  studentIds: number[];

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  expectedResults?: string[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => TimelineDto)
  timeline?: TimelineDto[];
} 