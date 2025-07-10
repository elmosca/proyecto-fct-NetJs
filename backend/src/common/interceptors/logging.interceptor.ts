import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { Request, Response } from 'express';
import { AppLoggerService } from '../services/logger.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  constructor(private readonly logger: AppLoggerService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();
    
    const method = request.method;
    const url = request.url;
    const ip = request.ip || request.connection.remoteAddress;
    const userAgent = request.get('User-Agent');
    const userId = (request as any).user?.id;
    const requestId = uuidv4();
    
    // Añadir requestId al request para usar en otros lugares
    (request as any).requestId = requestId;
    
    const startTime = Date.now();

    // Log de entrada del request
    this.logger.logHttpRequest(
      method,
      url,
      userId,
      requestId,
      ip,
      userAgent,
    );

    // Log del body para requests que no sean GET (solo en development)
    if (process.env.NODE_ENV === 'development' && method !== 'GET') {
      const body = this.sanitizeRequestBody(request.body);
      if (body && Object.keys(body).length > 0) {
        this.logger.log(
          `Request body: ${JSON.stringify(body)}`,
          `HTTP-${requestId}`,
        );
      }
    }

    return next.handle().pipe(
      tap((responseBody) => {
        const responseTime = Date.now() - startTime;
        const statusCode = response.statusCode;

        // Log de salida del response
        this.logger.logHttpResponse(
          method,
          url,
          statusCode,
          responseTime,
          requestId,
        );

        // Log del response body solo en development y para ciertos endpoints
        if (process.env.NODE_ENV === 'development' && this.shouldLogResponseBody(url)) {
          const sanitizedResponse = this.sanitizeResponseBody(responseBody);
          this.logger.log(
            `Response body: ${JSON.stringify(sanitizedResponse)}`,
            `HTTP-${requestId}`,
          );
        }

        // Log de performance para requests lentos
        if (responseTime > 1000) {
          this.logger.warn(
            `Slow request detected: ${method} ${url} took ${responseTime}ms`,
            'Performance',
          );
        }
      }),
      catchError((error) => {
        const responseTime = Date.now() - startTime;
        
        // El error será manejado por el GlobalExceptionFilter
        // Aquí solo loggeamos información adicional del interceptor
        this.logger.error(
          `Request failed: ${method} ${url} after ${responseTime}ms`,
          error.stack,
          `HTTP-${requestId}`,
        );
        
        throw error;
      }),
    );
  }

  private sanitizeRequestBody(body: any): any {
    if (!body || typeof body !== 'object') {
      return body;
    }

    const sanitized = { ...body };
    
    // Campos sensibles que no deben aparecer en logs
    const sensitiveFields = [
      'password',
      'passwordHash',
      'token',
      'accessToken',
      'refreshToken',
      'secret',
      'key',
      'authorization',
    ];

    sensitiveFields.forEach(field => {
      if (sanitized[field]) {
        sanitized[field] = '[REDACTED]';
      }
    });

    return sanitized;
  }

  private sanitizeResponseBody(body: any): any {
    if (!body || typeof body !== 'object') {
      return body;
    }

    // No loggear respuestas muy grandes
    const bodyString = JSON.stringify(body);
    if (bodyString.length > 1000) {
      return {
        message: '[Response too large to log]',
        size: bodyString.length,
      };
    }

    const sanitized = { ...body };
    
    // Ocultar tokens en respuestas
    if (sanitized.accessToken) {
      sanitized.accessToken = '[REDACTED]';
    }
    if (sanitized.refreshToken) {
      sanitized.refreshToken = '[REDACTED]';
    }

    return sanitized;
  }

  private shouldLogResponseBody(url: string): boolean {
    // No loggear response body para estos endpoints
    const excludedPaths = [
      '/auth/login',
      '/auth/refresh',
      '/files',
      '/uploads',
    ];

    return !excludedPaths.some(path => url.includes(path));
  }
} 