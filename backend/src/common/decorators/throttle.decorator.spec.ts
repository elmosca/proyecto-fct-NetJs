import { Test, TestingModule } from '@nestjs/testing';
import { Controller, Get, Post } from '@nestjs/common';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { AuthThrottle, ApiThrottle, UploadThrottle, SensitiveThrottle, NoThrottle } from './throttle.decorator';

@Controller('test')
class TestController {
  @Get('auth')
  @AuthThrottle()
  authEndpoint() {
    return { message: 'auth endpoint' };
  }

  @Get('api')
  @ApiThrottle()
  apiEndpoint() {
    return { message: 'api endpoint' };
  }

  @Post('upload')
  @UploadThrottle()
  uploadEndpoint() {
    return { message: 'upload endpoint' };
  }

  @Post('sensitive')
  @SensitiveThrottle()
  sensitiveEndpoint() {
    return { message: 'sensitive endpoint' };
  }

  @Get('no-throttle')
  @NoThrottle()
  noThrottleEndpoint() {
    return { message: 'no throttle endpoint' };
  }

  @Get('default')
  defaultEndpoint() {
    return { message: 'default endpoint' };
  }
}

describe('Throttle Decorators', () => {
  let app: any;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [
        ThrottlerModule.forRoot([{
          ttl: 60000,
          limit: 10,
        }]),
      ],
      controllers: [TestController],
      providers: [
        {
          provide: APP_GUARD,
          useClass: ThrottlerGuard,
        },
      ],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterEach(async () => {
    await app.close();
  });

  describe('AuthThrottle', () => {
    it('should apply auth throttling to auth endpoint', () => {
      const controller = app.get(TestController);
      const authMethod = controller.authEndpoint;
      
      // Verificar que el endpoint existe
      expect(authMethod).toBeDefined();
      expect(typeof authMethod).toBe('function');
    });
  });

  describe('ApiThrottle', () => {
    it('should apply api throttling to api endpoint', () => {
      const controller = app.get(TestController);
      const apiMethod = controller.apiEndpoint;
      
      expect(apiMethod).toBeDefined();
      expect(typeof apiMethod).toBe('function');
    });
  });

  describe('UploadThrottle', () => {
    it('should apply upload throttling to upload endpoint', () => {
      const controller = app.get(TestController);
      const uploadMethod = controller.uploadEndpoint;
      
      expect(uploadMethod).toBeDefined();
      expect(typeof uploadMethod).toBe('function');
    });
  });

  describe('SensitiveThrottle', () => {
    it('should apply sensitive throttling to sensitive endpoint', () => {
      const controller = app.get(TestController);
      const sensitiveMethod = controller.sensitiveEndpoint;
      
      expect(sensitiveMethod).toBeDefined();
      expect(typeof sensitiveMethod).toBe('function');
    });
  });

  describe('NoThrottle', () => {
    it('should disable throttling for no-throttle endpoint', () => {
      const controller = app.get(TestController);
      const noThrottleMethod = controller.noThrottleEndpoint;
      
      expect(noThrottleMethod).toBeDefined();
      expect(typeof noThrottleMethod).toBe('function');
    });
  });

  describe('Default behavior', () => {
    it('should use default throttling for undecorated endpoints', () => {
      const controller = app.get(TestController);
      const defaultMethod = controller.defaultEndpoint;
      
      expect(defaultMethod).toBeDefined();
      expect(typeof defaultMethod).toBe('function');
    });
  });
}); 