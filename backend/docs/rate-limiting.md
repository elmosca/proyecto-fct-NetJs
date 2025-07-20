# 🚦 Rate Limiting - Documentación Técnica

## Descripción General

El sistema de rate limiting implementado en la API protege contra abusos, ataques DoS y garantiza un uso justo de los recursos del servidor. Utiliza `@nestjs/throttler` con configuraciones personalizadas según el tipo de endpoint.

## Configuración

### Límites Globales por Defecto

- **Producción**: 100 requests/minuto, 500 requests/5min, 2000 requests/hora
- **Desarrollo**: 1000 requests/minuto, 5000 requests/5min, 20000 requests/hora

### Límites Específicos por Tipo de Endpoint

#### 🔐 Autenticación (`@AuthThrottle()`)
- **5 requests/minuto** - Prevenir ataques de fuerza bruta
- **20 requests/15min** - Límite extendido para intentos legítimos
- **Aplicado en**: `/auth/login`, `/auth/register`

#### 📤 Subida de Archivos (`@UploadThrottle()`)
- **3 requests/minuto** - Operaciones costosas de E/O
- **20 requests/hora** - Límite diario para uploads
- **Aplicado en**: `/anteprojects/:id/files`

#### ⚠️ Operaciones Sensibles (`@SensitiveThrottle()`)
- **10 requests/minuto** - Operaciones críticas del sistema
- **100 requests/hora** - Límite para cambios de estado importantes
- **Aplicado en**: Aprobación/rechazo de anteproyectos, cambios de estado críticos

#### 🌐 API General (`@ApiThrottle()`)
- **60 requests/minuto** - Uso normal de la API
- **300 requests/10min** - Límite para operaciones sostenidas

## Decoradores Disponibles

### Usar Rate Limiting Específico

```typescript
import { AuthThrottle, UploadThrottle, SensitiveThrottle, ApiThrottle } from '../common/decorators/throttle.decorator';

// Autenticación (muy restrictivo)
@Post('login')
@AuthThrottle()
async login() { ... }

// Upload de archivos (restrictivo)
@Post('upload')
@UploadThrottle()
async uploadFile() { ... }

// Operaciones sensibles (moderadamente restrictivo)
@Post('approve')
@SensitiveThrottle()
async approve() { ... }

// API general (límites normales)
@Get('data')
@ApiThrottle()
async getData() { ... }
```

### Desactivar Rate Limiting

```typescript
import { NoThrottle } from '../common/decorators/throttle.decorator';

@Get('health')
@NoThrottle()
async healthCheck() { ... }
```

### Rate Limiting Personalizado

```typescript
import { CustomThrottle } from '../common/decorators/throttle.decorator';

@Post('special')
@CustomThrottle({ ttl: 300000, limit: 10 }) // 10 requests per 5 minutes
async specialEndpoint() { ... }
```

## Headers de Respuesta

El sistema añade headers informativos a todas las respuestas:

```http
X-RateLimit-Policy: active
X-RateLimit-Service: nestjs-throttler
X-RateLimit-Applied: true
```

Cuando se excede el límite:

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 60
```

## Gestión de Errores

### Respuesta de Rate Limit Excedido

```json
{
  "statusCode": 429,
  "message": "Demasiadas solicitudes. Por favor, intenta de nuevo más tarde.",
  "error": "Too Many Requests",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "path": "/auth/login"
}
```

### Logging Automático

El sistema registra automáticamente:

- **Advertencias** al alcanzar el 80% del límite
- **Errores** cuando se excede el límite
- **Información de usuario** (IP, User Agent, User ID si está autenticado)

```typescript
// Ejemplo de log
{
  "level": "WARN",
  "message": "Rate limit exceeded: POST /auth/login",
  "context": "ThrottlerGuard",
  "metadata": {
    "ip": "192.168.1.100",
    "userAgent": "Mozilla/5.0...",
    "userId": 123,
    "error": "ThrottlerException: Too Many Requests"
  }
}
```

## Configuración de Entorno

### Variables de Entorno Opcionales

```env
# Rate limiting
NODE_ENV=production # Afecta los límites aplicados
ENABLE_RATE_LIMIT_CLEANUP=true # Limpieza automática de memoria
```

## Identificación de Usuarios

El sistema identifica las requests por:

1. **Usuario autenticado**: Por ID de usuario (más preciso)
2. **Usuario anónimo**: Por dirección IP

Esto permite límites más justos y previene evasión mediante múltiples IPs para usuarios autenticados.

## Almacenamiento

- **Por defecto**: Memoria local del proceso
- **Limpieza**: Automática cada 5 minutos para liberar memoria
- **Escalabilidad**: Para múltiples instancias considerar Redis

## Testing

### Tests Unitarios

```typescript
// Verificar que los decoradores se aplican correctamente
describe('Rate Limiting Decorators', () => {
  it('should apply auth throttling', () => {
    // Test implementation
  });
});
```

### Tests E2E

```typescript
// Verificar límites en requests reales
describe('Rate Limiting (e2e)', () => {
  it('should block after exceeding limit', async () => {
    // Make requests up to limit
    // Verify next request fails with 429
  });
});
```

## Monitoreo y Métricas

### Logs a Monitorear

- Rate limit warnings (usuario cerca del límite)
- Rate limit exceeded (límite excedido)
- Cleanup operations (limpieza de memoria)

### Métricas Recomendadas

- Número de requests bloqueadas por endpoint
- Usuarios más activos por periodo
- Patrones de uso por hora/día
- Efectividad de los límites configurados

## Consideraciones de Seguridad

### Prevención de Ataques

- **Fuerza bruta**: Límites muy restrictivos en `/auth/login`
- **DoS**: Límites globales y por endpoint
- **Abuso de recursos**: Límites específicos para uploads

### Bypass Prevention

- Identificación por usuario autenticado (no solo IP)
- Headers informativos pero no sensibles
- Logs detallados para análisis forense

## Configuración para Diferentes Entornos

### Desarrollo
- Límites más altos para facilitar testing
- Logs más verbosos
- Limpieza automática habilitada

### Producción
- Límites restrictivos para seguridad
- Logs optimizados para rendimiento
- Considerar Redis para múltiples instancias

### Testing
- Límites muy bajos para probar comportamiento
- Limpieza manual disponible
- Mocks para tests unitarios

## Próximos Pasos y Mejoras

### Mejoras Futuras Consideradas

1. **Redis Backend**: Para aplicaciones distribuidas
2. **Límites Dinámicos**: Basados en carga del sistema
3. **Whitelisting**: IPs o usuarios exentos
4. **Métricas Avanzadas**: Dashboard de monitoreo
5. **Rate Limiting Inteligente**: ML para detectar patrones anómalos

### Configuración Recomendada para Producción

```typescript
// Configuración recomendada para alta carga
const throttleConfig = {
  ttl: 60000,
  limit: process.env.NODE_ENV === 'production' ? 50 : 500,
  skipIf: (context) => {
    // Skip for health checks
    const request = context.switchToHttp().getRequest();
    return request.url === '/health';
  }
};
```

## Troubleshooting

### Problemas Comunes

1. **"False positives"**: Usuarios legítimos bloqueados
   - **Solución**: Revisar límites, considerar identificación por usuario

2. **Memoria alta**: Muchas claves almacenadas
   - **Solución**: Verificar limpieza automática, considerar TTL más cortos

3. **Requests bypass**: Límites no aplicados
   - **Solución**: Verificar que el guard esté registrado globalmente

### Debugging

```typescript
// Habilitar logs detallados
const logger = new Logger('RateLimiting');
logger.debug(`Current limits for user ${userId}: ${JSON.stringify(limits)}`);
```

## Conclusión

El sistema de rate limiting implementado proporciona una protección robusta y flexible contra abuso de la API, manteniendo una experiencia de usuario fluida para el uso legítimo. La configuración por tipo de endpoint permite un control granular mientras que el logging automático facilita el monitoreo y análisis de patrones de uso.