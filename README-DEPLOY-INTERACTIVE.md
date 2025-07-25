# 🚀 Script de Despliegue Interactivo - Proyecto FCT

## 📋 Descripción

El script `deploy-interactive.sh` es una herramienta interactiva que te guía paso a paso para configurar el despliegue del proyecto FCT según tus necesidades específicas. Genera automáticamente todos los archivos de configuración necesarios.

## 🎯 Características

- ✅ **Interfaz interactiva** con colores y mensajes claros
- ✅ **5 tipos de instalación** diferentes
- ✅ **Generación automática** de archivos de configuración
- ✅ **Contraseñas seguras** generadas automáticamente
- ✅ **Scripts de gestión** creados automáticamente
- ✅ **Verificación de prerrequisitos** antes del despliegue
- ✅ **Configuración de Nginx** incluida cuando es necesario

## 🚀 Uso Rápido

```bash
# Ejecutar el script interactivo
./deploy-interactive.sh
```

## 📋 Tipos de Instalación

### 1. 🏠 Desarrollo Local

- **Propósito**: Desarrollo y pruebas locales
- **Características**:
  - Sin SSL, puerto 3000
  - Base de datos: `fct_local`
  - Rate limiting: 1000 requests/min
  - NODE_ENV: development

### 2. 🎓 Centro Educativo

- **Propósito**: Uso interno en centros educativos
- **Características**:
  - Acceso desde red local
  - Base de datos: `fct_centro`
  - Rate limiting: 100 requests/min
  - Nginx con configuración específica
  - NODE_ENV: production

### 3. 🌐 Local con Cloudflare Tunnel

- **Propósito**: Demos y presentaciones
- **Características**:
  - Acceso externo seguro sin configuración de puertos
  - Base de datos: `fct_local`
  - SSL automático con Cloudflare
  - Puerto local: 8080
  - NODE_ENV: production

### 4. 🏢 VPS Profesional

- **Propósito**: Producción en VPS propio
- **Características**:
  - SSL automático con Let's Encrypt
  - Base de datos: `fct_production`
  - Redis para caché
  - Monitoreo y backup automático
  - Rate limiting: 100 requests/min
  - NODE_ENV: production

### 5. 🎯 Despliegue Genérico

- **Propósito**: Configuración flexible para múltiples entornos
- **Características**:
  - Soporte para local, staging, producción
  - Variables de entorno específicas por entorno
  - Configuración personalizable

## 🔧 Archivos Generados

### Archivos de Configuración

```
📁 Archivos generados automáticamente:
├── docker-compose.yml              # Desarrollo local
├── docker-compose.centro.yml       # Centro educativo
├── docker-compose.cloudflare.yml   # Cloudflare Tunnel
├── docker-compose.vps.yml          # VPS profesional
├── .env                            # Variables de entorno
├── nginx/nginx-centro.conf         # Configuración Nginx centro
└── nginx/nginx-simple.conf         # Configuración Nginx simple
```

### Scripts de Gestión

```
📁 Scripts creados automáticamente:
├── start-[tipo].sh                 # Iniciar servicios
├── stop-[tipo].sh                  # Detener servicios
├── logs-[tipo].sh                  # Ver logs
└── status-[tipo].sh                # Estado de servicios
```

## 🔐 Variables de Entorno Generadas

El script genera automáticamente un archivo `.env` con:

### Contraseñas Seguras

- `DB_PASSWORD`: Contraseña de base de datos (32 caracteres)
- `JWT_SECRET`: Clave secreta JWT (64 caracteres)
- `REDIS_PASSWORD`: Contraseña Redis (32 caracteres)

### Configuración Base

- `DB_DATABASE`: Nombre específico según el tipo
- `NODE_ENV`: Entorno según el tipo
- `CORS_ORIGIN`: Configuración CORS apropiada
- `RATE_LIMIT_REQUESTS`: Límites según el tipo

### Variables que Requieren Configuración Manual

```bash
# Google OAuth (requiere configuración manual)
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here

# Email (requiere configuración manual)
MAIL_USER=your_email@gmail.com
MAIL_PASS=your_app_password_here

# Frontend URL (requiere configuración manual)
FRONTEND_URL=http://localhost:3000
```

## 🚀 Flujo de Uso

### Paso 1: Ejecutar el Script

```bash
./deploy-interactive.sh
```

### Paso 2: Seleccionar Tipo de Instalación

```
📋 Tipos de instalación disponibles:

1. 🏠 Desarrollo Local
2. 🎓 Centro Educativo
3. 🌐 Local con Cloudflare Tunnel
4. 🏢 VPS Profesional
5. 🎯 Despliegue Genérico

Selecciona el tipo de instalación (1-5):
```

### Paso 3: Configuración Adicional

Según el tipo seleccionado, el script solicitará información adicional:

#### Para VPS Profesional:

```
Ingresa el dominio (ej: mi-dominio.com):
Ingresa el email para SSL (ej: admin@mi-dominio.com):
Ingresa la IP del VPS (ej: 192.168.1.100):
```

#### Para Despliegue Genérico:

```
Selecciona el entorno (local/staging/production):
```

### Paso 4: Verificación de Prerrequisitos

El script verifica automáticamente:

- ✅ Docker instalado y funcionando
- ✅ Docker Compose instalado
- ✅ Permisos de escritura en el directorio

### Paso 5: Generación de Archivos

El script genera automáticamente:

- 📁 Archivo docker-compose.yml específico
- 🔧 Archivo .env con contraseñas seguras
- 🌐 Configuraciones de Nginx (si aplica)
- 📝 Scripts de gestión

### Paso 6: Despliegue Opcional

```
¿Quieres construir y levantar los servicios ahora? (y/N):
```

## 📊 URLs y Comandos por Tipo

### Desarrollo Local

```bash
🌐 URLs:
   - API: http://localhost:3000/api
   - Health: http://localhost:3000/health

📝 Comandos:
   - Iniciar: ./start-fct-local.sh
   - Detener: ./stop-fct-local.sh
   - Logs: ./logs-fct-local.sh
   - Estado: ./status-fct-local.sh
```

### Centro Educativo

```bash
🌐 URLs:
   - API: http://localhost/api
   - Health: http://localhost/health
   - Status: http://localhost/status

📝 Comandos:
   - Iniciar: ./start-fct-centro.sh
   - Detener: ./stop-fct-centro.sh
   - Logs: ./logs-fct-centro.sh
   - Estado: ./status-fct-centro.sh
```

### Cloudflare Tunnel

```bash
🌐 URLs:
   - API: http://localhost:8080/api
   - Health: http://localhost:8080/health

📝 Comandos:
   - Iniciar: ./start-fct-cloudflare.sh
   - Detener: ./stop-fct-cloudflare.sh
   - Logs: ./logs-fct-cloudflare.sh
   - Estado: ./status-fct-cloudflare.sh
```

### VPS Profesional

```bash
🌐 URLs:
   - API: https://tu-dominio.com/api
   - Health: https://tu-dominio.com/health

📝 Comandos:
   - Iniciar: ./start-fct-vps.sh
   - Detener: ./stop-fct-vps.sh
   - Logs: ./logs-fct-vps.sh
   - Estado: ./status-fct-vps.sh
```

## 🔧 Configuración Post-Despliegue

### 1. Configurar Google OAuth

```bash
# Editar .env
nano .env

# Configurar estas variables:
GOOGLE_CLIENT_ID=tu_google_client_id_real
GOOGLE_CLIENT_SECRET=tu_google_client_secret_real
```

### 2. Configurar Email

```bash
# Editar .env
nano .env

# Configurar estas variables:
MAIL_USER=tu_email@gmail.com
MAIL_PASS=tu_app_password_de_gmail
```

### 3. Configurar Frontend URL

```bash
# Editar .env
nano .env

# Configurar esta variable:
FRONTEND_URL=https://tu-dominio.com
```

## 🚨 Troubleshooting

### Error: "Docker no está instalado"

```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

### Error: "Docker Compose no está instalado"

```bash
# Instalar Docker Compose
sudo apt update
sudo apt install docker-compose
```

### Error: "Permisos denegados"

```bash
# Dar permisos de ejecución
chmod +x deploy-interactive.sh
chmod +x start-*.sh
chmod +x stop-*.sh
chmod +x logs-*.sh
chmod +x status-*.sh
```

### Error: "Puerto ya en uso"

```bash
# Verificar puertos en uso
sudo netstat -tulpn | grep :3000
sudo netstat -tulpn | grep :80

# Detener servicios que usen esos puertos
sudo systemctl stop apache2  # Si está usando puerto 80
```

## 📚 Comandos Útiles

### Verificar Estado General

```bash
# Ver todos los contenedores
docker ps

# Ver logs de todos los servicios
docker-compose -f docker-compose.yml logs -f

# Ver uso de recursos
docker stats
```

### Backup y Restauración

```bash
# Backup de base de datos
docker exec fct-postgres-local pg_dump -U postgres fct_local > backup.sql

# Restaurar base de datos
docker exec -i fct-postgres-local psql -U postgres fct_local < backup.sql
```

### Limpieza

```bash
# Limpiar contenedores detenidos
docker container prune

# Limpiar imágenes no utilizadas
docker image prune

# Limpiar volúmenes no utilizados
docker volume prune
```

## 🔄 Actualización

Para actualizar el despliegue:

```bash
# 1. Detener servicios
./stop-[tipo].sh

# 2. Actualizar código
git pull origin main

# 3. Reconstruir y levantar
./start-[tipo].sh
```

## 📞 Soporte

Si encuentras problemas:

1. **Verificar logs**: `./logs-[tipo].sh`
2. **Verificar estado**: `./status-[tipo].sh`
3. **Revisar configuración**: `nano .env`
4. **Reiniciar servicios**: `./stop-[tipo].sh && ./start-[tipo].sh`

## 🎉 ¡Listo!

Una vez completado el script, tendrás un despliegue completamente funcional del proyecto FCT configurado según tus necesidades específicas.

¡Disfruta desarrollando! 🚀
