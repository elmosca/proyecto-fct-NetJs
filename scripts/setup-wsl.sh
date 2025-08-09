#!/bin/bash
# Script de configuración inicial para WSL
# Uso: ./scripts/setup-wsl.sh

set -e

echo "🔧 Configurando entorno WSL para proyecto-fct-NetJs..."
echo ""

# Verificar que estamos en WSL
if [[ ! -f /proc/version ]] || ! grep -q Microsoft /proc/version; then
    echo "❌ Error: Este script debe ejecutarse en WSL"
    exit 1
fi

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt update
sudo apt upgrade -y

# Instalar dependencias necesarias
echo "🔧 Instalando dependencias..."
sudo apt install -y \
    curl \
    wget \
    rsync \
    git \
    unzip \
    jq

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker no encontrado. Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✅ Docker instalado. Reinicia WSL para aplicar cambios de grupo."
else
    echo "✅ Docker ya está instalado"
fi

# Verificar Docker Compose
if ! command -v docker compose &> /dev/null; then
    echo "🐳 Docker Compose no encontrado. Instalando..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose instalado"
else
    echo "✅ Docker Compose ya está instalado"
fi

# Crear directorio del proyecto
echo "📁 Configurando directorio del proyecto..."
sudo mkdir -p /opt
sudo chown $USER:$USER /opt

if [ ! -d "/opt/proyecto-fct-NetJs" ]; then
    echo "📥 Clonando repositorio en /opt/proyecto-fct-NetJs..."
    cd /opt
    git clone https://github.com/tu-usuario/proyecto-fct-NetJs.git
else
    echo "✅ Directorio del proyecto ya existe"
fi

# Configurar scripts
echo "🔧 Configurando scripts..."
cd /opt/proyecto-fct-NetJs
chmod +x scripts/*.sh

# Crear red Docker si no existe
echo "🌐 Configurando red Docker..."
if ! docker network ls | grep -q proxy-net; then
    docker network create proxy-net
    echo "✅ Red proxy-net creada"
else
    echo "✅ Red proxy-net ya existe"
fi

# Configurar variables de entorno
echo "⚙️  Configurando variables de entorno..."
if [ ! -f "/opt/proyecto-fct-NetJs/.env" ]; then
    echo "📝 Creando archivo .env de ejemplo..."
    cat > /opt/proyecto-fct-NetJs/.env << EOF
# Configuración del proyecto
NODE_ENV=production
PORT=3000

# Base de datos
DB_HOST=postgres
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=nestjs

# JWT
JWT_SECRET=tu-jwt-secret-aqui
JWT_EXPIRATION=1h

# Google OAuth (si aplica)
GOOGLE_CLIENT_ID=tu-google-client-id
GOOGLE_CLIENT_SECRET=tu-google-client-secret
GOOGLE_CALLBACK_URL=http://localhost:3000/api/auth/google/callback
EOF
    echo "✅ Archivo .env creado. Ajusta las variables según tu configuración."
else
    echo "✅ Archivo .env ya existe"
fi

echo ""
echo "🎉 Configuración completada exitosamente!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Reinicia WSL: wsl --shutdown (desde Windows)"
echo "2. Ajusta las variables en /opt/proyecto-fct-NetJs/.env"
echo "3. Desde Windows, ejecuta: .\scripts\quick-deploy.ps1 backend"
echo ""
echo "📊 Verificar en Portainer: http://localhost:9000"

