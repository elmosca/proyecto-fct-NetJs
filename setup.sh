#!/bin/bash

# Script de inicialización rápida para el proyecto FCT
# Uso: ./setup.sh

set -e

echo "🚀 Configurando proyecto FCT..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Verificar requisitos previos
check_requirements() {
    print_status "Verificando requisitos previos..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js no está instalado. Instala Node.js 18+ desde https://nodejs.org"
        exit 1
    fi
    
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter no está instalado. Instala Flutter desde https://flutter.dev"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Instala Docker desde https://docker.com"
        exit 1
    fi
    
    print_status "✅ Todos los requisitos están instalados"
}

# Configurar backend
setup_backend() {
    print_status "Configurando backend..."
    
    cd backend
    
    # Instalar dependencias
    print_status "Instalando dependencias del backend..."
    npm install
    
    # Configurar variables de entorno
    if [ ! -f .env ]; then
        print_status "Creando archivo .env..."
        cat > .env << EOF
# Configuración de la Base de Datos
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=fct_backend_db

# Configuración JWT
JWT_SECRET=your-super-secret-key-change-in-production
JWT_EXPIRATION=1h

# Configuración del Servidor
PORT=3000
NODE_ENV=development

# Configuración de CORS
CORS_ORIGIN=http://localhost:3000,http://localhost:8080
EOF
        print_status "✅ Archivo .env creado con configuración por defecto"
    fi

    # Iniciar base de datos
    print_status "Iniciando base de datos con Docker..."
    docker-compose up -d

    # Esperar a que la DB esté lista
    print_status "Esperando a que la base de datos esté lista..."
    # Esperar hasta que el contenedor de postgres esté saludable y accesible
    until docker-compose exec -T postgres pg_isready -h localhost -p 5432 -U postgres; do
      printf '.'
      sleep 2
    done
    echo "" # Nueva línea después de los puntos de espera

    # Ejecutar migraciones y seeds
    print_status "Ejecutando migraciones..."
    npm run migration:run || print_warning "Migraciones fallaron o no configuradas"

    print_status "Ejecutando seeds..."
    npm run db:seed || print_warning "Seeds fallaron o no configurados"

    cd ..
}

# Configurar frontend
setup_frontend() {
    print_status "Configurando frontend..."
    
    cd frontend
    
    # Instalar dependencias
    print_status "Instalando dependencias de Flutter..."
    flutter pub get
    
    # Generar código
    print_status "Generando código con build_runner..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    cd ..
}

# Ejecutar tests
run_tests() {
    print_status "Ejecutando tests..."
    
    # Tests del backend
    print_status "Ejecutando tests del backend..."
    cd backend
    npm test || print_warning "Algunos tests del backend fallaron"
    cd ..
    
    # Tests del frontend
    print_status "Ejecutando tests del frontend..."
    cd frontend
    flutter test || print_warning "Algunos tests del frontend fallaron"
    cd ..
}

# Mostrar información final
show_final_info() {
    print_status "🎉 Configuración completada!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Abre el proyecto en VS Code"
    echo "2. Instala las extensiones recomendadas"
    echo "3. Edita backend/.env con tus configuraciones"
    echo ""
    echo "🚀 Para iniciar el desarrollo:"
    echo "Backend:  cd backend && npm run start:dev"
    echo "Frontend: cd frontend && flutter run"
    echo ""
    echo "📖 Para más información, lee CONTRIBUTING.md"
}

# Función principal
main() {
    check_requirements
    setup_backend
    setup_frontend
    run_tests
    show_final_info
}

# Ejecutar función principal
main "$@"
