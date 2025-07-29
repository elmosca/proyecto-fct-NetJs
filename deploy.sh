#!/bin/bash

# =================================================
# Script de Despliegue - Backend API TFG
# =================================================
# Uso: ./deploy.sh [environment] [action]
# Environments: local, staging, production
# Actions: build, start, stop, restart, logs, status

set -e  # Exit on any error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
ENVIRONMENT=${1:-local}
ACTION=${2:-start}
PROJECT_NAME="tfg-backend"
COMPOSE_FILE=""

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

# Función para mostrar ayuda
show_help() {
    echo "=================================================="
    echo "🚀 Script de Despliegue - Backend API TFG"
    echo "=================================================="
    echo ""
    echo "Uso: ./deploy.sh [environment] [action]"
    echo ""
    echo "Environments:"
    echo "  local      - Desarrollo local (default)"
    echo "  staging    - Entorno de pruebas"
    echo "  production - Producción"
    echo ""
    echo "Actions:"
    echo "  build      - Construir imágenes Docker"
    echo "  start      - Iniciar servicios (default)"
    echo "  stop       - Detener servicios"
    echo "  restart    - Reiniciar servicios"
    echo "  logs       - Mostrar logs en tiempo real"
    echo "  status     - Mostrar estado de servicios"
    echo "  health     - Verificar health de la API"
    echo "  backup     - Crear backup de base de datos"
    echo "  cleanup    - Limpiar recursos no utilizados"
    echo ""
    echo "Ejemplos:"
    echo "  ./deploy.sh local start"
    echo "  ./deploy.sh production build"
    echo "  ./deploy.sh staging logs"
    echo ""
}

# Configurar archivo compose según entorno
configure_environment() {
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
            log_error "Entorno desconocido: $ENVIRONMENT"
            show_help
            exit 1
            ;;
    esac

    # Verificar que existan los archivos necesarios
    if [ ! -f "$COMPOSE_FILE" ]; then
        log_error "Archivo compose no encontrado: $COMPOSE_FILE"
        exit 1
    fi

    if [ ! -f "$ENV_FILE" ]; then
        log_warning "Archivo de entorno no encontrado: $ENV_FILE"
        log_info "Creando archivo de ejemplo..."
        cp .env.example "$ENV_FILE"
        log_warning "Por favor, edita $ENV_FILE con tus configuraciones"
    fi

    log_info "Entorno: $ENVIRONMENT"
    log_info "Compose file: $COMPOSE_FILE"
    log_info "Env file: $ENV_FILE"
}

# Verificar prerrequisitos
check_prerequisites() {
    log_info "Verificando prerrequisitos..."

    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado"
        exit 1
    fi

    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose no está instalado"
        exit 1
    fi

    # Verificar que Docker esté corriendo
    if ! docker info &> /dev/null; then
        log_error "Docker no está corriendo"
        exit 1
    fi

    log_success "Prerrequisitos verificados"
}

# Función para construir imágenes
build_images() {
    log_info "Construyendo imágenes Docker..."
    
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" build --no-cache
    
    log_success "Imágenes construidas exitosamente"
}

# Función para iniciar servicios
start_services() {
    log_info "Iniciando servicios..."
    
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d
    
    log_success "Servicios iniciados"
    
    # Esperar a que la API esté lista
    log_info "Esperando a que la API esté disponible..."
    sleep 10
    
    check_health
}

# Función para detener servicios
stop_services() {
    log_info "Deteniendo servicios..."
    
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" down
    
    log_success "Servicios detenidos"
}

# Función para reiniciar servicios
restart_services() {
    log_info "Reiniciando servicios..."
    
    stop_services
    sleep 5
    start_services
}

# Función para mostrar logs
show_logs() {
    log_info "Mostrando logs en tiempo real (Ctrl+C para salir)..."
    
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" logs -f
}

# Función para mostrar estado
show_status() {
    log_info "Estado de los servicios:"
    
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps
    
    echo ""
    log_info "Uso de recursos:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# Función para verificar health
check_health() {
    log_info "Verificando estado de salud de la API..."
    
    # Obtener puerto de la API
    API_PORT=$(grep "API_PORT" "$ENV_FILE" | cut -d '=' -f2 | tr -d '"' | tr -d ' ')
    API_PORT=${API_PORT:-3000}
    
    # Verificar health endpoint
    if curl -f -s "http://localhost:$API_PORT/api/auth/me" > /dev/null; then
        log_success "API está respondiendo correctamente en puerto $API_PORT"
    else
        log_warning "API no está respondiendo o no tiene endpoint de health"
        log_info "Verificando que el puerto esté abierto..."
        
        if nc -z localhost "$API_PORT" 2>/dev/null; then
            log_success "Puerto $API_PORT está abierto"
        else
            log_error "Puerto $API_PORT no está disponible"
            return 1
        fi
    fi
    
    # Verificar estado de contenedores
    log_info "Estado de contenedores:"
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps
}

# Función para backup
create_backup() {
    log_info "Creando backup de base de datos..."
    
    BACKUP_DIR="./backups"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/tfg_backup_$TIMESTAMP.sql"
    
    # Crear directorio de backups si no existe
    mkdir -p "$BACKUP_DIR"
    
    # Obtener configuración de BD del archivo env
    DB_USER=$(grep "DB_USERNAME" "$ENV_FILE" | cut -d '=' -f2 | tr -d '"' | tr -d ' ')
    DB_NAME=$(grep "DB_DATABASE" "$ENV_FILE" | cut -d '=' -f2 | tr -d '"' | tr -d ' ')
    
    # Crear backup
    docker-compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" exec -T postgres pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        log_success "Backup creado: $BACKUP_FILE"
        
        # Comprimir backup
        gzip "$BACKUP_FILE"
        log_success "Backup comprimido: $BACKUP_FILE.gz"
    else
        log_error "Error al crear backup"
        return 1
    fi
}

# Función para limpiar recursos
cleanup_resources() {
    log_info "Limpiando recursos no utilizados..."
    
    # Limpiar contenedores detenidos
    docker container prune -f
    
    # Limpiar imágenes no utilizadas
    docker image prune -f
    
    # Limpiar volúmenes no utilizados
    docker volume prune -f
    
    # Limpiar redes no utilizadas
    docker network prune -f
    
    log_success "Recursos limpiados"
}

# Función principal
main() {
    # Mostrar banner
    echo "=================================================="
    echo "🚀 TFG Backend API - Deploy Script"
    echo "=================================================="
    echo ""

    # Verificar si se pidió ayuda
    if [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_help
        exit 0
    fi

    # Configurar entorno
    configure_environment
    
    # Verificar prerrequisitos
    check_prerequisites
    
    # Ejecutar acción
    case $ACTION in
        "build")
            build_images
            ;;
        "start")
            start_services
            ;;
        "stop")
            stop_services
            ;;
        "restart")
            restart_services
            ;;
        "logs")
            show_logs
            ;;
        "status")
            show_status
            ;;
        "health")
            check_health
            ;;
        "backup")
            create_backup
            ;;
        "cleanup")
            cleanup_resources
            ;;
        *)
            log_error "Acción desconocida: $ACTION"
            show_help
            exit 1
            ;;
    esac

    echo ""
    log_success "¡Script completado exitosamente!"
}

# Ejecutar función principal con todos los argumentos
main "$@"
