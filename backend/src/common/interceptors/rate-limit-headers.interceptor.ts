import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Request, Response } from 'express';
import { AppLoggerService } from '../services/logger.service';

@Injectable()
export class RateLimitHeadersInterceptor implements NestInterceptor {
  constructor(private readonly logger: AppLoggerService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();
    
    // Añadir headers informativos básicos
    response.setHeader('X-RateLimit-Policy', 'active');
    response.setHeader('X-RateLimit-Service', 'nestjs-throttler');
    
    return next.handle().pipe(
      tap(() => {
        // Log de actividad de rate limiting si es necesario
        const user = (request as any).user;
        if (user) {
          this.logger.debug(
            `Rate limit check: ${request.method} ${request.url}`,
            'RateLimitInterceptor',
          );
        }
      }),
    );
  }
} 