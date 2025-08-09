#!/bin/bash
# Script de redespliegue en WSL
# Uso: ./scripts/redeploy.sh [backend|frontend|all]

set -e  # Salir si hay algún error

SERVICE=${1:-"all"}
PROJECT_PATH="/home/jualas/proyectos/proyecto-fct-NetJs"

echo "🚀 Iniciando redespliegue de servicios..."
echo "📁 Proyecto: $PROJECT_PATH"
echo "🔧 Servicio: $SERVICE"
echo ""

# Verificar que Docker esté disponible
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker no está instalado o no está en PATH"
    exit 1
fi

# Verificar que docker compose esté disponible
if ! command -v docker compose &> /dev/null; then
    echo "❌ Error: Docker Compose no está disponible"
    exit 1
fi

# Función para redesplegar un servicio
redeploy_service() {
    local service_name=$1
    local service_path="$PROJECT_PATH/$service_name"
    
    echo "📦 Redesplegando $service_name..."
    
    if [ ! -d "$service_path" ]; then
        echo "❌ Error: Directorio $service_path no existe"
        return 1
    fi
    
    cd "$service_path"
    
    # Verificar que existe docker-compose.yml
    if [ ! -f "docker-compose.yml" ]; then
        echo "❌ Error: docker-compose.yml no encontrado en $service_path"
        return 1
    fi
    
      echo "🛑 Deteniendo servicios..."
  docker-compose down --remove-orphans
    
      echo "🔨 Construyendo imagen..."
  docker-compose build --no-cache
    
      echo "🚀 Iniciando servicios..."
  docker-compose up -d
    
    echo "⏳ Esperando que los servicios estén listos..."
    sleep 10
    
    # Verificar health check
    if [ "$service_name" = "backend" ]; then
        echo "🏥 Verificando health check..."
        for i in {1..6}; do
            if curl -f http://localhost:3000/api/health >/dev/null 2>&1; then
                echo "✅ Backend saludable en http://localhost:3000/api/health"
                break
            else
                echo "⏳ Intento $i/6: Esperando que backend esté listo..."
                sleep 5
            fi
        done
    fi
    
    echo "✅ $service_name redesplegado correctamente"
    echo ""
}

# Redesplegar servicios según parámetro
if [ "$SERVICE" = "all" ] || [ "$SERVICE" = "backend" ]; then
    redeploy_service "backend"
fi

if [ "$SERVICE" = "all" ] || [ "$SERVICE" = "frontend" ]; then
    redeploy_service "frontend"
fi

echo "🎉 Redespliegue completado exitosamente!"
echo ""
echo "📊 Verificar en Portainer: http://localhost:9000"
echo "🔍 Ver logs: docker compose logs -f"
echo "🏥 Health check: curl http://localhost:3000/api/health"

