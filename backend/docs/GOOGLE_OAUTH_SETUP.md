# 🔑 Configuración de Google OAuth - Backend FCT

## 📋 Resumen

Este documento describe el proceso completo de configuración de Google OAuth para el backend del proyecto FCT.

## 🎯 Objetivo

Configurar autenticación con Google OAuth para permitir que los usuarios inicien sesión usando sus cuentas de Google.

## 🚀 Pasos de Configuración

### 1. Configuración de Google Cloud Console

#### 1.1 Acceder a Google Cloud Console

- Ve a [Google Cloud Console](https://console.cloud.google.com/)
- Inicia sesión con tu cuenta de Gmail
- Crea un nuevo proyecto o selecciona uno existente

#### 1.2 Habilitar APIs

- Ve a **"APIs y servicios"** → **"Biblioteca"**
- Busca y habilita **"Google+ API"** o **"Google Identity"**
- Esta API es necesaria para OAuth

#### 1.3 Configurar Pantalla de Consentimiento

- Ve a **"APIs y servicios"** → **"Pantalla de consentimiento OAuth"**
- Selecciona **"Usuarios externos"** (para desarrollo)
- Completa la información básica:
  - **Nombre de la aplicación**: "FCT Backend"
  - **Correo electrónico de soporte**: tu Gmail
  - **Dominio de la aplicación**: tu dominio (opcional)

#### 1.4 Crear Credenciales OAuth

- Ve a **"APIs y servicios"** → **"Credenciales"**
- Haz clic en **"Crear credenciales"** → **"ID de cliente de OAuth 2.0"**
- Selecciona **"Aplicación web"**
- Configura:
  - **Nombre**: "FCT Backend Web Client"
  - **Orígenes autorizados de JavaScript**:
    - `http://localhost:3000` (desarrollo)
    - `https://tu-dominio.com` (producción)
  - **URI de redirección autorizados**:
    - `http://localhost:3000/auth/google/callback` (desarrollo)
    - `https://tu-dominio.com/auth/google/callback` (producción)

### 2. Obtener Credenciales

Después de crear el cliente OAuth, obtendrás:

- **ID de cliente**: `123456789-abcdefghijklmnop.apps.googleusercontent.com`
- **Secreto del cliente**: `GOCSPX-abcdefghijklmnopqrstuvwxyz`

### 3. Configurar Variables de Entorno

Edita tu archivo `.env` y configura:

```bash
# Google OAuth
GOOGLE_CLIENT_ID=tu_google_client_id_aqui.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=tu_google_client_secret_aqui
```

## 🔧 Configuración por Entorno

### Desarrollo Local

```bash
# Orígenes autorizados
http://localhost:3000

# URIs de redirección
http://localhost:3000/auth/google/callback
```

### Producción

```bash
# Orígenes autorizados
https://tu-dominio.com

# URIs de redirección
https://tu-dominio.com/auth/google/callback
```

## 🧪 Testing

### 1. Verificar Configuración

```bash
cd backend
node scripts/verify-env.js
```

### 2. Probar Autenticación

1. Inicia el backend: `npm run start:dev`
2. Ve a: `http://localhost:3000/auth/google`
3. Deberías ser redirigido a Google para autenticación

## 🚨 Troubleshooting

### Error: "redirect_uri_mismatch"

- **Causa**: Las URIs de redirección no coinciden
- **Solución**: Verificar que las URIs en Google Cloud Console coincidan exactamente con las de tu aplicación

### Error: "invalid_client"

- **Causa**: ID de cliente incorrecto o API no habilitada
- **Solución**: Verificar el `GOOGLE_CLIENT_ID` y asegurar que la API esté habilitada

### Error: "access_denied"

- **Causa**: Pantalla de consentimiento mal configurada
- **Solución**: Verificar la configuración de la pantalla de consentimiento OAuth

## 🔒 Seguridad

### Buenas Prácticas

- ✅ **Nunca** compartas el `GOOGLE_CLIENT_SECRET`
- ✅ **Nunca** lo subas a Git
- ✅ Mantén las credenciales en el archivo `.env`
- ✅ Usa diferentes credenciales para desarrollo y producción

### Variables Sensibles

```bash
# ❌ NUNCA hacer esto
GOOGLE_CLIENT_SECRET=GOCSPX-abcdefghijklmnopqrstuvwxyz  # En código

# ✅ Hacer esto
GOOGLE_CLIENT_SECRET=GOCSPX-abcdefghijklmnopqrstuvwxyz  # En .env (no en Git)
```

## 📚 Referencias

- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Google Cloud Console](https://console.cloud.google.com/)
- [NestJS Passport Documentation](https://docs.nestjs.com/security/authentication)

## 🔄 Actualizaciones

### Versión 1.0 (2025-07-24)

- ✅ Configuración inicial de Google OAuth
- ✅ Integración con NestJS Passport
- ✅ Documentación completa del proceso

---

**Última actualización**: 2025-07-24
**Estado**: ✅ Completado
