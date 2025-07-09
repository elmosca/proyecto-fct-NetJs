import { PartialType } from '@nestjs/mapped-types';
import { CreateUserDto } from './create-user.dto';
import { IsEnum, IsOptional } from 'class-validator';
import { UserStatus } from '../entities/user.entity';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @IsOptional()
  @IsEnum(UserStatus)
  status?: UserStatus;

  // Se añade explícitamente para la lógica del servicio, 
  // aunque no esté en la entidad.
  password?: string;

  // Se añade para que el servicio pueda asignarlo internamente.
  passwordHash?: string;
} 