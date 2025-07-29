# Configuración de Variables de Entorno - Backend FCT

## 📋 Descripción General

Este documento describe la configuración completa de variables de entorno necesarias para el despliegue del backend del proyecto FCT en un entorno de microservicios.

## 🏗️ Arquitectura de Microservicios

El backend está diseñado para funcionar dentro de una arquitectura de microservicios con:
- **Proxy reverso central** (Nginx)
- **Red compartida** (`proxy-net`)
- **Base de datos PostgreSQL** independiente
- **Contenedores Docker** para cada servicio

## 📁 Estructura de Archivos

```
backend/
├── .env.example          # Plantilla de variables de entorno
├── .env                  # Variables reales (NO versionado)
├── docker-compose.yml    # Configuración Docker
└── docs/
    └── ENVIRONMENT_SETUP.md  # Este archivo
```

## 🔧 Variables de Entorno Requeridas

### 1. Configuración de Base de Datos

```bash
# Host de la base de datos (interno en Docker)
DB_HOST=postgres

# Puerto de PostgreSQL
DB_PORT=5432

# Usuario de la base de datos
DB_USERNAME=postgres

# Contraseña de la base de datos (CAMBIAR OBLIGATORIAMENTE)
DB_PASSWORD=tu_contraseña_segura_aqui

# Nombre de la base de datos
DB_DATABASE=fct_backend_db
```

**⚠️ Cambios Obligatorios:**
- `DB_PASSWORD`: Usar contraseña fuerte y única
- `DB_DATABASE`: Usar nombre descriptivo del proyecto

### 2. Configuración de Autenticación JWT

```bash
# Clave secreta para JWT (CAMBIAR OBLIGATORIAMENTE)
JWT_SECRET=tu_clave_secreta_muy_larga_y_compleja_aqui

# Tiempo de expiración del token
JWT_EXPIRATION=1h
```

**⚠️ Cambios Obligatorios:**
- `JWT_SECRET`: Generar clave secreta de al menos 32 caracteres
- `JWT_EXPIRATION`: Ajustar según políticas de seguridad

### 3. Configuración de Google OAuth

```bash
# Client ID de Google OAuth
GOOGLE_CLIENT_ID=tu_google_client_id_real

# Client Secret de Google OAuth
GOOGLE_CLIENT_SECRET=tu_google_client_secret_real
```

**⚠️ Cambios Obligatorios:**
- Configurar proyecto en Google Cloud Console
- Obtener credenciales OAuth 2.0
- Configurar URIs de redirección autorizados

### 4. Configuración de Email

```bash
# Servidor SMTP
MAIL_HOST=smtp.gmail.com

# Puerto SMTP
MAIL_PORT=587

# Email del remitente
MAIL_USER=tu_email@gmail.com

# Contraseña de aplicación de Gmail
MAIL_PASS=tu_app_password_de_gmail
```

**⚠️ Cambios Obligatorios:**
- `MAIL_USER`: Email real para envío de notificaciones
- `MAIL_PASS`: App Password específica de Gmail (NO contraseña normal)

### 5. Configuración de Frontend

```bash
# URL del frontend para redirecciones
FRONTEND_URL=https://tu-dominio.com
```

**⚠️ Cambios Obligatorios:**
- Cambiar a dominio real en producción
- Usar HTTPS en producción

### 6. Configuración de Entorno

```bash
# Entorno de ejecución
NODE_ENV=production

# Puerto del servidor
PORT=3000
```

**✅ Variables que se pueden mantener por defecto**

## 🚀 Pasos de Configuración

### Paso 1: Crear archivo .env

```bash
cd proyecto-fct-NetJs/backend
cp .env.example .env
```

### Paso 2: Editar variables de entorno

```bash
# Editar el archivo .env con tus valores
nano .env
```

### Paso 3: Configurar Google OAuth

1. Ir a [Google Cloud Console](https://console.cloud.google.com/)
2. Crear nuevo proyecto o seleccionar existente
3. Habilitar Google+ API
4. Crear credenciales OAuth 2.0
5. Configurar URIs de redirección:
   - `http://localhost:3000/auth/google/callback` (desarrollo)
   - `https://tu-dominio.com/auth/google/callback` (producción)

### Paso 4: Configurar Gmail App Password

1. Ir a [Configuración de Google Account](https://myaccount.google.com/)
2. Seguridad → Verificación en dos pasos (habilitar)
3. Contraseñas de aplicación → Generar nueva
4. Seleccionar "Correo" y "Otro (nombre personalizado)"
5. Usar la contraseña generada en `MAIL_PASS`

## 🔒 Generación de Valores Seguros

### JWT Secret (32+ caracteres)
```bash
# Generar con OpenSSL
openssl rand -base64 32

# O usar Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### Contraseña de Base de Datos
```bash
# Generar contraseña segura
openssl rand -base64 16
```

## 📋 Ejemplo de Archivo .env Completo

```bash
# ========================================
# CONFIGURACIÓN DE BASE DE DATOS
# ========================================
DB_HOST=postgres
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=fct_secure_password_2024
DB_DATABASE=fct_backend_db

# ========================================
# CONFIGURACIÓN DE AUTENTICACIÓN
# ========================================
JWT_SECRET=fct_jwt_secret_key_2024_very_long_and_secure_32_chars_minimum
JWT_EXPIRATION=1h

# ========================================
# CONFIGURACIÓN DE GOOGLE OAUTH
# ========================================
GOOGLE_CLIENT_ID=123456789-abcdefghijklmnop.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-your_google_client_secret_here

# ========================================
# CONFIGURACIÓN DE EMAIL
# ========================================
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=tu-email@gmail.com
MAIL_PASS=abcd efgh ijkl mnop

# ========================================
# CONFIGURACIÓN DE FRONTEND
# ========================================
FRONTEND_URL=https://fct-backend.tu-dominio.com

# ========================================
# CONFIGURACIÓN DE ENTORNO
# ========================================
NODE_ENV=production
PORT=3000
```

## 🐳 Configuración para Docker

### Variables en docker-compose.yml

El archivo `docker-compose.yml` ya está configurado para usar las variables de entorno:

```yaml
environment:
  DB_HOST: postgres
  DB_PORT: ${DB_PORT:-5432}
  DB_USERNAME: ${DB_USERNAME:-postgres}
  DB_PASSWORD: ${DB_PASSWORD:-postgres}
  DB_DATABASE: ${DB_DATABASE:-nestjs}
  JWT_SECRET: ${JWT_SECRET}
  JWT_EXPIRATION: ${JWT_EXPIRATION:-1h}
  NODE_ENV: ${NODE_ENV:-production}
  PORT: 3000
env_file:
  - .env
```

### Red de Microservicios

```yaml
networks:
  - proxy-net  # Red compartida con otros servicios
```

## 🔍 Verificación de Configuración

### Comando de verificación
```bash
# Verificar que todas las variables están definidas
cd backend
node -e "
const fs = require('fs');
const dotenv = require('dotenv');
dotenv.config();

const requiredVars = [
  'DB_HOST', 'DB_PORT', 'DB_USERNAME', 'DB_PASSWORD', 'DB_DATABASE',
  'JWT_SECRET', 'JWT_EXPIRATION',
  'GOOGLE_CLIENT_ID', 'GOOGLE_CLIENT_SECRET',
  'MAIL_HOST', 'MAIL_PORT', 'MAIL_USER', 'MAIL_PASS',
  'FRONTEND_URL', 'NODE_ENV', 'PORT'
];

const missing = requiredVars.filter(var => !process.env[var]);
if (missing.length > 0) {
  console.error('❌ Variables faltantes:', missing);
  process.exit(1);
} else {
  console.log('✅ Todas las variables están configuradas');
}
"
```

## ⚠️ Consideraciones de Seguridad

### 1. Protección de Archivos
- **NUNCA** commitees el archivo `.env` real
- **SÍ** commitea `.env.example` como plantilla
- Agregar `.env` al `.gitignore`

### 2. Contraseñas Seguras
- Usar contraseñas de al menos 16 caracteres
- Incluir mayúsculas, minúsculas, números y símbolos
- No reutilizar contraseñas entre servicios

### 3. JWT Secret
- Mínimo 32 caracteres
- Usar caracteres aleatorios
- Cambiar en cada entorno (desarrollo, staging, producción)

### 4. Credenciales de Google
- Configurar URIs de redirección correctos
- Usar credenciales específicas por entorno
- Rotar credenciales periódicamente

## 🚨 Troubleshooting

### Error: "Missing environment variables"
- Verificar que el archivo `.env` existe
- Comprobar que todas las variables están definidas
- Ejecutar comando de verificación

### Error: "Database connection failed"
- Verificar credenciales de PostgreSQL
- Comprobar que el contenedor de BD está ejecutándose
- Verificar conectividad de red

### Error: "Google OAuth failed"
- Verificar `GOOGLE_CLIENT_ID` y `GOOGLE_CLIENT_SECRET`
- Comprobar URIs de redirección en Google Console
- Verificar que la API está habilitada

### Error: "Email sending failed"
- Verificar credenciales de Gmail
- Comprobar que se usa App Password (no contraseña normal)
- Verificar configuración SMTP

## 📚 Referencias

- [NestJS Configuration](https://docs.nestjs.com/techniques/configuration)
- [Google OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
- [Gmail App Passwords](https://support.google.com/accounts/answer/185833)
- [PostgreSQL Docker](https://hub.docker.com/_/postgres)
- [JWT Best Practices](https://auth0.com/blog/a-look-at-the-latest-draft-for-jwt-bcp/)

## 📞 Soporte

Para problemas específicos de configuración:
1. Revisar logs del contenedor: `docker logs fct-backend-api`
2. Verificar conectividad: `docker exec fct-backend-api ping postgres`
3. Comprobar variables: `docker exec fct-backend-api env | grep DB_`

---

**Última actualización:** $(date)
**Versión del documento:** 1.0
**Compatible con:** Backend FCT v1.0 