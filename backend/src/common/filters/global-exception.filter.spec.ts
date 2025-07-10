import { Test, TestingModule } from '@nestjs/testing';
import { ArgumentsHost, HttpStatus } from '@nestjs/common';
import { GlobalExceptionFilter } from './global-exception.filter';
import { AppLoggerService } from '../services/logger.service';
import { BusinessException, BusinessErrorCode } from '../exceptions/business.exception';
import { ConfigService } from '@nestjs/config';

describe('GlobalExceptionFilter', () => {
  let filter: GlobalExceptionFilter;
  let logger: AppLoggerService;

  const mockRequest = {
    url: '/test-endpoint',
    method: 'POST',
    ip: '127.0.0.1',
    get: jest.fn().mockReturnValue('test-user-agent'),
    connection: { remoteAddress: '127.0.0.1' },
    user: { id: 1 },
  };

  const mockResponse = {
    status: jest.fn().mockReturnThis(),
    json: jest.fn(),
  };

  const mockArgumentsHost = {
    switchToHttp: () => ({
      getResponse: () => mockResponse,
      getRequest: () => mockRequest,
    }),
  } as ArgumentsHost;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GlobalExceptionFilter,
        {
          provide: AppLoggerService,
          useValue: {
            error: jest.fn(),
            warn: jest.fn(),
            logAuthentication: jest.fn(),
          },
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn().mockReturnValue('test'),
          },
        },
      ],
    }).compile();

    filter = module.get<GlobalExceptionFilter>(GlobalExceptionFilter);
    logger = module.get<AppLoggerService>(AppLoggerService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(filter).toBeDefined();
  });

  describe('BusinessException handling', () => {
    it('should handle BusinessException correctly', () => {
      const exception = new BusinessException(
        BusinessErrorCode.USER_NOT_FOUND,
        'Usuario no encontrado',
        HttpStatus.NOT_FOUND,
        { userId: 1 },
      );

      filter.catch(exception, mockArgumentsHost);

      expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusCode: HttpStatus.NOT_FOUND,
          message: 'Usuario no encontrado',
          error: BusinessErrorCode.USER_NOT_FOUND,
          details: { userId: 1 },
          timestamp: expect.any(String),
          path: '/test-endpoint',
          errorId: expect.any(String),
        }),
      );
      expect(logger.warn).toHaveBeenCalled();
    });
  });

  describe('HTTP Exception handling', () => {
    it('should handle validation errors correctly', () => {
      const validationError = {
        getStatus: () => HttpStatus.BAD_REQUEST,
        getResponse: () => ({
          error: 'Bad Request',
          message: ['email must be a valid email', 'password must be longer than 6 characters'],
        }),
        message: 'Validation failed',
      };

      filter.catch(validationError as any, mockArgumentsHost);

      expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusCode: HttpStatus.BAD_REQUEST,
          message: ['email must be a valid email', 'password must be longer than 6 characters'],
          error: 'VALIDATION_ERROR',
          details: expect.any(Object),
        }),
      );
    });

    it('should handle general HTTP exceptions', () => {
      const httpError = {
        getStatus: () => HttpStatus.FORBIDDEN,
        getResponse: () => 'Access forbidden',
        message: 'Forbidden',
      };

      filter.catch(httpError as any, mockArgumentsHost);

      expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.FORBIDDEN);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusCode: HttpStatus.FORBIDDEN,
          message: 'Access forbidden',
          error: 'HTTP_EXCEPTION',
        }),
      );
    });
  });

  describe('Database errors', () => {
    it('should handle duplicate key errors', () => {
      const dbError = {
        message: 'duplicate key value violates unique constraint',
        query: 'INSERT INTO users...',
        parameters: ['test@example.com'],
      };

      filter.catch(dbError as any, mockArgumentsHost);

      expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusCode: HttpStatus.BAD_REQUEST,
          message: 'Ya existe un registro con estos datos',
          error: 'DUPLICATE_ENTRY',
        }),
      );
    });

    it('should handle foreign key constraint errors', () => {
      const dbError = {
        message: 'foreign key constraint fails',
        query: 'DELETE FROM projects...',
        parameters: [1],
      };

      filter.catch(dbError as any, mockArgumentsHost);

      expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusCode: HttpStatus.BAD_REQUEST,
          message: 'No se puede realizar la operación debido a dependencias existentes',
          error: 'FOREIGN_KEY_CONSTRAINT',
        }),
      );
    });
  });

  describe('Unhandled errors', () => {
    it('should handle unknown errors as internal server error', () => {
      const unknownError = new Error('Something went wrong');

      filter.catch(unknownError, mockArgumentsHost);

      expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
      expect(mockResponse.json).toHaveBeenCalledWith(
        expect.objectContaining({
          statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
          message: 'Ha ocurrido un error interno del servidor',
          error: 'INTERNAL_SERVER_ERROR',
        }),
      );
      expect(logger.error).toHaveBeenCalled();
    });
  });

  describe('Logging behavior', () => {
    it('should log authentication failures', () => {
      const authError = new BusinessException(
        BusinessErrorCode.INVALID_CREDENTIALS,
        'Invalid credentials',
        HttpStatus.UNAUTHORIZED,
      );

      filter.catch(authError, mockArgumentsHost);

      expect(logger.logAuthentication).toHaveBeenCalledWith(
        'failed_login',
        1,
        undefined,
        '127.0.0.1',
      );
    });

    it('should use error level for 5xx status codes', () => {
      const serverError = new Error('Internal error');

      filter.catch(serverError, mockArgumentsHost);

      expect(logger.error).toHaveBeenCalled();
    });

    it('should use warn level for 4xx status codes', () => {
      const clientError = new BusinessException(
        BusinessErrorCode.USER_NOT_FOUND,
        'User not found',
        HttpStatus.NOT_FOUND,
      );

      filter.catch(clientError, mockArgumentsHost);

      expect(logger.warn).toHaveBeenCalled();
      expect(logger.error).not.toHaveBeenCalled();
    });
  });
}); 