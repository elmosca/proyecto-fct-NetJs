#!/bin/bash

# ========================================
# SCRIPT DE INSTALACIÓN UNIFICADO
# Proyecto FCT - Backend (NestJS) + Frontend (Flutter)
# ========================================
# 
# Este script instala y configura todos los requisitos necesarios
# para el desarrollo completo del proyecto FCT.
#
# Uso: ./install.sh [opciones]
# Opciones:
#   --backend-only    Solo instalar backend
#   --frontend-only   Solo instalar frontend
#   --skip-deps       Saltar instalación de dependencias del sistema
#   --help            Mostrar esta ayuda

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables de configuración
BACKEND_ONLY=false
FRONTEND_ONLY=false
SKIP_DEPS=false

# Función para imprimir mensajes
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Función para mostrar ayuda
show_help() {
    echo "Script de Instalación Unificado - Proyecto FCT"
    echo ""
    echo "Uso: ./install.sh [opciones]"
    echo ""
    echo "Opciones:"
    echo "  --backend-only    Solo instalar backend"
    echo "  --frontend-only   Solo instalar frontend"
    echo "  --skip-deps       Saltar instalación de dependencias del sistema"
    echo "  --help            Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./install.sh                    # Instalación completa"
    echo "  ./install.sh --backend-only     # Solo backend"
    echo "  ./install.sh --frontend-only    # Solo frontend"
    echo "  ./install.sh --skip-deps        # Saltar dependencias del sistema"
}

# Función para procesar argumentos
process_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --backend-only)
                BACKEND_ONLY=true
                shift
                ;;
            --frontend-only)
                FRONTEND_ONLY=true
                shift
                ;;
            --skip-deps)
                SKIP_DEPS=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Función para verificar sistema operativo
check_os() {
    print_section "VERIFICANDO SISTEMA OPERATIVO"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_status "Sistema: Linux detectado"
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_status "Sistema: macOS detectado"
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        print_status "Sistema: Windows detectado"
        OS="windows"
    else
        print_error "Sistema operativo no soportado: $OSTYPE"
        exit 1
    fi
}

# Función para instalar dependencias del sistema
install_system_dependencies() {
    if [ "$SKIP_DEPS" = true ]; then
        print_warning "Saltando instalación de dependencias del sistema"
        return
    fi
    
    print_section "INSTALANDO DEPENDENCIAS DEL SISTEMA"
    
    if [ "$OS" = "linux" ]; then
        print_status "Instalando dependencias en Linux..."
        
        # Actualizar repositorios
        sudo apt-get update
        
        # Instalar curl, git, wget
        sudo apt-get install -y curl git wget unzip
        
        # Instalar Node.js 20.x
        if ! command -v node &> /dev/null; then
            print_status "Instalando Node.js 20.x..."
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        else
            print_status "Node.js ya está instalado: $(node --version)"
        fi
        
        # Instalar Docker
        if ! command -v docker &> /dev/null; then
            print_status "Instalando Docker..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $USER
            rm get-docker.sh
        else
            print_status "Docker ya está instalado: $(docker --version)"
        fi
        
        # Instalar Docker Compose
        if ! command -v docker-compose &> /dev/null; then
            print_status "Instalando Docker Compose..."
            sudo apt-get install -y docker-compose
        else
            print_status "Docker Compose ya está instalado: $(docker-compose --version)"
        fi
        
        # Instalar Flutter (solo si no está instalado)
        if ! command -v flutter &> /dev/null; then
            print_warning "Flutter no está instalado. Instálalo manualmente desde:"
            print_warning "https://flutter.dev/docs/get-started/install"
        else
            print_status "Flutter ya está instalado: $(flutter --version | head -1)"
        fi
        
    elif [ "$OS" = "macos" ]; then
        print_status "Instalando dependencias en macOS..."
        
        # Verificar si Homebrew está instalado
        if ! command -v brew &> /dev/null; then
            print_status "Instalando Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        # Instalar dependencias
        brew install node@20 git curl wget
        
        # Instalar Docker Desktop
        if ! command -v docker &> /dev/null; then
            print_warning "Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop"
        fi
        
        # Instalar Flutter
        if ! command -v flutter &> /dev/null; then
            print_warning "Instala Flutter desde: https://flutter.dev/docs/get-started/install/macos"
        fi
        
    elif [ "$OS" = "windows" ]; then
        print_status "Instalando dependencias en Windows..."
        print_warning "Para Windows, instala manualmente:"
        print_warning "- Node.js: https://nodejs.org/"
        print_warning "- Docker Desktop: https://www.docker.com/products/docker-desktop"
        print_warning "- Flutter: https://flutter.dev/docs/get-started/install/windows"
        print_warning "- Git: https://git-scm.com/download/win"
    fi
}

# Función para verificar requisitos
check_requirements() {
    print_section "VERIFICANDO REQUISITOS"
    
    local missing_deps=()
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        missing_deps+=("Node.js")
    else
        NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -lt 18 ]; then
            print_error "Node.js versión 18+ requerida. Actual: $(node --version)"
            missing_deps+=("Node.js 18+")
        else
            print_status "✅ Node.js: $(node --version)"
        fi
    fi
    
    # Verificar npm
    if ! command -v npm &> /dev/null; then
        missing_deps+=("npm")
    else
        print_status "✅ npm: $(npm --version)"
    fi
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        missing_deps+=("Docker")
    else
        print_status "✅ Docker: $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
    fi
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        missing_deps+=("Docker Compose")
    else
        print_status "✅ Docker Compose: $(docker-compose --version | cut -d' ' -f3 | cut -d',' -f1)"
    fi
    
    # Verificar Flutter (solo si se va a instalar frontend)
    if [ "$BACKEND_ONLY" = false ]; then
        if ! command -v flutter &> /dev/null; then
            missing_deps+=("Flutter")
        else
            print_status "✅ Flutter: $(flutter --version | head -1 | cut -d' ' -f2)"
        fi
    fi
    
    # Mostrar dependencias faltantes
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Dependencias faltantes:"
        for dep in "${missing_deps[@]}"; do
            print_error "  - $dep"
        done
        print_warning "Ejecuta: ./install.sh --skip-deps"
        exit 1
    fi
    
    print_status "✅ Todos los requisitos están instalados"
}

# Función para configurar backend
setup_backend() {
    if [ "$FRONTEND_ONLY" = true ]; then
        return
    fi
    
    print_section "CONFIGURANDO BACKEND"
    
    cd backend
    
    # Instalar dependencias de Node.js
    print_status "Instalando dependencias del backend..."
    npm install
    
    # Configurar variables de entorno
    if [ ! -f .env ]; then
        print_status "Configurando variables de entorno..."
        if [ -f .env.example ]; then
            cp .env.example .env
            print_status "✅ Archivo .env creado desde .env.example"
        else
            print_error "❌ No se encontró .env.example"
            exit 1
        fi
    else
        print_status "✅ Archivo .env ya existe"
    fi
    
    # Verificar configuración
    if [ -f scripts/verify-env.js ]; then
        print_status "Verificando configuración..."
        node scripts/verify-env.js
    fi
    
    # Iniciar base de datos
    print_status "Iniciando base de datos con Docker..."
    docker-compose up -d postgres
    
    # Esperar a que la DB esté lista
    print_status "Esperando a que la base de datos esté lista..."
    until docker-compose exec -T postgres pg_isready -h localhost -p 5432 -U postgres; do
        printf '.'
        sleep 2
    done
    echo ""
    
    # Ejecutar migraciones
    print_status "Ejecutando migraciones..."
    npm run migration:run || print_warning "Migraciones fallaron o no configuradas"
    
    # Ejecutar seeds
    print_status "Ejecutando seeds..."
    npm run db:seed || print_warning "Seeds fallaron o no configurados"
    
    # Iniciar API
    print_status "Iniciando API..."
    docker-compose up -d api
    
    cd ..
    
    print_status "✅ Backend configurado y ejecutándose"
}

# Función para configurar frontend
setup_frontend() {
    if [ "$BACKEND_ONLY" = true ]; then
        return
    fi
    
    print_section "CONFIGURANDO FRONTEND"
    
    cd frontend
    
    # Verificar Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "❌ Flutter no está instalado"
        print_warning "Instala Flutter desde: https://flutter.dev/docs/get-started/install"
        cd ..
        return
    fi
    
    # Instalar dependencias de Flutter
    print_status "Instalando dependencias de Flutter..."
    flutter pub get
    
    # Generar código
    print_status "Generando código con build_runner..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    # Verificar configuración
    print_status "Verificando configuración de Flutter..."
    flutter doctor
    
    cd ..
    
    print_status "✅ Frontend configurado"
}

# Función para ejecutar tests
run_tests() {
    print_section "EJECUTANDO TESTS"
    
    # Tests del backend
    if [ "$FRONTEND_ONLY" = false ]; then
        print_status "Ejecutando tests del backend..."
        cd backend
        npm test || print_warning "Algunos tests del backend fallaron"
        cd ..
    fi
    
    # Tests del frontend
    if [ "$BACKEND_ONLY" = false ]; then
        print_status "Ejecutando tests del frontend..."
        cd frontend
        flutter test || print_warning "Algunos tests del frontend fallaron"
        cd ..
    fi
}

# Función para mostrar información final
show_final_info() {
    print_section "INSTALACIÓN COMPLETADA"
    
    echo ""
    echo "🎉 ¡Proyecto FCT configurado exitosamente!"
    echo ""
    
    if [ "$FRONTEND_ONLY" = false ]; then
        echo "📋 Backend (NestJS):"
        echo "   ✅ API: http://localhost:3000/api"
        echo "   ✅ Base de datos: PostgreSQL (Docker)"
        echo "   ✅ Contenedores: backend_api_1, backend_postgres_1"
        echo ""
    fi
    
    if [ "$BACKEND_ONLY" = false ]; then
        echo "📱 Frontend (Flutter):"
        echo "   ✅ Dependencias instaladas"
        echo "   ✅ Código generado"
        echo ""
    fi
    
    echo "🚀 Comandos útiles:"
    echo ""
    echo "   # Verificar estado de contenedores"
    echo "   docker ps"
    echo ""
    echo "   # Ver logs del backend"
    echo "   docker-compose logs -f api"
    echo ""
    echo "   # Ejecutar frontend"
    echo "   cd frontend && flutter run"
    echo ""
    echo "   # Ejecutar backend en desarrollo"
    echo "   cd backend && npm run start:dev"
    echo ""
    echo "📖 Documentación:"
    echo "   - README.md: Información general del proyecto"
    echo "   - DEPLOYMENT.md: Guía de despliegue completo"
    echo "   - CONTRIBUTING.md: Cómo contribuir al proyecto"
    echo ""
}

# Función principal
main() {
    echo -e "${BLUE}"
    echo "============================================================"
    echo "  SCRIPT DE INSTALACIÓN UNIFICADO - PROYECTO FCT"
    echo "============================================================"
    echo -e "${NC}"
    
    # Procesar argumentos
    process_args "$@"
    
    # Verificar sistema operativo
    check_os
    
    # Instalar dependencias del sistema
    install_system_dependencies
    
    # Verificar requisitos
    check_requirements
    
    # Configurar backend
    setup_backend
    
    # Configurar frontend
    setup_frontend
    
    # Ejecutar tests
    run_tests
    
    # Mostrar información final
    show_final_info
}

# Ejecutar función principal
main "$@" 