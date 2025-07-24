# 📋 Changelog - Backend FCT

## [Unreleased] - 2025-07-24

### 🚀 Agregado

- **Configuración de Google OAuth**: Integración completa con Google Cloud Console
- **Archivo .env.example**: Plantilla completa de variables de entorno
- **Script de verificación**: `scripts/verify-env.js` para validar configuración
- **Documentación de configuración**: Guías paso a paso para setup

### 🔧 Cambiado

- **Requisitos de Node.js**: Actualizado de Node.js 18 a Node.js 20.19.4
- **NestJS**: Actualizado a versión 11.x (requiere Node.js >= 20.11)
- **Dependencias**: Todas las dependencias actualizadas a versiones compatibles

### 🐛 Corregido

- **Compatibilidad de versiones**: Resueltos warnings de versiones incompatibles
- **Script de verificación**: Mejorada la validación de variables de entorno

### 📚 Documentación

- **README_ENV.md**: Guía rápida de configuración
- **CHANGELOG.md**: Este archivo para tracking de cambios
- **Instrucciones de Google OAuth**: Documentación completa del proceso

## Requisitos del Sistema

### Node.js

- **Versión mínima**: 20.11.0
- **Versión recomendada**: 20.19.4
- **Instalación**:
  ```bash
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install nodejs -y
  ```

### npm

- **Versión mínima**: 10.8.2
- **Versión recomendada**: 11.4.2 (actualizar con `npm install -g npm@11.4.2`)

### Base de Datos

- **PostgreSQL**: 13+ (recomendado)
- **Configuración**: Ver archivo `.env.example`

## Configuración de Google OAuth

### Pasos realizados:

1. ✅ Configuración de Google Cloud Console
2. ✅ Habilitación de Google+ API
3. ✅ Configuración de pantalla de consentimiento OAuth
4. ✅ Creación de credenciales OAuth 2.0
5. ✅ Configuración de variables de entorno

### Variables configuradas:

- `GOOGLE_CLIENT_ID`: ID del cliente OAuth de Google
- `GOOGLE_CLIENT_SECRET`: Secreto del cliente OAuth de Google
- `JWT_SECRET`: Clave secreta para JWT (generada automáticamente)
- `DB_PASSWORD`: Contraseña de base de datos (generada automáticamente)

## Próximos Pasos

### Pendiente:

- [ ] Instalación de PostgreSQL
- [ ] Creación de base de datos
- [ ] Configuración de Flutter para OAuth
- [ ] Testing de autenticación Google OAuth
- [ ] Configuración de producción

### Notas Importantes:

- **Seguridad**: Nunca commitear archivo `.env` con credenciales reales
- **Desarrollo**: Usar `DB_HOST=localhost` para desarrollo local
- **Docker**: Usar `DB_HOST=postgres` para contenedores Docker
- **Google OAuth**: Configurar URIs de redirección según el entorno

---

**Fecha de última actualización**: 2025-07-24
**Responsable**: Configuración inicial del proyecto
