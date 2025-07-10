import { PartialType } from '@nestjs/swagger';
import { CreateAnteprojectDto } from './create-anteproject.dto';

export class UpdateAnteprojectDto extends PartialType(CreateAnteprojectDto) {}
