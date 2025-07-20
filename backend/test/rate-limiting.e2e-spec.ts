import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { Controller, Get, Post } from '@nestjs/common';
import { AuthThrottle, UploadThrottle } from '../src/common/decorators/throttle.decorator';

@Controller('rate-limit-test')
class RateLimitTestController {
  @Get('normal')
  normalEndpoint() {
    return { message: 'normal endpoint', timestamp: Date.now() };
  }

  @Post('auth')
  @AuthThrottle()
  authEndpoint() {
    return { message: 'auth endpoint', timestamp: Date.now() };
  }

  @Post('upload')
  @UploadThrottle()
  uploadEndpoint() {
    return { message: 'upload endpoint', timestamp: Date.now() };
  }
}

describe('Rate Limiting (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [
        ThrottlerModule.forRoot([{
          ttl: 60000, // 1 minuto
          limit: 5, // 5 requests por defecto
        }]),
      ],
      controllers: [RateLimitTestController],
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

  describe('Default rate limiting', () => {
    it('should allow requests within limit', async () => {
      // Hacer 5 requests (dentro del límite)
      for (let i = 0; i < 5; i++) {
        const response = await request(app.getHttpServer())
          .get('/rate-limit-test/normal')
          .expect(200);

        expect(response.body).toHaveProperty('message', 'normal endpoint');
        expect(response.headers).toHaveProperty('x-ratelimit-policy');
      }
    });

    it('should block requests exceeding limit', async () => {
      // Hacer 6 requests (exceder el límite de 5)
      for (let i = 0; i < 5; i++) {
        await request(app.getHttpServer())
          .get('/rate-limit-test/normal')
          .expect(200);
      }

      // El 6to request debería fallar
      const response = await request(app.getHttpServer())
        .get('/rate-limit-test/normal')
        .expect(429);

      expect(response.body).toHaveProperty('message');
      expect(response.headers).toHaveProperty('retry-after');
    });
  });

  describe('Auth throttling', () => {
    it('should apply stricter limits to auth endpoints', async () => {
      // Los endpoints de auth tienen límite de 5 por minuto
      for (let i = 0; i < 5; i++) {
        await request(app.getHttpServer())
          .post('/rate-limit-test/auth')
          .expect(200);
      }

      // El 6to request debería fallar
      await request(app.getHttpServer())
        .post('/rate-limit-test/auth')
        .expect(429);
    });
  });

  describe('Upload throttling', () => {
    it('should apply very strict limits to upload endpoints', async () => {
      // Los endpoints de upload tienen límite de 3 por minuto
      for (let i = 0; i < 3; i++) {
        await request(app.getHttpServer())
          .post('/rate-limit-test/upload')
          .expect(200);
      }

      // El 4to request debería fallar
      await request(app.getHttpServer())
        .post('/rate-limit-test/upload')
        .expect(429);
    });
  });

  describe('Rate limit headers', () => {
    it('should include rate limit information in response headers', async () => {
      const response = await request(app.getHttpServer())
        .get('/rate-limit-test/normal')
        .expect(200);

      // Verificar que incluye headers informativos
      expect(response.headers).toHaveProperty('x-ratelimit-policy');
      expect(response.headers).toHaveProperty('x-ratelimit-applied');
    });
  });

  describe('Error messages', () => {
    it('should return user-friendly error messages in Spanish', async () => {
      // Exceder el límite
      for (let i = 0; i < 5; i++) {
        await request(app.getHttpServer())
          .get('/rate-limit-test/normal')
          .expect(200);
      }

      const response = await request(app.getHttpServer())
        .get('/rate-limit-test/normal')
        .expect(429);

      expect(response.body.message).toContain('Demasiadas solicitudes');
    });
  });
}); 