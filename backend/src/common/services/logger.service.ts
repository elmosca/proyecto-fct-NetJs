import { Injectable, LoggerService, LogLevel } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as path from 'path';

export enum LogEventType {
  ERROR = 'ERROR',
  WARN = 'WARN',
  INFO = 'INFO',
  DEBUG = 'DEBUG',
  HTTP_REQUEST = 'HTTP_REQUEST',
  HTTP_RESPONSE = 'HTTP_RESPONSE',
  DATABASE_QUERY = 'DATABASE_QUERY',
  AUTHENTICATION = 'AUTHENTICATION',
  BUSINESS_OPERATION = 'BUSINESS_OPERATION',
}

export interface LogEntry {
  timestamp: Date;
  level: LogEventType;
  message: string;
  context?: string;
  metadata?: any;
  userId?: number;
  requestId?: string;
  ip?: string;
  userAgent?: string;
  stack?: string;
}

@Injectable()
export class AppLoggerService implements LoggerService {
  private readonly logDir: string;
  private readonly enableFileLogging: boolean;
  private readonly enableConsoleLogging: boolean;
  private readonly logLevel: LogLevel[];

  constructor(private readonly configService: ConfigService) {
    this.logDir = this.configService.get<string>('LOG_DIR', './logs');
    this.enableFileLogging = this.configService.get<boolean>('ENABLE_FILE_LOGGING', true);
    this.enableConsoleLogging = this.configService.get<boolean>('ENABLE_CONSOLE_LOGGING', true);
    this.logLevel = this.getLogLevels();
    
    if (this.enableFileLogging) {
      this.ensureLogDirectory();
    }
  }

  private getLogLevels(): LogLevel[] {
    const level = this.configService.get<string>('LOG_LEVEL', 'info');
    
    switch (level.toLowerCase()) {
      case 'error':
        return ['error'];
      case 'warn':
        return ['error', 'warn'];
      case 'info':
        return ['error', 'warn', 'log'];
      case 'debug':
        return ['error', 'warn', 'log', 'debug', 'verbose'];
      default:
        return ['error', 'warn', 'log'];
    }
  }

  private ensureLogDirectory(): void {
    if (!fs.existsSync(this.logDir)) {
      fs.mkdirSync(this.logDir, { recursive: true });
    }
  }

  private getLogFileName(type: string): string {
    const date = new Date().toISOString().split('T')[0];
    return path.join(this.logDir, `${type}-${date}.log`);
  }

  private formatLogEntry(entry: LogEntry): string {
    const timestamp = entry.timestamp.toISOString();
    const level = entry.level.padEnd(8);
    const context = entry.context ? `[${entry.context}]` : '';
    const requestId = entry.requestId ? `[${entry.requestId}]` : '';
    const userId = entry.userId ? `[User:${entry.userId}]` : '';
    
    let logLine = `${timestamp} ${level} ${context}${requestId}${userId} ${entry.message}`;
    
    if (entry.metadata) {
      logLine += ` | Metadata: ${JSON.stringify(entry.metadata)}`;
    }
    
    if (entry.stack) {
      logLine += `\n${entry.stack}`;
    }
    
    return logLine;
  }

  private writeToFile(entry: LogEntry): void {
    if (!this.enableFileLogging) return;

    try {
      const logLine = this.formatLogEntry(entry) + '\n';
      
      // Escribir al archivo general
      fs.appendFileSync(this.getLogFileName('app'), logLine);
      
      // Escribir al archivo específico del tipo si es error
      if (entry.level === LogEventType.ERROR) {
        fs.appendFileSync(this.getLogFileName('error'), logLine);
      }
      
      // Archivo separado para requests HTTP
      if (entry.level === LogEventType.HTTP_REQUEST || entry.level === LogEventType.HTTP_RESPONSE) {
        fs.appendFileSync(this.getLogFileName('http'), logLine);
      }
    } catch (error) {
      // Evitar recursión infinita si falla el logging
      console.error('Failed to write log to file:', error);
    }
  }

  private logEntry(level: LogEventType, message: string, context?: string, metadata?: any): void {
    const entry: LogEntry = {
      timestamp: new Date(),
      level,
      message,
      context,
      metadata,
    };

    // Escribir a archivo
    this.writeToFile(entry);

    // Mostrar en consola si está habilitado
    if (this.enableConsoleLogging) {
      const formattedMessage = this.formatLogEntry(entry);
      
      switch (level) {
        case LogEventType.ERROR:
          console.error(formattedMessage);
          break;
        case LogEventType.WARN:
          console.warn(formattedMessage);
          break;
        case LogEventType.DEBUG:
          console.debug(formattedMessage);
          break;
        default:
          console.log(formattedMessage);
      }
    }
  }

  // Implementación de LoggerService (NestJS interface)
  log(message: any, context?: string): void {
    this.logEntry(LogEventType.INFO, message, context);
  }

  error(message: any, stack?: string, context?: string): void {
    this.logEntry(LogEventType.ERROR, message, context, { stack });
  }

  warn(message: any, context?: string): void {
    this.logEntry(LogEventType.WARN, message, context);
  }

  debug(message: any, context?: string): void {
    this.logEntry(LogEventType.DEBUG, message, context);
  }

  verbose(message: any, context?: string): void {
    this.logEntry(LogEventType.DEBUG, message, context);
  }

  // Métodos específicos del dominio
  logHttpRequest(
    method: string,
    url: string,
    userId?: number,
    requestId?: string,
    ip?: string,
    userAgent?: string,
  ): void {
    this.logEntry(
      LogEventType.HTTP_REQUEST,
      `${method} ${url}`,
      'HTTP',
      { userId, requestId, ip, userAgent },
    );
  }

  logHttpResponse(
    method: string,
    url: string,
    statusCode: number,
    responseTime: number,
    requestId?: string,
  ): void {
    this.logEntry(
      LogEventType.HTTP_RESPONSE,
      `${method} ${url} - ${statusCode} (${responseTime}ms)`,
      'HTTP',
      { statusCode, responseTime, requestId },
    );
  }

  logAuthentication(
    event: 'login' | 'logout' | 'failed_login' | 'token_refresh',
    userId?: number,
    email?: string,
    ip?: string,
  ): void {
    this.logEntry(
      LogEventType.AUTHENTICATION,
      `Authentication ${event}${email ? ` for ${email}` : ''}`,
      'AUTH',
      { event, userId, email, ip },
    );
  }

  logBusinessOperation(
    operation: string,
    entityType: string,
    entityId: string | number,
    userId: number,
    details?: any,
  ): void {
    this.logEntry(
      LogEventType.BUSINESS_OPERATION,
      `${operation} ${entityType} ${entityId}`,
      'BUSINESS',
      { operation, entityType, entityId, userId, ...details },
    );
  }

  logDatabaseQuery(
    query: string,
    executionTime: number,
    context?: string,
  ): void {
    this.logEntry(
      LogEventType.DATABASE_QUERY,
      `Query executed in ${executionTime}ms`,
      context || 'DATABASE',
      { query: query.replace(/\s+/g, ' ').trim(), executionTime },
    );
  }

  // Método para limpiar logs antiguos
  cleanOldLogs(daysToKeep: number = 30): void {
    if (!this.enableFileLogging) return;

    try {
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - daysToKeep);

      const files = fs.readdirSync(this.logDir);
      
      files.forEach(file => {
        const filePath = path.join(this.logDir, file);
        const stats = fs.statSync(filePath);
        
        if (stats.mtime < cutoffDate) {
          fs.unlinkSync(filePath);
          this.log(`Deleted old log file: ${file}`, 'LogCleanup');
        }
      });
    } catch (error) {
      this.error('Failed to clean old logs', error.stack, 'LogCleanup');
    }
  }
} 