#!/bin/bash

# Script de Despliegue Local con Cloudflare Tunnels - Proyecto FCT
# Configuración ideal para centro educativo y presentación

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_status "🚀 Configurando despliegue local con Cloudflare Tunnels..."

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.prod.yml" ]; then
    print_error "No se encontró docker-compose.prod.yml. Ejecuta desde el directorio raíz del proyecto."
    exit 1
fi

# 1. Verificar Docker
print_status "🐳 Verificando Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado. Instálalo primero."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose no está instalado. Instálalo primero."
    exit 1
fi

# 2. Verificar Cloudflare Tunnel
print_status "🌐 Verificando Cloudflare Tunnel..."
if ! command -v cloudflared &> /dev/null; then
    print_warning "Cloudflare Tunnel no está instalado. Instalando..."
    
    # Detectar sistema operativo
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
        sudo dpkg -i cloudflared-linux-amd64.deb
        rm cloudflared-linux-amd64.deb
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install cloudflare/cloudflare/cloudflared
    else
        print_error "Sistema operativo no soportado. Instala cloudflared manualmente."
        exit 1
    fi
fi

# 3. Configurar variables de entorno
print_status "⚙️ Configurando variables de entorno..."
if [ ! -f ".env" ]; then
    print_warning "Archivo .env no encontrado. Creando desde .env.example..."
    cp backend/.env.example .env
    
    # Generar contraseñas seguras
    DB_PASSWORD=$(openssl rand -base64 32)
    JWT_SECRET=$(openssl rand -base64 64)
    
    # Actualizar .env con valores seguros
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env
    sed -i "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" .env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=fct_local/" .env
    
    print_success "Variables de entorno configuradas con contraseñas seguras"
    print_warning "⚠️ Edita el archivo .env con tus configuraciones específicas"
fi

# 4. Crear configuración de Nginx simplificada
print_status "🌐 Creando configuración de Nginx simplificada..."
mkdir -p nginx

cat > nginx/nginx-simple.conf << 'EOF'
# Configuración Nginx simplificada para desarrollo local
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Performance
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;

    # Rate limiting básico
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

    # Upstream backend
    upstream backend {
        server api:3000;
    }

    # HTTP server
    server {
        listen 80;
        server_name localhost;

        # API endpoints
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Health check
        location /health {
            proxy_pass http://backend;
            proxy_set_header Host $host;
        }

        # Default
        location / {
            return 404;
        }
    }
}
EOF

# 5. Crear docker-compose simplificado
print_status "🐳 Creando docker-compose simplificado..."
cat > docker-compose.local.yml << 'EOF'
version: '3.8'

services:
  # API Backend
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: production
    container_name: fct-api-local
    restart: unless-stopped
    environment:
      NODE_ENV: production
      PORT: 3000
      
      # Base de Datos
      DB_HOST: postgres
      DB_PORT: 5432
      DB_USERNAME: postgres
      DB_PASSWORD: ${DB_PASSWORD}
      DB_DATABASE: fct_local
      
      # Autenticación
      JWT_SECRET: ${JWT_SECRET}
      JWT_EXPIRATION: 24h
      
      # CORS
      CORS_ORIGIN: "*"
      
    env_file:
      - .env
    volumes:
      - ./backend/storage:/usr/src/app/storage
      - ./backend/logs:/usr/src/app/logs
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - fct-network
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Base de Datos PostgreSQL
  postgres:
    image: postgres:13-alpine
    container_name: fct-postgres-local
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: fct_local
    env_file:
      - .env
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/init-scripts:/docker-entrypoint-initdb.d
    networks:
      - fct-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d fct_local"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Nginx simplificado
  nginx:
    image: nginx:alpine
    container_name: fct-nginx-local
    restart: unless-stopped
    ports:
      - "8080:80"  # Puerto local para desarrollo
    volumes:
      - ./nginx/nginx-simple.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - api
    networks:
      - fct-network

volumes:
  postgres_data:
    driver: local

networks:
  fct-network:
    driver: bridge
EOF

# 6. Construir y levantar contenedores
print_status "🐳 Construyendo y levantando contenedores..."
docker-compose -f docker-compose.local.yml build --no-cache
docker-compose -f docker-compose.local.yml up -d

# 7. Esperar a que los servicios estén listos
print_status "⏳ Esperando a que los servicios estén listos..."
sleep 15

# 8. Verificar que todo funciona
print_status "🔍 Verificando servicios..."

# Verificar API
if curl -s http://localhost:8080/health | grep -q "ok"; then
    print_success "✅ API funcionando en http://localhost:8080"
else
    print_warning "⚠️ API no responde correctamente"
fi

# Verificar base de datos
if docker exec fct-postgres-local pg_isready -U postgres -d fct_local > /dev/null 2>&1; then
    print_success "✅ Base de datos funcionando"
else
    print_warning "⚠️ Base de datos no responde correctamente"
fi

# 9. Configurar Cloudflare Tunnel
print_status "🌐 Configurando Cloudflare Tunnel..."

# Crear script para iniciar tunnel
cat > start-tunnel.sh << 'EOF'
#!/bin/bash

echo "🚀 Iniciando Cloudflare Tunnel..."
echo "📋 URL pública disponible en unos segundos..."

# Iniciar tunnel para la API
cloudflared tunnel --url http://localhost:8080 &

# Guardar PID para poder detenerlo después
echo $! > .tunnel.pid

echo "✅ Tunnel iniciado. Presiona Ctrl+C para detener."
echo "🌐 URL pública: https://[random-subdomain].trycloudflare.com"
echo "📱 Usa esta URL para acceder desde cualquier dispositivo"

# Esperar hasta que se presione Ctrl+C
trap 'echo "🛑 Deteniendo tunnel..."; kill $(cat .tunnel.pid); rm .tunnel.pid; exit' INT
wait
EOF

chmod +x start-tunnel.sh

# 10. Crear script de monitoreo
print_status "📊 Creando script de monitoreo..."
cat > monitor-local.sh << 'EOF'
#!/bin/bash

echo "=== Estado de Contenedores ==="
docker ps --filter "name=fct-"

echo ""
echo "=== Uso de Recursos ==="
docker stats --no-stream --filter "name=fct-"

echo ""
echo "=== Logs de API ==="
docker logs --tail=10 fct-api-local

echo ""
echo "=== Estado de Base de Datos ==="
docker exec fct-postgres-local pg_isready -U postgres -d fct_local

echo ""
echo "=== URLs Disponibles ==="
echo "🌐 API Local: http://localhost:8080/api"
echo "🔍 Health Check: http://localhost:8080/health"
echo "📊 Monitoreo: ./monitor-local.sh"
echo "🚀 Iniciar Tunnel: ./start-tunnel.sh"
EOF

chmod +x monitor-local.sh

# 11. Crear script de backup
print_status "💾 Creando script de backup..."
cat > backup-local.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

echo "💾 Creando backup..."

# Backup de base de datos
docker exec fct-postgres-local pg_dump -U postgres fct_local > $BACKUP_DIR/db_backup_$DATE.sql

# Backup de archivos
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz ./backend/storage

# Mantener solo los últimos 5 backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "✅ Backup completado: $DATE"
echo "📁 Ubicación: $BACKUP_DIR/"
EOF

chmod +x backup-local.sh

# 12. Mostrar información final
print_success "🎉 Configuración local completada!"
echo ""
echo "📋 Información del despliegue:"
echo "   🌐 API Local: http://localhost:8080/api"
echo "   🔍 Health Check: http://localhost:8080/health"
echo "   🗄️ Base de Datos: PostgreSQL en Docker"
echo "   📊 Monitoreo: ./monitor-local.sh"
echo "   💾 Backup: ./backup-local.sh"
echo ""
echo "🚀 Para exponer públicamente:"
echo "   ./start-tunnel.sh"
echo ""
echo "📝 Comandos útiles:"
echo "   Ver estado: ./monitor-local.sh"
echo "   Ver logs: docker-compose -f docker-compose.local.yml logs -f"
echo "   Reiniciar: docker-compose -f docker-compose.local.yml restart"
echo "   Detener: docker-compose -f docker-compose.local.yml down"
echo "   Backup: ./backup-local.sh"
echo ""
print_warning "⚠️ Para presentación: ejecuta ./start-tunnel.sh y usa la URL pública"
print_warning "⚠️ Edita el archivo .env con tus configuraciones específicas" 