import { ThrottlerModuleOptions } from '@nestjs/throttler';
import { ConfigService } from '@nestjs/config';

export interface ThrottleConfig {
  default: ThrottlerModuleOptions;
  auth: ThrottlerModuleOptions;
  api: ThrottlerModuleOptions;
  upload: ThrottlerModuleOptions;
}

export const createThrottleConfig = (configService: ConfigService): ThrottleConfig => {
  const isProduction = configService.get('NODE_ENV') === 'production';
  
  return {
    // Configuración global por defecto
    default: [
      {
        name: 'short',
        ttl: 60000, // 1 minuto
        limit: isProduction ? 100 : 1000, // Más restrictivo en producción
      },
      {
        name: 'medium',
        ttl: 300000, // 5 minutos
        limit: isProduction ? 500 : 5000,
      },
      {
        name: 'long',
        ttl: 3600000, // 1 hora
        limit: isProduction ? 2000 : 20000,
      },
    ],
    
    // Límites específicos para autenticación
    auth: [
      {
        name: 'auth-short',
        ttl: 60000, // 1 minuto
        limit: 5, // Muy restrictivo para prevenir ataques de fuerza bruta
      },
      {
        name: 'auth-medium',
        ttl: 900000, // 15 minutos
        limit: 20,
      },
      {
        name: 'auth-long',
        ttl: 3600000, // 1 hora
        limit: 50,
      },
    ],
    
    // Límites para API general
    api: [
      {
        name: 'api-short',
        ttl: 60000, // 1 minuto
        limit: isProduction ? 60 : 600,
      },
      {
        name: 'api-medium',
        ttl: 600000, // 10 minutos
        limit: isProduction ? 300 : 3000,
      },
    ],
    
    // Límites para subida de archivos
    upload: [
      {
        name: 'upload-short',
        ttl: 60000, // 1 minuto
        limit: 3, // Muy restrictivo para uploads
      },
      {
        name: 'upload-medium',
        ttl: 3600000, // 1 hora
        limit: 20,
      },
    ],
  };
}; 