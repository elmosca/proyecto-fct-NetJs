# Security Policy

## Versiones Soportadas

Actualmente damos soporte de seguridad a las siguientes versiones:

| Versión | Soportada          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reportar una Vulnerabilidad

Si descubres una vulnerabilidad de seguridad, por favor NO abras un issue público. En su lugar:

1. **Envía un email** a [tu-email@domain.com] con:
   - Descripción detallada de la vulnerabilidad
   - Pasos para reproducir el problema
   - Posible impacto de la vulnerabilidad
   - Cualquier sugerencia para solucionarlo

2. **Información a incluir**:
   - Versión afectada del software
   - Descripción de la vulnerabilidad
   - Archivo(s) y línea(s) de código afectadas
   - Cualquier condición especial requerida para explotar la vulnerabilidad

3. **Proceso de respuesta**:
   - Confirmaremos la recepción de tu reporte en 48 horas
   - Investigaremos y confirmaremos la vulnerabilidad en 5 días hábiles
   - Trabajaremos en un fix y te mantendremos informado del progreso
   - Coordinaremos la divulgación responsable del problema

## Buenas Prácticas de Seguridad

### Para Desarrolladores
- Nunca commites credenciales, tokens o claves API
- Usa variables de entorno para información sensible
- Mantén las dependencias actualizadas
- Ejecuta regularmente `npm audit` en el backend
- Usa HTTPS en producción

### Para Usuarios
- Mantén la aplicación actualizada
- Usa contraseñas fuertes y únicas
- No compartas credenciales de acceso
- Reporta comportamientos sospechosos

## Configuraciones de Seguridad

### Backend (NestJS)
- Validación de entrada con class-validator
- Rate limiting implementado
- Helmet.js para headers de seguridad
- JWT con expiración apropiada
- Sanitización de datos

### Frontend (Flutter)
- Almacenamiento seguro para tokens
- Validación de certificados SSL
- Ofuscación de código en release builds
- No logging de información sensible

Gracias por ayudar a mantener nuestro proyecto seguro.
