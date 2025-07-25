# 🚀 Configuración Rápida - Variables de Entorno

## ⚡ Configuración Automática (Recomendado)

### 1. Ejecutar Script de Configuración
```bash
cd backend
./scripts/setup-env.sh
```

Este script te guiará paso a paso para configurar todas las variables necesarias.

### 2. Verificar Configuración
```bash
node scripts/verify-env.js
```

## 📋 Variables que se Configuran Automáticamente

✅ **Generadas automáticamente:**
- `DB_PASSWORD` - Contraseña segura para PostgreSQL
- `DB_DATABASE` - Nombre de la base de datos
- `JWT_SECRET` - Clave secreta de 32+ caracteres

⚠️ **Requieren configuración manual:**
- `GOOGLE_CLIENT_ID` - Credenciales de Google OAuth
- `GOOGLE_CLIENT_SECRET` - Credenciales de Google OAuth
- `MAIL_PASS` - App Password de Gmail

## 🔧 Configuración Manual (Alternativa)

### 1. Crear archivo .env
```bash
cp .env.example .env
```

### 2. Editar variables críticas
```bash
nano .env
```

**Variables obligatorias a cambiar:**
```bash
# Base de datos
DB_PASSWORD=tu_contraseña_segura_aqui
DB_DATABASE=fct_backend_db

# JWT
JWT_SECRET=tu_clave_secreta_muy_larga_y_compleja_aqui

# Google OAuth
GOOGLE_CLIENT_ID=tu_google_client_id_real
GOOGLE_CLIENT_SECRET=tu_google_client_secret_real

# Email
MAIL_USER=tu_email@gmail.com
MAIL_PASS=tu_app_password_de_gmail

# Frontend
FRONTEND_URL=https://tu-dominio.com
```

## 🔐 Generación de Valores Seguros

### JWT Secret
```bash
# Opción 1: OpenSSL
openssl rand -base64 32

# Opción 2: Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### Contraseña de Base de Datos
```bash
openssl rand -base64 16 | tr -d "=+/" | cut -c1-16
```

## 📚 Documentación Completa

Para información detallada sobre todas las variables y configuración avanzada:
- [Documentación Completa](docs/ENVIRONMENT_SETUP.md)

## 🚨 Troubleshooting

### Error: "Archivo .env no encontrado"
```bash
cp .env.example .env
```

### Error: "Variables faltantes"
```bash
node scripts/verify-env.js
```

### Error: "Permisos denegados"
```bash
chmod +x scripts/setup-env.sh
chmod +x scripts/verify-env.js
```

## 🐳 Despliegue

Una vez configuradas las variables:
```bash
docker-compose up --build
```

---

**¿Necesitas ayuda?** Revisa la [documentación completa](docs/ENVIRONMENT_SETUP.md) o ejecuta `./scripts/setup-env.sh` para configuración guiada. 