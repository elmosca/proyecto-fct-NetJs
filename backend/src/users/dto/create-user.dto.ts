import {
  IsEmail,
  IsString,
  IsOptional,
  IsEnum,
  IsNotEmpty,
  MinLength,
  IsPhoneNumber,
} from 'class-validator';
import { RoleEnum } from '../../roles/roles.enum';

export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;

  @IsString()
  @IsNotEmpty()
  fullName: string;

  @IsOptional()
  @IsEnum(RoleEnum)
  role?: RoleEnum;

  @IsOptional()
  @IsString()
  nre?: string;

  @IsOptional()
  @IsPhoneNumber('ES')
  phone?: string;

  @IsOptional()
  @IsString()
  biography?: string;
} 