import { applyDecorators, SetMetadata } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';

// Clave para almacenar metadata de throttling personalizado
export const THROTTLE_TYPE_KEY = 'throttle_type';

// Tipos de throttling personalizados
export enum ThrottleType {
  AUTH = 'auth',
  API = 'api', 
  UPLOAD = 'upload',
  SENSITIVE = 'sensitive',
}

/**
 * Aplicar rate limiting específico para autenticación
 * Límites muy restrictivos para prevenir ataques de fuerza bruta
 */
export const AuthThrottle = () => applyDecorators(
  Throttle({
    default: { ttl: 60000, limit: 5 }, // 5 por minuto
  }),
  SetMetadata(THROTTLE_TYPE_KEY, ThrottleType.AUTH),
);

/**
 * Aplicar rate limiting para endpoints de API general
 * Límites moderados para uso normal de la API
 */
export const ApiThrottle = () => applyDecorators(
  Throttle({
    default: { ttl: 60000, limit: 60 }, // 60 por minuto
  }),
  SetMetadata(THROTTLE_TYPE_KEY, ThrottleType.API),
);

/**
 * Aplicar rate limiting para subida de archivos
 * Límites muy restrictivos para operaciones costosas
 */
export const UploadThrottle = () => applyDecorators(
  Throttle({
    default: { ttl: 60000, limit: 3 }, // 3 por minuto
  }),
  SetMetadata(THROTTLE_TYPE_KEY, ThrottleType.UPLOAD),
);

/**
 * Aplicar rate limiting para operaciones sensibles
 * Límites restrictivos para operaciones críticas
 */
export const SensitiveThrottle = () => applyDecorators(
  Throttle({
    default: { ttl: 60000, limit: 10 }, // 10 por minuto
  }),
  SetMetadata(THROTTLE_TYPE_KEY, ThrottleType.SENSITIVE),
);

/**
 * Desactivar throttling para endpoints específicos
 */
export const NoThrottle = () => applyDecorators(
  Throttle({ default: { ttl: 0, limit: 0 } }),
);

/**
 * Aplicar throttling personalizado con límites específicos
 */
export const CustomThrottle = (options: { ttl: number; limit: number }) => 
  applyDecorators(
    Throttle({
      default: {
        ttl: options.ttl,
        limit: options.limit,
      },
    }),
  ); 