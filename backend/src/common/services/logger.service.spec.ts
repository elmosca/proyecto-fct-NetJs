import { ConfigService } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import * as fs from 'fs';
import { AppLoggerService } from './logger.service';

// Mock fs module
jest.mock('fs');
const mockFs = fs as jest.Mocked<typeof fs>;

describe('AppLoggerService', () => {
  let service: AppLoggerService;
  let configService: ConfigService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AppLoggerService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key: string, defaultValue: any) => {
              const config = {
                LOG_DIR: './test-logs',
                ENABLE_FILE_LOGGING: true,
                ENABLE_CONSOLE_LOGGING: true,
                LOG_LEVEL: 'info',
                NODE_ENV: 'test',
              };
              return config[key] || defaultValue;
            }),
          },
        },
      ],
    }).compile();

    service = module.get<AppLoggerService>(AppLoggerService);
    configService = module.get<ConfigService>(ConfigService);

    // Mock fs methods
    mockFs.existsSync.mockReturnValue(true);
    mockFs.mkdirSync.mockImplementation();
    mockFs.appendFileSync.mockImplementation();
    mockFs.readdirSync.mockReturnValue(['old-log-2023-01-01.log'] as any);
    mockFs.statSync.mockReturnValue({ mtime: new Date('2023-01-01') } as any);
    mockFs.unlinkSync.mockImplementation();

    // Mock console methods
    jest.spyOn(console, 'log').mockImplementation();
    jest.spyOn(console, 'error').mockImplementation();
    jest.spyOn(console, 'warn').mockImplementation();
    jest.spyOn(console, 'debug').mockImplementation();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('Basic logging methods', () => {
    it('should log info messages', () => {
      service.log('Test info message', 'TestContext');

      expect(mockFs.appendFileSync).toHaveBeenCalled();
      expect(console.log).toHaveBeenCalled();
    });

    it('should log error messages with stack trace', () => {
      const errorStack = 'Error: Test error\n    at TestFunction';
      
      service.error('Test error message', errorStack, 'TestContext');

      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('error'),
        expect.stringContaining('Test error message'),
      );
      expect(console.error).toHaveBeenCalled();
    });

    it('should log warning messages', () => {
      service.warn('Test warning message', 'TestContext');

      expect(mockFs.appendFileSync).toHaveBeenCalled();
      expect(console.warn).toHaveBeenCalled();
    });

    it('should log debug messages', () => {
      service.debug('Test debug message', 'TestContext');

      expect(mockFs.appendFileSync).toHaveBeenCalled();
      expect(console.debug).toHaveBeenCalled();
    });
  });

  describe('HTTP logging', () => {
    it('should log HTTP requests', () => {
      service.logHttpRequest(
        'GET',
        '/api/users',
        1,
        'req-123',
        '127.0.0.1',
        'test-user-agent',
      );

      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('http'),
        expect.stringContaining('GET /api/users'),
      );
    });

    it('should log HTTP responses', () => {
      service.logHttpResponse(
        'POST',
        '/api/users',
        201,
        150,
        'req-123',
      );

      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('http'),
        expect.stringContaining('POST /api/users - 201 (150ms)'),
      );
    });
  });

  describe('Authentication logging', () => {
    it('should log login events', () => {
      service.logAuthentication(
        'login',
        1,
        'test@example.com',
        '127.0.0.1',
      );

      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('app'),
        expect.stringContaining('Authentication login for test@example.com'),
      );
    });

    it('should log failed login events', () => {
      service.logAuthentication(
        'failed_login',
        undefined,
        'test@example.com',
        '127.0.0.1',
      );

      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('app'),
        expect.stringContaining('Authentication failed_login for test@example.com'),
      );
    });
  });

  describe('Business operation logging', () => {
    it('should log business operations', () => {
      service.logBusinessOperation(
        'CREATE',
        'User',
        123,
        1,
        { additionalData: 'test' },
      );

      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('app'),
        expect.stringContaining('CREATE User 123'),
      );
    });
  });

  describe('Database query logging', () => {
    it('should log database queries', () => {
      service.logDatabaseQuery(
        'SELECT * FROM users WHERE id = $1',
        45,
        'UserRepository',
      );

      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('app'),
        expect.stringContaining('Query executed in 45ms'),
      );
    });
  });

  describe('File logging configuration', () => {
    it('should not write to file when file logging is disabled', () => {
      // Create a new service instance with file logging disabled
      const moduleWithDisabledFileLogging = Test.createTestingModule({
        providers: [
          AppLoggerService,
          {
            provide: ConfigService,
            useValue: {
              get: jest.fn((key: string, defaultValue: any) => {
                if (key === 'ENABLE_FILE_LOGGING') return false;
                return defaultValue;
              }),
            },
          },
        ],
      }).compile();

      moduleWithDisabledFileLogging.then(module => {
        const disabledService = module.get<AppLoggerService>(AppLoggerService);
        
        mockFs.appendFileSync.mockClear();
        
        disabledService.log('Test message');
        
        expect(mockFs.appendFileSync).not.toHaveBeenCalled();
      });
    });

    it('should create log directory if it does not exist', async () => {
      mockFs.existsSync.mockReturnValue(false);
      
      // Create a new service instance to trigger directory creation
      await Test.createTestingModule({
        providers: [
          AppLoggerService,
          {
            provide: ConfigService,
            useValue: {
              get: jest.fn((key: string, defaultValue: any) => defaultValue),
            },
          },
        ],
      }).compile();

      expect(mockFs.mkdirSync).toHaveBeenCalledWith(
        expect.any(String),
        { recursive: true },
      );
    });
  });

  describe('Log cleanup', () => {
    it('should clean old log files', () => {
      const pastDate = new Date();
      pastDate.setDate(pastDate.getDate() - 40); // 40 days ago
      
      mockFs.statSync.mockReturnValue({ mtime: pastDate } as any);
      
      service.cleanOldLogs(30);

      expect(mockFs.unlinkSync).toHaveBeenCalled();
    });

    it('should keep recent log files', () => {
      const recentDate = new Date();
      recentDate.setDate(recentDate.getDate() - 10); // 10 days ago
      
      mockFs.statSync.mockReturnValue({ mtime: recentDate } as any);
      
      service.cleanOldLogs(30);

      expect(mockFs.unlinkSync).not.toHaveBeenCalled();
    });

    it('should handle cleanup errors gracefully', () => {
      mockFs.readdirSync.mockImplementation(() => {
        throw new Error('Cannot read directory');
      });

      expect(() => service.cleanOldLogs(30)).not.toThrow();
      expect(mockFs.appendFileSync).toHaveBeenCalledWith(
        expect.stringContaining('error'),
        expect.stringContaining('Failed to clean old logs'),
      );
    });
  });
}); 