#!/bin/bash

# =================================================
# Script de Despliegue Interactivo - Proyecto FCT
# =================================================
# Genera automáticamente la configuración Docker Compose
# según el tipo de instalación seleccionado

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables globales
PROJECT_NAME="fct-project"
DOMAIN=""
EMAIL=""
VPS_IP=""
INSTALLATION_TYPE=""
COMPOSE_FILE=""
ENV_FILE=""

# Funciones de utilidad
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

log_question() {
    echo -e "${CYAN}[QUESTION]${NC} $1"
}

# Función para mostrar banner
show_banner() {
    echo "=================================================="
    echo "🚀 Script de Despliegue Interactivo - Proyecto FCT"
    echo "=================================================="
    echo ""
    echo "Este script te guiará para configurar el despliegue"
    echo "según tus necesidades específicas."
    echo ""
}

# Función para mostrar tipos de instalación
show_installation_types() {
    echo "📋 Tipos de instalación disponibles:"
    echo ""
    echo "1. 🏠 Desarrollo Local"
    echo "   - Para desarrollo y pruebas locales"
    echo "   - Sin SSL, puerto 3000"
    echo "   - Base de datos: fct_local"
    echo ""
    echo "2. 🎓 Centro Educativo"
    echo "   - Para uso interno en centros educativos"
    echo "   - Acceso desde red local"
    echo "   - Base de datos: fct_centro"
    echo "   - Rate limiting básico"
    echo ""
    echo "3. 🌐 Local con Cloudflare Tunnel"
    echo "   - Para demos y presentaciones"
    echo "   - Acceso externo seguro sin configuración de puertos"
    echo "   - Base de datos: fct_local"
    echo "   - SSL automático con Cloudflare"
    echo ""
    echo "4. 🏢 VPS Profesional"
    echo "   - Para producción en VPS propio"
    echo "   - SSL automático con Let's Encrypt"
    echo "   - Base de datos: fct_production"
    echo "   - Monitoreo y backup automático"
    echo ""
    echo "5. 🎯 Despliegue Genérico"
    echo "   - Configuración flexible para múltiples entornos"
    echo "   - Soporte para local, staging, producción"
    echo "   - Variables de entorno específicas por entorno"
    echo ""
}

# Función para seleccionar tipo de instalación
select_installation_type() {
    while true; do
        log_question "Selecciona el tipo de instalación (1-5):"
        read -r choice
        
        case $choice in
            1)
                INSTALLATION_TYPE="local"
                log_success "Seleccionado: Desarrollo Local"
                break
                ;;
            2)
                INSTALLATION_TYPE="centro-educativo"
                log_success "Seleccionado: Centro Educativo"
                break
                ;;
            3)
                INSTALLATION_TYPE="cloudflare"
                log_success "Seleccionado: Local con Cloudflare Tunnel"
                break
                ;;
            4)
                INSTALLATION_TYPE="vps"
                log_success "Seleccionado: VPS Profesional"
                break
                ;;
            5)
                INSTALLATION_TYPE="generic"
                log_success "Seleccionado: Despliegue Genérico"
                break
                ;;
            *)
                log_error "Opción inválida. Selecciona 1-5."
                ;;
        esac
    done
}

# Función para solicitar información adicional según el tipo
get_additional_info() {
    case $INSTALLATION_TYPE in
        "vps")
            log_step "Configuración para VPS Profesional"
            log_question "Ingresa el dominio (ej: mi-dominio.com):"
            read -r DOMAIN
            log_question "Ingresa el email para SSL (ej: admin@mi-dominio.com):"
            read -r EMAIL
            log_question "Ingresa la IP del VPS (ej: 192.168.1.100):"
            read -r VPS_IP
            ;;
        "cloudflare")
            log_step "Configuración para Cloudflare Tunnel"
            log_warning "Se instalará Cloudflare Tunnel automáticamente si no está disponible"
            ;;
        "generic")
            log_step "Configuración para Despliegue Genérico"
            log_question "Selecciona el entorno (local/staging/production):"
            read -r ENVIRONMENT
            case $ENVIRONMENT in
                "local")
                    COMPOSE_FILE="docker-compose.yml"
                    ENV_FILE=".env"
                    ;;
                "staging")
                    COMPOSE_FILE="docker-compose.staging.yml"
                    ENV_FILE=".env.staging"
                    ;;
                "production")
                    COMPOSE_FILE="docker-compose.prod.yml"
                    ENV_FILE=".env.production"
                    ;;
                *)
                    log_error "Entorno inválido. Usando local por defecto."
                    COMPOSE_FILE="docker-compose.yml"
                    ENV_FILE=".env"
                    ;;
            esac
            ;;
    esac
}

# Función para generar contraseñas seguras
generate_secure_password() {
    openssl rand -base64 32
}

generate_jwt_secret() {
    openssl rand -base64 64
}

# Función para crear archivo .env
create_env_file() {
    local env_file=$1
    local db_name=$2
    local node_env=$3
    local cors_origin=$4
    local rate_limit=$5
    
    log_step "Creando archivo de variables de entorno: $env_file"
    
    # Generar contraseñas seguras
    local db_password=$(generate_secure_password)
    local jwt_secret=$(generate_jwt_secret)
    
    cat > "$env_file" << EOF
# ========================================
# CONFIGURACIÓN DE BASE DE DATOS
# ========================================
DB_HOST=postgres
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=$db_password
DB_DATABASE=$db_name

# ========================================
# CONFIGURACIÓN DE AUTENTICACIÓN
# ========================================
JWT_SECRET=$jwt_secret
JWT_EXPIRATION=24h
JWT_REFRESH_EXPIRATION=7d

# ========================================
# CONFIGURACIÓN DE CORS
# ========================================
CORS_ORIGIN=$cors_origin
ALLOWED_ORIGINS=$cors_origin

# ========================================
# CONFIGURACIÓN DE RATE LIMITING
# ========================================
RATE_LIMIT_TTL=60
RATE_LIMIT_REQUESTS=$rate_limit

# ========================================
# CONFIGURACIÓN DE ARCHIVOS
# ========================================
MAX_FILE_SIZE_MB=10
ALLOWED_FILE_TYPES=pdf,doc,docx,jpg,jpeg,png

# ========================================
# CONFIGURACIÓN DE REDIS
# ========================================
REDIS_PASSWORD=$(generate_secure_password)
REDIS_PORT=6379

# ========================================
# CONFIGURACIÓN DE PUERTOS
# ========================================
API_PORT=3000
DB_PORT=5432

# ========================================
# CONFIGURACIÓN DE ENTORNO
# ========================================
NODE_ENV=$node_env
PORT=3000
LOG_LEVEL=info

# ========================================
# CONFIGURACIÓN DE GOOGLE OAUTH
# ========================================
GOOGLE_CLIENT_ID=your_google_client_id_here
GOOGLE_CLIENT_SECRET=your_google_client_secret_here

# ========================================
# CONFIGURACIÓN DE EMAIL
# ========================================
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=your_email@gmail.com
MAIL_PASS=your_app_password_here

# ========================================
# CONFIGURACIÓN DE FRONTEND
# ========================================
FRONTEND_URL=http://localhost:3000
EOF

    log_success "Archivo $env_file creado con contraseñas seguras"
    log_warning "⚠️ Edita $env_file con tus configuraciones específicas (Google OAuth, Email, etc.)"
}

# Función para generar docker-compose.yml para desarrollo local
generate_local_compose() {
    log_step "Generando docker-compose.yml para desarrollo local"
    
    cat > "docker-compose.yml" << 'EOF'
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
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: development
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

volumes:
  postgres_data:
    driver: local

networks:
  fct-network:
    driver: bridge
EOF

    log_success "docker-compose.yml para desarrollo local creado"
}

# Función para generar docker-compose.yml para centro educativo
generate_centro_compose() {
    log_step "Generando docker-compose.yml para centro educativo"
    
    cat > "docker-compose.centro.yml" << 'EOF'
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
      DB_PASSWORD: ${DB_PASSWORD}
      DB_DATABASE: fct_centro
      
      # Autenticación
      JWT_SECRET: ${JWT_SECRET}
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
      POSTGRES_PASSWORD: ${DB_PASSWORD}
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

    log_success "docker-compose.yml para centro educativo creado"
}

# Función para generar docker-compose.yml para Cloudflare
generate_cloudflare_compose() {
    log_step "Generando docker-compose.yml para Cloudflare Tunnel"
    
    cat > "docker-compose.cloudflare.yml" << 'EOF'
version: '3.8'

services:
  # API Backend
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: production
    container_name: fct-api-cloudflare
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
    container_name: fct-postgres-cloudflare
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
    container_name: fct-nginx-cloudflare
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

    log_success "docker-compose.yml para Cloudflare Tunnel creado"
}

# Función para generar docker-compose.yml para VPS
generate_vps_compose() {
    log_step "Generando docker-compose.yml para VPS profesional"
    
    cat > "docker-compose.vps.yml" << EOF
version: '3.8'

services:
  # API Backend
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: production
    image: fct-backend-api:latest
    container_name: fct-api-vps
    restart: unless-stopped
    ports:
      - "\${API_PORT:-3000}:3000"
    environment:
      NODE_ENV: production
      PORT: 3000
      
      # Base de Datos
      DATABASE_URL: \${DATABASE_URL}
      DB_HOST: \${DB_HOST:-postgres}
      DB_PORT: \${DB_PORT:-5432}
      DB_USERNAME: \${DB_USERNAME}
      DB_PASSWORD: \${DB_PASSWORD}
      DB_DATABASE: \${DB_DATABASE}
      
      # Autenticación
      JWT_SECRET: \${JWT_SECRET}
      JWT_EXPIRATION: \${JWT_EXPIRATION:-24h}
      JWT_REFRESH_EXPIRATION: \${JWT_REFRESH_EXPIRATION:-7d}
      
      # CORS y Seguridad
      CORS_ORIGIN: \${CORS_ORIGIN}
      ALLOWED_ORIGINS: \${ALLOWED_ORIGINS}
      
      # Archivos
      MAX_FILE_SIZE_MB: \${MAX_FILE_SIZE_MB:-10}
      ALLOWED_FILE_TYPES: \${ALLOWED_FILE_TYPES:-pdf,doc,docx,jpg,jpeg,png}
      
      # Rate Limiting
      RATE_LIMIT_TTL: \${RATE_LIMIT_TTL:-60}
      RATE_LIMIT_REQUESTS: \${RATE_LIMIT_REQUESTS:-100}
      
    volumes:
      - ./backend/storage:/usr/src/app/storage
      - ./backend/logs:/usr/src/app/logs
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - fct-network
    healthcheck:
      test: ["CMD", "nc", "-z", "127.0.0.1", "3000"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: "0.5"
        reservations:
          memory: 256M
          cpus: "0.25"
      restart_policy:
        condition: on-failure
        max_attempts: 3
        delay: 5s

  # Base de Datos PostgreSQL
  postgres:
    image: postgres:13-alpine
    container_name: fct-postgres-vps
    restart: unless-stopped
    environment:
      POSTGRES_USER: \${DB_USERNAME}
      POSTGRES_PASSWORD: \${DB_PASSWORD}
      POSTGRES_DB: \${DB_DATABASE}
      POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/init-scripts:/docker-entrypoint-initdb.d
    ports:
      - "\${DB_PORT:-5432}:5432"
    networks:
      - fct-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U \${DB_USERNAME} -d \${DB_DATABASE}"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 30s
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: "1.0"
        reservations:
          memory: 512M
          cpus: "0.5"

  # Redis para caché y sesiones
  redis:
    image: redis:7-alpine
    container_name: fct-redis-vps
    restart: unless-stopped
    command: redis-server --appendonly yes --requirepass \${REDIS_PASSWORD:-secure_redis_password}
    volumes:
      - redis_data:/data
    ports:
      - "\${REDIS_PORT:-6379}:6379"
    networks:
      - fct-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          memory: 256M
          cpus: "0.25"
        reservations:
          memory: 128M
          cpus: "0.125"

  # Nginx Load Balancer
  nginx:
    image: nginx:alpine
    container_name: fct-nginx-vps
    restart: unless-stopped
    ports:
      - "127.0.0.1:80:80"    # Solo localhost para Cloudflare
      - "127.0.0.1:443:443"  # Solo localhost para Cloudflare
    volumes:
      - /etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
      - /var/log/nginx:/var/log/nginx
    depends_on:
      - api
    networks:
      - fct-network
    deploy:
      resources:
        limits:
          memory: 128M
          cpus: "0.25"

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

networks:
  fct-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
EOF

    log_success "docker-compose.yml para VPS profesional creado"
}

# Función para generar configuraciones de Nginx
generate_nginx_configs() {
    log_step "Generando configuraciones de Nginx"
    
    mkdir -p nginx
    
    # Configuración para centro educativo
    cat > "nginx/nginx-centro.conf" << 'EOF'
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
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=auth:10m rate=5r/s;

    # Upstream backend
    upstream backend {
        server api:3000;
    }

    # HTTP server (puerto 80)
    server {
        listen 80;
        server_name localhost;

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
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 300s;
            proxy_connect_timeout 75s;
        }

        # Authentication endpoints (stricter rate limiting)
        location /api/auth/ {
            limit_req zone=auth burst=10 nodelay;
            
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

        # Status page
        location /status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }

        # Default
        location / {
            return 404;
        }
    }
}
EOF

    # Configuración simplificada para Cloudflare
    cat > "nginx/nginx-simple.conf" << 'EOF'
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
    client_max_body_size 10M;

    # Upstream backend
    upstream backend {
        server api:3000;
    }

    # HTTP server
    server {
        listen 80;
        server_name localhost;

        # Página de bienvenida
        location = / {
            return 200 'Sistema de Gestión FCT - Desarrollo Local\nAPI disponible en /api\nHealth check en /health';
            add_header Content-Type text/plain;
        }

        # API endpoints
        location /api/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 300s;
            proxy_connect_timeout 75s;
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

    log_success "Configuraciones de Nginx generadas"
}

# Función para verificar prerrequisitos
check_prerequisites() {
    log_step "Verificando prerrequisitos..."
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado"
        log_info "Instala Docker desde: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose no está instalado"
        log_info "Instala Docker Compose desde: https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    # Verificar que Docker esté corriendo
    if ! docker info &> /dev/null; then
        log_error "Docker no está corriendo"
        log_info "Inicia Docker Desktop o el servicio de Docker"
        exit 1
    fi
    
    log_success "Prerrequisitos verificados"
}

# Función para construir y levantar servicios
build_and_start() {
    local compose_file=$1
    
    log_step "Construyendo y levantando servicios..."
    
    docker-compose -f "$compose_file" build --no-cache
    docker-compose -f "$compose_file" up -d
    
    log_success "Servicios iniciados"
    
    # Esperar a que los servicios estén listos
    log_info "Esperando a que los servicios estén listos..."
    sleep 15
    
    # Verificar estado
    log_info "Estado de los servicios:"
    docker-compose -f "$compose_file" ps
}

# Función para crear scripts de gestión
create_management_scripts() {
    local compose_file=$1
    local project_name=$2
    
    log_step "Creando scripts de gestión..."
    
    # Script de inicio
    cat > "start-$project_name.sh" << EOF
#!/bin/bash
echo "🚀 Iniciando $project_name..."
docker-compose -f $compose_file up -d
echo "✅ Servicios iniciados"
docker-compose -f $compose_file ps
EOF
    
    # Script de parada
    cat > "stop-$project_name.sh" << EOF
#!/bin/bash
echo "🛑 Deteniendo $project_name..."
docker-compose -f $compose_file down
echo "✅ Servicios detenidos"
EOF
    
    # Script de logs
    cat > "logs-$project_name.sh" << EOF
#!/bin/bash
echo "📋 Mostrando logs de $project_name..."
docker-compose -f $compose_file logs -f
EOF
    
    # Script de estado
    cat > "status-$project_name.sh" << EOF
#!/bin/bash
echo "📊 Estado de $project_name..."
docker-compose -f $compose_file ps
echo ""
echo "📈 Uso de recursos:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
EOF
    
    # Hacer ejecutables
    chmod +x "start-$project_name.sh"
    chmod +x "stop-$project_name.sh"
    chmod +x "logs-$project_name.sh"
    chmod +x "status-$project_name.sh"
    
    log_success "Scripts de gestión creados"
}

# Función para mostrar información final
show_final_info() {
    local compose_file=$1
    local env_file=$2
    
    echo ""
    echo "🎉 ¡Despliegue configurado exitosamente!"
    echo ""
    echo "📋 Información del despliegue:"
    echo "   📁 Archivo compose: $compose_file"
    echo "   🔧 Variables de entorno: $env_file"
    echo "   🐳 Tipo de instalación: $INSTALLATION_TYPE"
    echo ""
    
    case $INSTALLATION_TYPE in
        "local")
            echo "🌐 URLs disponibles:"
            echo "   - API: http://localhost:3000/api"
            echo "   - Health: http://localhost:3000/health"
            echo ""
            echo "📝 Comandos útiles:"
            echo "   Iniciar: ./start-fct-local.sh"
            echo "   Detener: ./stop-fct-local.sh"
            echo "   Logs: ./logs-fct-local.sh"
            echo "   Estado: ./status-fct-local.sh"
            ;;
        "centro-educativo")
            echo "🌐 URLs disponibles:"
            echo "   - API: http://localhost/api"
            echo "   - Health: http://localhost/health"
            echo "   - Status: http://localhost/status"
            echo ""
            echo "📝 Comandos útiles:"
            echo "   Iniciar: ./start-fct-centro.sh"
            echo "   Detener: ./stop-fct-centro.sh"
            echo "   Logs: ./logs-fct-centro.sh"
            echo "   Estado: ./status-fct-centro.sh"
            ;;
        "cloudflare")
            echo "🌐 URLs disponibles:"
            echo "   - API: http://localhost:8080/api"
            echo "   - Health: http://localhost:8080/health"
            echo ""
            echo "📝 Comandos útiles:"
            echo "   Iniciar: ./start-fct-cloudflare.sh"
            echo "   Detener: ./stop-fct-cloudflare.sh"
            echo "   Logs: ./logs-fct-cloudflare.sh"
            echo "   Estado: ./status-fct-cloudflare.sh"
            ;;
        "vps")
            echo "🌐 URLs disponibles:"
            echo "   - API: https://$DOMAIN/api"
            echo "   - Health: https://$DOMAIN/health"
            echo ""
            echo "📝 Comandos útiles:"
            echo "   Iniciar: ./start-fct-vps.sh"
            echo "   Detener: ./stop-fct-vps.sh"
            echo "   Logs: ./logs-fct-vps.sh"
            echo "   Estado: ./status-fct-vps.sh"
            ;;
        "generic")
            echo "🌐 URLs disponibles:"
            echo "   - API: http://localhost:3000/api"
            echo "   - Health: http://localhost:3000/health"
            echo ""
            echo "📝 Comandos útiles:"
            echo "   Iniciar: docker-compose -f $compose_file up -d"
            echo "   Detener: docker-compose -f $compose_file down"
            echo "   Logs: docker-compose -f $compose_file logs -f"
            echo "   Estado: docker-compose -f $compose_file ps"
            ;;
    esac
    
    echo ""
    log_warning "⚠️ Recuerda editar $env_file con tus configuraciones específicas"
    echo "   - Google OAuth credentials"
    echo "   - Email configuration"
    echo "   - Frontend URL"
    echo ""
}

# Función principal
main() {
    show_banner
    show_installation_types
    select_installation_type
    get_additional_info
    
    # Verificar prerrequisitos
    check_prerequisites
    
    # Crear archivo .env según el tipo
    case $INSTALLATION_TYPE in
        "local")
            create_env_file ".env" "fct_local" "development" "*" "1000"
            generate_local_compose
            COMPOSE_FILE="docker-compose.yml"
            ENV_FILE=".env"
            PROJECT_NAME="fct-local"
            ;;
        "centro-educativo")
            create_env_file ".env" "fct_centro" "production" "*" "100"
            generate_centro_compose
            generate_nginx_configs
            COMPOSE_FILE="docker-compose.centro.yml"
            ENV_FILE=".env"
            PROJECT_NAME="fct-centro"
            ;;
        "cloudflare")
            create_env_file ".env" "fct_local" "production" "*" "100"
            generate_cloudflare_compose
            generate_nginx_configs
            COMPOSE_FILE="docker-compose.cloudflare.yml"
            ENV_FILE=".env"
            PROJECT_NAME="fct-cloudflare"
            ;;
        "vps")
            create_env_file ".env" "fct_production" "production" "https://$DOMAIN" "100"
            generate_vps_compose
            COMPOSE_FILE="docker-compose.vps.yml"
            ENV_FILE=".env"
            PROJECT_NAME="fct-vps"
            ;;
        "generic")
            create_env_file "$ENV_FILE" "fct_${ENVIRONMENT:-local}" "${ENVIRONMENT:-local}" "*" "500"
            # Para genérico, usar el archivo existente o crear uno básico
            if [ ! -f "$COMPOSE_FILE" ]; then
                generate_local_compose
            fi
            PROJECT_NAME="fct-generic"
            ;;
    esac
    
    # Crear scripts de gestión
    create_management_scripts "$COMPOSE_FILE" "$PROJECT_NAME"
    
    # Preguntar si quiere construir y levantar ahora
    log_question "¿Quieres construir y levantar los servicios ahora? (y/N):"
    read -r -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        build_and_start "$COMPOSE_FILE"
    fi
    
    # Mostrar información final
    show_final_info "$COMPOSE_FILE" "$ENV_FILE"
}

# Ejecutar función principal
main "$@" 