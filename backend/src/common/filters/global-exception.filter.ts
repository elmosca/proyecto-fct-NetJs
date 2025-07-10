import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { QueryFailedError, EntityNotFoundError } from 'typeorm';
import { ValidationError } from 'class-validator';
import { BusinessException } from '../exceptions/business.exception';
import { ErrorResponseDto, ValidationErrorDto } from '../dto/error-response.dto';
import { AppLoggerService } from '../services/logger.service';
import { v4 as uuidv4 } from 'uuid';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  constructor(private readonly appLogger: AppLoggerService) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const errorId = uuidv4();
    const timestamp = new Date().toISOString();
    const path = request.url;
    const method = request.method;
    const ip = request.ip || request.connection.remoteAddress;
    const userAgent = request.get('User-Agent');
    const userId = (request as any).user?.id;

    // Determinar el tipo de error y crear la respuesta apropiada
    const errorResponse = this.buildErrorResponse(
      exception,
      errorId,
      timestamp,
      path,
    );

    // Log del error
    this.logError(
      exception,
      errorResponse,
      {
        method,
        path,
        ip,
        userAgent,
        userId,
        errorId,
      },
    );

    // Enviar respuesta al cliente
    response.status(errorResponse.statusCode).json(errorResponse);
  }

  private buildErrorResponse(
    exception: unknown,
    errorId: string,
    timestamp: string,
    path: string,
  ): ErrorResponseDto {
    // Excepción de negocio personalizada
    if (exception instanceof BusinessException) {
      return {
        statusCode: exception.getStatus(),
        message: exception.message,
        error: exception.code,
        timestamp,
        path,
        details: exception.details,
        errorId,
      };
    }

    // Error HTTP estándar de NestJS
    if (exception instanceof HttpException) {
      const response = exception.getResponse();
      const statusCode = exception.getStatus();

      // Manejar errores de validación
      if (statusCode === HttpStatus.BAD_REQUEST && this.isValidationError(response)) {
        return this.buildValidationErrorResponse(
          response,
          timestamp,
          path,
          errorId,
        );
      }

      return {
        statusCode,
        message: typeof response === 'string' ? response : (response as any).message || exception.message,
        error: typeof response === 'string' ? 'HTTP_EXCEPTION' : (response as any).error || 'HTTP_EXCEPTION',
        timestamp,
        path,
        errorId,
      };
    }

    // Errores de TypeORM
    if (exception instanceof QueryFailedError) {
      return this.buildDatabaseErrorResponse(exception, timestamp, path, errorId);
    }

    if (exception instanceof EntityNotFoundError) {
      return {
        statusCode: HttpStatus.NOT_FOUND,
        message: 'La entidad solicitada no fue encontrada',
        error: 'ENTITY_NOT_FOUND',
        timestamp,
        path,
        errorId,
      };
    }

    // Error no controlado - Error interno del servidor
    return {
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      message: 'Ha ocurrido un error interno del servidor',
      error: 'INTERNAL_SERVER_ERROR',
      timestamp,
      path,
      errorId,
      details: process.env.NODE_ENV === 'development' ? {
        originalMessage: (exception as Error)?.message,
        stack: (exception as Error)?.stack,
      } : undefined,
    };
  }

  private buildValidationErrorResponse(
    response: any,
    timestamp: string,
    path: string,
    errorId: string,
  ): ValidationErrorDto {
    const messages = Array.isArray(response.message) ? response.message : [response.message];
    
    // Organizar errores por campo
    const fieldErrors: Record<string, string[]> = {};
    messages.forEach((msg: string) => {
      // Extraer el campo del mensaje si es posible
      const fieldMatch = msg.match(/^(\w+)\s+(.+)$/);
      if (fieldMatch) {
        const [, field, error] = fieldMatch;
        if (!fieldErrors[field]) {
          fieldErrors[field] = [];
        }
        fieldErrors[field].push(error);
      } else {
        if (!fieldErrors.general) {
          fieldErrors.general = [];
        }
        fieldErrors.general.push(msg);
      }
    });

    return {
      statusCode: HttpStatus.BAD_REQUEST,
      message: messages,
      error: 'VALIDATION_ERROR',
      timestamp,
      path,
      details: fieldErrors,
      errorId,
    };
  }

  private buildDatabaseErrorResponse(
    error: QueryFailedError,
    timestamp: string,
    path: string,
    errorId: string,
  ): ErrorResponseDto {
    let message = 'Error en la base de datos';
    let errorCode = 'DATABASE_ERROR';

    // Identificar tipos específicos de errores de PostgreSQL
    if (error.message.includes('duplicate key value')) {
      message = 'Ya existe un registro con estos datos';
      errorCode = 'DUPLICATE_ENTRY';
    } else if (error.message.includes('foreign key constraint')) {
      message = 'No se puede realizar la operación debido a dependencias existentes';
      errorCode = 'FOREIGN_KEY_CONSTRAINT';
    } else if (error.message.includes('not null constraint')) {
      message = 'Faltan campos obligatorios';
      errorCode = 'NOT_NULL_CONSTRAINT';
    } else if (error.message.includes('check constraint')) {
      message = 'Los datos no cumplen con las reglas de validación';
      errorCode = 'CHECK_CONSTRAINT';
    }

    return {
      statusCode: HttpStatus.BAD_REQUEST,
      message,
      error: errorCode,
      timestamp,
      path,
      errorId,
      details: process.env.NODE_ENV === 'development' ? {
        originalError: error.message,
        query: error.query,
        parameters: error.parameters,
      } : undefined,
    };
  }

  private isValidationError(response: any): boolean {
    return (
      response &&
      typeof response === 'object' &&
      Array.isArray(response.message) &&
      response.error === 'Bad Request'
    );
  }

  private logError(
    exception: unknown,
    errorResponse: ErrorResponseDto,
    context: {
      method: string;
      path: string;
      ip?: string;
      userAgent?: string;
      userId?: number;
      errorId: string;
    },
  ): void {
    const { method, path, ip, userAgent, userId, errorId } = context;
    
    const logMessage = `${method} ${path} - ${errorResponse.statusCode} ${errorResponse.error}`;
    
    const metadata = {
      errorId,
      statusCode: errorResponse.statusCode,
      error: errorResponse.error,
      message: errorResponse.message,
      userId,
      ip,
      userAgent,
      details: errorResponse.details,
    };

    // Log nivel ERROR para códigos 5xx, WARN para 4xx
    if (errorResponse.statusCode >= 500) {
      this.appLogger.error(
        logMessage,
        exception instanceof Error ? exception.stack : undefined,
        'GlobalExceptionFilter',
      );
      
      // Log adicional con metadata completa para errores críticos
      this.logger.error(`Critical error occurred: ${logMessage}`, {
        ...metadata,
        exception: exception instanceof Error ? {
          name: exception.name,
          message: exception.message,
          stack: exception.stack,
        } : exception,
      });
    } else {
      this.appLogger.warn(logMessage, 'GlobalExceptionFilter');
    }

    // Log específico para errores de autenticación
    if (errorResponse.error.includes('AUTH') || errorResponse.error.includes('UNAUTHORIZED')) {
      this.appLogger.logAuthentication(
        'failed_login',
        userId,
        undefined,
        ip,
      );
    }
  }
} 