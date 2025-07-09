import { ApiProperty } from '@nestjs/swagger';
import { IsDate, IsString, IsNotEmpty } from 'class-validator';

export class ScheduleDefenseDto {
  @ApiProperty({
    description: 'The date and time of the defense.',
    example: '2024-08-15T10:00:00.000Z',
  })
  @IsDate()
  @IsNotEmpty()
  defenseDate: Date;

  @ApiProperty({
    description: 'The location where the defense will take place.',
    example: 'Room 404',
  })
  @IsString()
  @IsNotEmpty()
  defenseLocation: string;
} 