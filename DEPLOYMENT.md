# 🚀 Guía Completa de Despliegue - Proyecto FCT

## 📋 Tabla de Contenidos

1. [Requisitos del Sistema](#requisitos-del-sistema)
2. [Instalación Rápida](#instalación-rápida)
3. [Instalación Manual](#instalación-manual)
4. [Configuración del Backend](#configuración-del-backend)
5. [Configuración del Frontend](#configuración-del-frontend)
6. [Despliegue en Producción](#despliegue-en-producción)
7. [Comandos Útiles](#comandos-útiles)
8. [Solución de Problemas](#solución-de-problemas)
9. [Monitoreo y Mantenimiento](#monitoreo-y-mantenimiento)

## 🖥️ Requisitos del Sistema

### Requisitos Mínimos
- **Sistema Operativo**: Linux, macOS, o Windows
- **RAM**: 4GB mínimo, 8GB recomendado
- **Almacenamiento**: 10GB de espacio libre
- **Procesador**: Dual-core mínimo

### Software Requerido

#### Para Backend
- **Node.js**: Versión 18+ (recomendado: 20.19.4)
- **npm**: Versión 8+ (incluido con Node.js)
- **Docker**: Versión 20+ con Docker Compose
- **PostgreSQL**: Versión 13+ (opcional, se incluye en Docker)

#### Para Frontend
- **Flutter**: Versión 3.16+
- **Android Studio** o **VS Code** con extensiones Flutter
- **Android SDK** (para desarrollo Android)
- **Xcode** (para desarrollo iOS, solo macOS)

## ⚡ Instalación Rápida

### Opción 1: Script Unificado (Recomendado)

```bash
# 1. Clonar el repositorio
git clone https://github.com/elmosca/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs

# 2. Dar permisos de ejecución
chmod +x install.sh

# 3. Ejecutar instalación completa
./install.sh

# 4. Verificar instalación
docker ps
curl http://localhost:3000/api/users
```

### Opción 2: Instalación por Componentes

```bash
# Solo backend
./install.sh --backend-only

# Solo frontend
./install.sh --frontend-only

# Saltar instalación de dependencias del sistema
./install.sh --skip-deps
```

## 🔧 Instalación Manual

### Paso 1: Instalar Dependencias del Sistema

#### Linux (Ubuntu/Debian)
```bash
# Actualizar sistema
sudo apt-get update

# Instalar herramientas básicas
sudo apt-get install -y curl git wget unzip

# Instalar Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
rm get-docker.sh

# Instalar Docker Compose
sudo apt-get install -y docker-compose

# Instalar Flutter
# Ver: https://flutter.dev/docs/get-started/install/linux
```

#### macOS
```bash
# Instalar Homebrew (si no está instalado)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar dependencias
brew install node@20 git curl wget

# Instalar Docker Desktop
# Descargar desde: https://www.docker.com/products/docker-desktop

# Instalar Flutter
# Ver: https://flutter.dev/docs/get-started/install/macos
```

#### Windows
```bash
# Instalar manualmente:
# - Node.js: https://nodejs.org/
# - Docker Desktop: https://www.docker.com/products/docker-desktop
# - Flutter: https://flutter.dev/docs/get-started/install/windows
# - Git: https://git-scm.com/download/win
```

### Paso 2: Verificar Instalación

```bash
# Verificar Node.js
node --version  # Debe ser v18.x.x o superior
npm --version   # Debe ser v8.x.x o superior

# Verificar Docker
docker --version
docker-compose --version

# Verificar Flutter
flutter --version
flutter doctor
```

## 🏗️ Configuración del Backend

### Paso 1: Configurar Variables de Entorno

```bash
cd backend

# Opción A: Usar script automático
./scripts/setup-env.sh

# Opción B: Configuración manual
cp .env.example .env
nano .env  # Editar variables
```

### Paso 2: Variables de Entorno Importantes

```bash
# Base de datos
DB_HOST=postgres
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=tu_contraseña_segura
DB_DATABASE=fct_backend_db

# JWT
JWT_SECRET=tu_clave_secreta_muy_larga_y_compleja_aqui_minimo_32_caracteres
JWT_EXPIRATION=1h

# Google OAuth (opcional)
GOOGLE_CLIENT_ID=tu_google_client_id
GOOGLE_CLIENT_SECRET=tu_google_client_secret

# Email (opcional)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=tu_email@gmail.com
MAIL_PASS=tu_app_password
```

### Paso 3: Verificar Configuración

```bash
# Verificar variables de entorno
node scripts/verify-env.js

# Debe mostrar: "✅ Todas las variables están correctamente configuradas"
```

### Paso 4: Iniciar Backend

```bash
# Instalar dependencias
npm install

# Iniciar base de datos
docker-compose up -d postgres

# Esperar a que la DB esté lista
until docker-compose exec -T postgres pg_isready -h localhost -p 5432 -U postgres; do
    printf '.'
    sleep 2
done

# Ejecutar migraciones
npm run migration:run

# Ejecutar seeds
npm run db:seed

# Iniciar API
docker-compose up -d api

# Verificar estado
docker ps
curl http://localhost:3000/api/users
```

## 📱 Configuración del Frontend

### Paso 1: Instalar Dependencias

```bash
cd frontend

# Instalar dependencias de Flutter
flutter pub get

# Generar código
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Paso 2: Configurar Flutter

```bash
# Verificar configuración
flutter doctor

# Configurar Android (si es necesario)
flutter config --android-sdk /path/to/android/sdk

# Configurar iOS (solo macOS)
flutter config --ios-sdk /path/to/ios/sdk
```

### Paso 3: Ejecutar Frontend

```bash
# Desarrollo
flutter run

# Construir APK
flutter build apk

# Construir para web
flutter build web
```

## 🚀 Despliegue en Producción

### Opción 1: Docker Compose (Recomendado)

```bash
# 1. Configurar variables de producción
export NODE_ENV=production
export DATABASE_URL="postgresql://user:pass@your-db-host:5432/fct_production"
export JWT_SECRET="your-ultra-secure-jwt-secret"
export CORS_ORIGIN="https://tu-app.com,https://www.tu-app.com"

# 2. Construir y desplegar
docker-compose -f docker-compose.prod.yml up --build -d

# 3. Verificar despliegue
docker ps
curl https://tu-dominio.com/api/health
```

### Opción 2: Despliegue Manual

#### Backend
```bash
cd backend

# Construir aplicación
npm run build

# Configurar PM2
npm install -g pm2
pm2 start dist/main.js --name "fct-backend"

# Configurar Nginx
sudo nano /etc/nginx/sites-available/fct-backend
sudo ln -s /etc/nginx/sites-available/fct-backend /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

#### Frontend
```bash
cd frontend

# Construir para web
flutter build web

# Desplegar en servidor web
sudo cp -r build/web/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
```

### Opción 3: Despliegue en la Nube

#### Heroku
```bash
# Backend
heroku create fct-backend
heroku config:set NODE_ENV=production
heroku config:set DATABASE_URL="postgresql://..."
git push heroku main

# Frontend
heroku create fct-frontend
heroku buildpacks:set https://github.com/heroku/heroku-buildpack-static
git push heroku main
```

#### AWS
```bash
# Usar AWS Elastic Beanstalk para backend
eb init fct-backend
eb create production
eb deploy

# Usar AWS S3 + CloudFront para frontend
aws s3 sync build/web s3://tu-bucket
aws cloudfront create-invalidation --distribution-id E123456789 --paths "/*"
```

## 🛠️ Comandos Útiles

### Gestión de Contenedores
```bash
# Ver estado de contenedores
docker ps

# Ver logs del backend
docker-compose logs -f api

# Ver logs de la base de datos
docker-compose logs -f postgres

# Reiniciar servicios
docker-compose restart api

# Parar todos los servicios
docker-compose down

# Parar y eliminar volúmenes
docker-compose down -v
```

### Gestión de Base de Datos
```bash
# Conectar a PostgreSQL
docker-compose exec postgres psql -U postgres -d fct_backend_db

# Ejecutar migraciones
cd backend && npm run migration:run

# Ejecutar seeds
cd backend && npm run db:seed

# Backup de base de datos
docker-compose exec postgres pg_dump -U postgres fct_backend_db > backup.sql

# Restaurar base de datos
docker-compose exec -T postgres psql -U postgres fct_backend_db < backup.sql
```

### Desarrollo
```bash
# Backend en modo desarrollo
cd backend && npm run start:dev

# Frontend en modo desarrollo
cd frontend && flutter run

# Ejecutar tests
cd backend && npm test
cd frontend && flutter test

# Generar código Flutter
cd frontend && flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Monitoreo
```bash
# Ver uso de recursos
docker stats

# Ver logs del sistema
journalctl -u docker

# Verificar salud de la API
curl http://localhost:3000/api/health

# Verificar conectividad de base de datos
docker-compose exec postgres pg_isready -h localhost -p 5432 -U postgres
```

## 🔧 Solución de Problemas

### Problemas Comunes

#### 1. Error de Conexión a Base de Datos
```bash
# Verificar que PostgreSQL esté ejecutándose
docker ps | grep postgres

# Verificar logs
docker-compose logs postgres

# Reiniciar base de datos
docker-compose restart postgres
```

#### 2. Error de Migraciones
```bash
# Limpiar base de datos
docker-compose down -v
docker-compose up -d postgres

# Esperar y ejecutar migraciones
sleep 10
npm run migration:run
```

#### 3. Error de Permisos en Docker
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Reiniciar sesión o ejecutar
newgrp docker
```

#### 4. Error de Flutter
```bash
# Limpiar cache
flutter clean
flutter pub get

# Verificar configuración
flutter doctor

# Actualizar Flutter
flutter upgrade
```

#### 5. Error de Node.js
```bash
# Limpiar cache de npm
npm cache clean --force

# Reinstalar dependencias
rm -rf node_modules package-lock.json
npm install
```

### Logs de Depuración

```bash
# Ver logs detallados del backend
docker-compose logs -f api | grep -i error

# Ver logs de la base de datos
docker-compose logs -f postgres | grep -i error

# Ver logs del sistema
journalctl -f

# Ver logs de nginx (si está configurado)
sudo tail -f /var/log/nginx/error.log
```

## 📊 Monitoreo y Mantenimiento

### Monitoreo de Recursos
```bash
# Script de monitoreo básico
#!/bin/bash
echo "=== Estado del Sistema ==="
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')"
echo "RAM: $(free -h | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
echo "Disco: $(df -h | awk '$NF=="/"{printf "%s", $5}')"

echo "=== Estado de Contenedores ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "=== Estado de la API ==="
curl -s http://localhost:3000/api/health || echo "API no responde"
```

### Backup Automático
```bash
#!/bin/bash
# Script de backup diario
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"

# Backup de base de datos
docker-compose exec -T postgres pg_dump -U postgres fct_backend_db > $BACKUP_DIR/db_backup_$DATE.sql

# Backup de archivos
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz backend/storage/uploads/

# Limpiar backups antiguos (mantener últimos 7 días)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

### Actualizaciones
```bash
# Actualizar código
git pull origin main

# Reconstruir contenedores
docker-compose down
docker-compose up --build -d

# Ejecutar migraciones
cd backend && npm run migration:run

# Verificar funcionamiento
curl http://localhost:3000/api/health
```

## 📞 Soporte

### Recursos Adicionales
- **Documentación del Proyecto**: [README.md](README.md)
- **Guía de Contribución**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Issues de GitHub**: [GitHub Issues](https://github.com/elmosca/proyecto-fct-NetJs/issues)

### Contacto
- **Email**: jualas@gmail.com
- **GitHub**: [@elmosca](https://github.com/elmosca)

---

**Nota**: Esta guía se actualiza regularmente. Para la versión más reciente, consulta el repositorio oficial del proyecto. 