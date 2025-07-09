import { Type } from 'class-transformer';
import {
  IsArray,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';

class EvaluationCriterionDto {
  @IsInt()
  @IsNotEmpty()
  criteriaId: number;

  @IsNumber()
  @Min(0)
  @Max(10)
  score: number;

  @IsString()
  @IsOptional()
  comments?: string;
}

export class CreateEvaluationDto {
  @IsInt()
  @IsNotEmpty()
  anteprojectId: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => EvaluationCriterionDto)
  evaluations: EvaluationCriterionDto[];
} 