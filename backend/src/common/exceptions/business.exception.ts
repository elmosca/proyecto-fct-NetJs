import { HttpException, HttpStatus } from '@nestjs/common';

export enum BusinessErrorCode {
  // Errores de autenticación y autorización
  INVALID_CREDENTIALS = 'INVALID_CREDENTIALS',
  TOKEN_EXPIRED = 'TOKEN_EXPIRED',
  INSUFFICIENT_PERMISSIONS = 'INSUFFICIENT_PERMISSIONS',
  ACCOUNT_DISABLED = 'ACCOUNT_DISABLED',
  
  // Errores de entidades no encontradas
  USER_NOT_FOUND = 'USER_NOT_FOUND',
  PROJECT_NOT_FOUND = 'PROJECT_NOT_FOUND',
  TASK_NOT_FOUND = 'TASK_NOT_FOUND',
  ANTEPROJECT_NOT_FOUND = 'ANTEPROJECT_NOT_FOUND',
  
  // Errores de reglas de negocio
  DUPLICATE_EMAIL = 'DUPLICATE_EMAIL',
  DUPLICATE_NRE = 'DUPLICATE_NRE',
  INVALID_PROJECT_STATUS = 'INVALID_PROJECT_STATUS',
  TASK_ALREADY_ASSIGNED = 'TASK_ALREADY_ASSIGNED',
  CANNOT_DELETE_ENTITY_WITH_DEPENDENCIES = 'CANNOT_DELETE_ENTITY_WITH_DEPENDENCIES',
  
  // Errores de archivos
  FILE_TOO_LARGE = 'FILE_TOO_LARGE',
  INVALID_FILE_TYPE = 'INVALID_FILE_TYPE',
  FILE_UPLOAD_FAILED = 'FILE_UPLOAD_FAILED',
  
  // Errores de validación específicos
  INVALID_DATE_RANGE = 'INVALID_DATE_RANGE',
  DEADLINE_EXCEEDED = 'DEADLINE_EXCEEDED',
  INVALID_TRANSITION = 'INVALID_TRANSITION',
}

export class BusinessException extends HttpException {
  constructor(
    public readonly code: BusinessErrorCode,
    message: string,
    statusCode: HttpStatus = HttpStatus.BAD_REQUEST,
    public readonly details?: any,
  ) {
    super(
      {
        error: code,
        message,
        details,
      },
      statusCode,
    );
  }
}

// Excepciones específicas para casos comunes
export class EntityNotFoundException extends BusinessException {
  constructor(entityName: string, identifier: string | number) {
    super(
      BusinessErrorCode[`${entityName.toUpperCase()}_NOT_FOUND` as keyof typeof BusinessErrorCode] || 
      BusinessErrorCode.USER_NOT_FOUND,
      `${entityName} con ID ${identifier} no encontrado`,
      HttpStatus.NOT_FOUND,
      { entityName, identifier },
    );
  }
}

export class DuplicateEntityException extends BusinessException {
  constructor(entityName: string, field: string, value: string) {
    super(
      BusinessErrorCode[`DUPLICATE_${field.toUpperCase()}` as keyof typeof BusinessErrorCode] || 
      BusinessErrorCode.DUPLICATE_EMAIL,
      `Ya existe un ${entityName} con ${field}: ${value}`,
      HttpStatus.CONFLICT,
      { entityName, field, value },
    );
  }
}

export class InvalidOperationException extends BusinessException {
  constructor(operation: string, reason: string, code?: BusinessErrorCode) {
    super(
      code || BusinessErrorCode.INVALID_TRANSITION,
      `No se puede realizar la operación '${operation}': ${reason}`,
      HttpStatus.BAD_REQUEST,
      { operation, reason },
    );
  }
}

export class UnauthorizedException extends BusinessException {
  constructor(message: string = 'No tienes permisos para realizar esta acción') {
    super(
      BusinessErrorCode.INSUFFICIENT_PERMISSIONS,
      message,
      HttpStatus.FORBIDDEN,
    );
  }
} 