import { ApiProperty } from '@nestjs/swagger';

export class ErrorResponseDto {
  @ApiProperty({
    description: 'Código de estado HTTP',
    example: 400,
  })
  statusCode: number;

  @ApiProperty({
    description: 'Mensaje principal del error',
    example: 'Validation failed',
  })
  message: string | string[];

  @ApiProperty({
    description: 'Tipo específico del error',
    example: 'BAD_REQUEST',
  })
  error: string;

  @ApiProperty({
    description: 'Timestamp cuando ocurrió el error',
    example: '2024-01-15T10:30:00.000Z',
  })
  timestamp: string;

  @ApiProperty({
    description: 'Ruta donde ocurrió el error',
    example: '/api/v1/users',
  })
  path: string;

  @ApiProperty({
    description: 'Detalles adicionales del error (opcional)',
    example: { field: 'email', constraint: 'isEmail' },
    required: false,
  })
  details?: any;

  @ApiProperty({
    description: 'ID único del error para tracking (opcional)',
    example: 'err_1234567890',
    required: false,
  })
  errorId?: string;
}

export class ValidationErrorDto extends ErrorResponseDto {
  @ApiProperty({
    description: 'Lista de errores de validación específicos',
    type: [String],
    example: [
      'email must be a valid email',
      'password must be longer than 6 characters',
    ],
  })
  message: string[];

  @ApiProperty({
    description: 'Campos que fallaron la validación',
    example: {
      email: ['must be a valid email'],
      password: ['must be longer than 6 characters'],
    },
  })
  details: Record<string, string[]>;
} 