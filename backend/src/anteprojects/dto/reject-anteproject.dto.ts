import { IsString, IsNotEmpty } from 'class-validator';

export class RejectAnteprojectDto {
  @IsString()
  @IsNotEmpty()
  tutorComments: string;
}
