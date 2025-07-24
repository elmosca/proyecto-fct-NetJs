#!/bin/bash

# Script de Despliegue para Centro Educativo - Proyecto FCT
# Configuración pragmática sin dependencias externas

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

print_status "🎓 Configurando despliegue para centro educativo..."

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.prod.yml" ]; then
    print_error "No se encontró docker-compose.prod.yml. Ejecuta desde el directorio raíz del proyecto."
    exit 1
fi

# 1. Verificar Docker
print_status "🐳 Verificando Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado. Instálalo primero."
    print_status "Instrucciones: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose no está instalado. Instálalo primero."
    exit 1
fi

# 2. Obtener IP del servidor
print_status "🌐 Detectando configuración de red..."
SERVER_IP=$(hostname -I | awk '{print $1}')
print_status "IP del servidor: $SERVER_IP"

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
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=fct_centro/" .env
    
    print_success "Variables de entorno configuradas con contraseñas seguras"
    print_warning "⚠️ Edita el archivo .env con tus configuraciones específicas"
fi

# 4. Crear configuración de Nginx para centro educativo
print_status "🌐 Creando configuración de Nginx para centro educativo..."
mkdir -p nginx

cat > nginx/nginx-centro.conf << EOF
# Configuración Nginx para Centro Educativo
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
    client_max_body_size 10M;

    # Rate limiting básico
    limit_req_zone \$binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone \$binary_remote_addr zone=auth:10m rate=5r/s;

    # Upstream backend
    upstream backend {
        server api:3000;
    }

    # HTTP server (puerto 80)
    server {
        listen 80;
        server_name localhost \$SERVER_IP;

        # Página de bienvenida
        location = / {
            return 200 'Sistema de Gestión FCT - Centro Educativo\nAPI disponible en /api\nHealth check en /health';
            add_header Content-Type text/plain;
        }

        # API endpoints
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
            proxy_read_timeout 300s;
            proxy_connect_timeout 75s;
        }

        # Authentication endpoints (stricter rate limiting)
        location /api/auth/ {
            limit_req zone=auth burst=10 nodelay;
            
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }

        # Health check
        location /health {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
        }

        # Status page
        location /status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            allow \$SERVER_IP/24;
            deny all;
        }

        # Default
        location / {
            return 404;
        }
    }
}
EOF

# 5. Crear docker-compose para centro educativo
print_status "🐳 Creando docker-compose para centro educativo..."
cat > docker-compose.centro.yml << EOF
version: '3.8'

services:
  # API Backend
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: production
    container_name: fct-api-centro
    restart: unless-stopped
    environment:
      NODE_ENV: production
      PORT: 3000
      
      # Base de Datos
      DB_HOST: postgres
      DB_PORT: 5432
      DB_USERNAME: postgres
      DB_PASSWORD: \${DB_PASSWORD}
      DB_DATABASE: fct_centro
      
      # Autenticación
      JWT_SECRET: \${JWT_SECRET}
      JWT_EXPIRATION: 24h
      
      # CORS - Permitir acceso desde red local
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
    container_name: fct-postgres-centro
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: \${DB_PASSWORD}
      POSTGRES_DB: fct_centro
    env_file:
      - .env
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/init-scripts:/docker-entrypoint-initdb.d
    networks:
      - fct-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d fct_centro"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Nginx para centro educativo
  nginx:
    image: nginx:alpine
    container_name: fct-nginx-centro
    restart: unless-stopped
    ports:
      - "80:80"  # Puerto estándar HTTP
    volumes:
      - ./nginx/nginx-centro.conf:/etc/nginx/nginx.conf:ro
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
docker-compose -f docker-compose.centro.yml build --no-cache
docker-compose -f docker-compose.centro.yml up -d

# 7. Esperar a que los servicios estén listos
print_status "⏳ Esperando a que los servicios estén listos..."
sleep 15

# 8. Verificar que todo funciona
print_status "🔍 Verificando servicios..."

# Verificar API
if curl -s http://localhost/health | grep -q "ok"; then
    print_success "✅ API funcionando en http://localhost"
else
    print_warning "⚠️ API no responde correctamente"
fi

# Verificar base de datos
if docker exec fct-postgres-centro pg_isready -U postgres -d fct_centro > /dev/null 2>&1; then
    print_success "✅ Base de datos funcionando"
else
    print_warning "⚠️ Base de datos no responde correctamente"
fi

# 9. Crear script de monitoreo
print_status "📊 Creando script de monitoreo..."
cat > monitor-centro.sh << 'EOF'
#!/bin/bash

echo "=== SISTEMA DE GESTIÓN FCT - CENTRO EDUCATIVO ==="
echo "Fecha: $(date)"
echo ""

echo "=== Estado de Contenedores ==="
docker ps --filter "name=fct-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=== Uso de Recursos ==="
docker stats --no-stream --filter "name=fct-" --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

echo ""
echo "=== Logs de API (últimas 5 líneas) ==="
docker logs --tail=5 fct-api-centro

echo ""
echo "=== Estado de Base de Datos ==="
docker exec fct-postgres-centro pg_isready -U postgres -d fct_centro

echo ""
echo "=== URLs Disponibles ==="
echo "🌐 API Principal: http://localhost/api"
echo "🔍 Health Check: http://localhost/health"
echo "📊 Status Nginx: http://localhost/status"
echo "📱 Acceso desde red local: http://$(hostname -I | awk '{print $1}')/api"
echo ""
echo "=== Comandos Útiles ==="
echo "📊 Monitoreo: ./monitor-centro.sh"
echo "📋 Ver logs: docker-compose -f docker-compose.centro.yml logs -f"
echo "🔄 Reiniciar: docker-compose -f docker-compose.centro.yml restart"
echo "🛑 Detener: docker-compose -f docker-compose.centro.yml down"
echo "💾 Backup: ./backup-centro.sh"
EOF

chmod +x monitor-centro.sh

# 10. Crear script de backup
print_status "💾 Creando script de backup..."
cat > backup-centro.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

echo "💾 Creando backup del sistema..."

# Backup de base de datos
echo "📊 Backup de base de datos..."
docker exec fct-postgres-centro pg_dump -U postgres fct_centro > $BACKUP_DIR/db_backup_$DATE.sql

# Backup de archivos
echo "📁 Backup de archivos..."
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz ./backend/storage

# Backup de configuración
echo "⚙️ Backup de configuración..."
cp .env $BACKUP_DIR/env_backup_$DATE

# Mantener solo los últimos 10 backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
find $BACKUP_DIR -name "env_backup_*" -mtime +7 -delete

echo "✅ Backup completado: $DATE"
echo "📁 Ubicación: $BACKUP_DIR/"
echo "📋 Archivos creados:"
ls -la $BACKUP_DIR/*$DATE*
EOF

chmod +x backup-centro.sh

# 11. Crear script de instalación de dependencias
print_status "📦 Creando script de instalación de dependencias..."
cat > install-dependencies.sh << 'EOF'
#!/bin/bash

echo "📦 Instalando dependencias para Centro Educativo..."

# Detectar sistema operativo
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Sistema Linux detectado"
    
    # Ubuntu/Debian
    if command -v apt-get &> /dev/null; then
        echo "📦 Instalando Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        
        echo "📦 Instalando Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        
        echo "📦 Instalando herramientas adicionales..."
        sudo apt update
        sudo apt install -y curl wget git htop
        
    # CentOS/RHEL
    elif command -v yum &> /dev/null; then
        echo "📦 Instalando Docker en CentOS/RHEL..."
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Sistema macOS detectado"
    echo "📦 Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop"
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "🪟 Sistema Windows detectado"
    echo "📦 Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop"
fi

echo "✅ Instalación completada"
echo "🔄 Reinicia la sesión para aplicar los cambios de grupo Docker"
echo "🚀 Luego ejecuta: ./deploy-centro-educativo.sh"
EOF

chmod +x install-dependencies.sh

# 12. Crear documentación rápida
print_status "📚 Creando documentación rápida..."
cat > GUIA_RAPIDA_CENTRO.md << EOF
# Guía Rápida - Centro Educativo

## 🚀 Inicio Rápido

### 1. Instalar Dependencias
\`\`\`bash
./install-dependencies.sh
\`\`\`

### 2. Desplegar Sistema
\`\`\`bash
./deploy-centro-educativo.sh
\`\`\`

### 3. Verificar Funcionamiento
\`\`\`bash
./monitor-centro.sh
\`\`\`

## 🌐 Acceso al Sistema

- **URL Local**: http://localhost/api
- **URL Red Local**: http://$(hostname -I | awk '{print $1}')/api
- **Health Check**: http://localhost/health
- **Status**: http://localhost/status

## 📱 Configuración para Dispositivos

### Flutter Móvil
\`\`\`dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://$(hostname -I | awk '{print $1}'):80/api';
}
\`\`\`

### Flutter Web
\`\`\`dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://localhost/api';
}
\`\`\`

## 📊 Comandos Útiles

- **Monitoreo**: \`./monitor-centro.sh\`
- **Backup**: \`./backup-centro.sh\`
- **Logs**: \`docker-compose -f docker-compose.centro.yml logs -f\`
- **Reiniciar**: \`docker-compose -f docker-compose.centro.yml restart\`
- **Detener**: \`docker-compose -f docker-compose.centro.yml down\`

## 🔧 Configuración Avanzada

### Cambiar Puerto
Editar \`docker-compose.centro.yml\`:
\`\`\`yaml
ports:
  - "8080:80"  # Cambiar 80 por el puerto deseado
\`\`\`

### Configurar Dominio
Editar \`nginx/nginx-centro.conf\`:
\`\`\`nginx
server_name localhost tu-dominio.com;
\`\`\`

## 🛠️ Troubleshooting

### Problema: Puerto 80 ocupado
\`\`\`bash
# Ver qué usa el puerto 80
sudo netstat -tulpn | grep :80

# Cambiar puerto en docker-compose.centro.yml
\`\`\`

### Problema: Contenedores no inician
\`\`\`bash
# Ver logs detallados
docker-compose -f docker-compose.centro.yml logs

# Verificar Docker
docker --version
docker-compose --version
\`\`\`

## 📞 Soporte

- **Email**: jualas@gmail.com
- **Documentación**: ./docs/CENTRO_EDUCATIVO_SETUP.md
EOF

# 13. Mostrar información final
print_success "🎉 Configuración para centro educativo completada!"
echo ""
echo "📋 Información del despliegue:"
echo "   🌐 API Local: http://localhost/api"
echo "   🌐 API Red Local: http://$SERVER_IP/api"
echo "   🔍 Health Check: http://localhost/health"
echo "   📊 Status: http://localhost/status"
echo "   🗄️ Base de Datos: PostgreSQL en Docker"
echo "   📊 Monitoreo: ./monitor-centro.sh"
echo "   💾 Backup: ./backup-centro.sh"
echo ""
echo "📚 Documentación:"
echo "   📖 Guía Rápida: GUIA_RAPIDA_CENTRO.md"
echo "   📖 Documentación Completa: ./docs/CENTRO_EDUCATIVO_SETUP.md"
echo ""
echo "📝 Comandos útiles:"
echo "   Ver estado: ./monitor-centro.sh"
echo "   Ver logs: docker-compose -f docker-compose.centro.yml logs -f"
echo "   Reiniciar: docker-compose -f docker-compose.centro.yml restart"
echo "   Detener: docker-compose -f docker-compose.centro.yml down"
echo "   Backup: ./backup-centro.sh"
echo ""
print_warning "⚠️ Para presentación: usa http://$SERVER_IP/api desde cualquier dispositivo en la red"
print_warning "⚠️ Edita el archivo .env con tus configuraciones específicas" 