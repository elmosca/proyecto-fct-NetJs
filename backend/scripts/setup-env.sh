#!/bin/bash

# Script de configuración rápida de variables de entorno
# Backend FCT - Proyecto de Microservicios
#
# Uso: ./scripts/setup-env.sh

set -e

# Colores para la consola
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Función para imprimir título
print_title() {
    echo ""
    echo "============================================================"
    print_color $BLUE "  $1"
    echo "============================================================"
}

# Función para imprimir sección
print_section() {
    echo ""
    echo "----------------------------------------"
    print_color $CYAN "  $1"
    echo "----------------------------------------"
}

# Función para generar contraseña segura
generate_password() {
    openssl rand -base64 16 | tr -d "=+/" | cut -c1-16
}

# Función para generar JWT secret
generate_jwt_secret() {
    openssl rand -base64 32 | tr -d "=+/"
}

# Función para validar email
validate_email() {
    local email=$1
    if [[ $email =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Función para validar URL
validate_url() {
    local url=$1
    if [[ $url =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

# Función principal
main() {
    print_title "CONFIGURACIÓN DE VARIABLES DE ENTORNO - BACKEND FCT"
    
    # Verificar si estamos en el directorio correcto
    if [ ! -f "package.json" ] || [ ! -f "docker-compose.yml" ]; then
        print_color $RED "❌ Error: Este script debe ejecutarse desde el directorio backend/"
        exit 1
    fi
    
    # Verificar si ya existe .env
    if [ -f ".env" ]; then
        print_color $YELLOW "⚠️  El archivo .env ya existe"
        read -p "¿Deseas sobrescribirlo? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_color $BLUE "Operación cancelada"
            exit 0
        fi
    fi
    
    # Crear .env desde .env.example si existe
    if [ -f ".env.example" ]; then
        print_section "CREANDO ARCHIVO .env"
        cp .env.example .env
        print_color $GREEN "✅ Archivo .env creado desde .env.example"
    else
        print_color $RED "❌ Error: No se encontró .env.example"
        exit 1
    fi
    
    print_section "CONFIGURACIÓN DE BASE DE DATOS"
    
    # Generar contraseña segura para BD
    DB_PASSWORD=$(generate_password)
    print_color $GREEN "🔐 Contraseña de BD generada: $DB_PASSWORD"
    
    # Solicitar nombre de BD
    read -p "Nombre de la base de datos (default: fct_backend_db): " DB_DATABASE
    DB_DATABASE=${DB_DATABASE:-fct_backend_db}
    
    print_section "CONFIGURACIÓN DE JWT"
    
    # Generar JWT secret
    JWT_SECRET=$(generate_jwt_secret)
    print_color $GREEN "🔑 JWT Secret generado (32+ caracteres)"
    
    print_section "CONFIGURACIÓN DE GOOGLE OAUTH"
    
    print_color $YELLOW "⚠️  Para Google OAuth necesitas configurar un proyecto en Google Cloud Console"
    print_color $BLUE "📖 Guía: https://developers.google.com/identity/protocols/oauth2"
    
    read -p "Google Client ID (dejar vacío para configurar después): " GOOGLE_CLIENT_ID
    read -p "Google Client Secret (dejar vacío para configurar después): " GOOGLE_CLIENT_SECRET
    
    print_section "CONFIGURACIÓN DE EMAIL"
    
    # Solicitar email
    while true; do
        read -p "Email para envío de notificaciones: " MAIL_USER
        if validate_email "$MAIL_USER"; then
            break
        else
            print_color $RED "❌ Email inválido. Intenta de nuevo."
        fi
    done
    
    print_color $YELLOW "⚠️  Para Gmail necesitas generar una App Password"
    print_color $BLUE "📖 Guía: https://support.google.com/accounts/answer/185833"
    read -p "App Password de Gmail (dejar vacío para configurar después): " MAIL_PASS
    
    print_section "CONFIGURACIÓN DE FRONTEND"
    
    # Solicitar URL del frontend
    while true; do
        read -p "URL del frontend (ej: https://tu-dominio.com): " FRONTEND_URL
        if [ -z "$FRONTEND_URL" ] || validate_url "$FRONTEND_URL"; then
            break
        else
            print_color $RED "❌ URL inválida. Debe comenzar con http:// o https://"
        fi
    done
    
    print_section "ACTUALIZANDO ARCHIVO .env"
    
    # Actualizar variables en .env
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/" .env
    sed -i "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" .env
    
    if [ ! -z "$GOOGLE_CLIENT_ID" ]; then
        sed -i "s/GOOGLE_CLIENT_ID=.*/GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID/" .env
    fi
    
    if [ ! -z "$GOOGLE_CLIENT_SECRET" ]; then
        sed -i "s/GOOGLE_CLIENT_SECRET=.*/GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET/" .env
    fi
    
    if [ ! -z "$MAIL_USER" ]; then
        sed -i "s/MAIL_USER=.*/MAIL_USER=$MAIL_USER/" .env
    fi
    
    if [ ! -z "$MAIL_PASS" ]; then
        sed -i "s/MAIL_PASS=.*/MAIL_PASS=$MAIL_PASS/" .env
    fi
    
    if [ ! -z "$FRONTEND_URL" ]; then
        sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=$FRONTEND_URL|" .env
    fi
    
    print_color $GREEN "✅ Archivo .env actualizado"
    
    print_section "VERIFICACIÓN"
    
    # Ejecutar script de verificación
    if [ -f "scripts/verify-env.js" ]; then
        print_color $BLUE "🔍 Ejecutando verificación de variables..."
        node scripts/verify-env.js
    else
        print_color $YELLOW "⚠️  Script de verificación no encontrado"
        print_color $BLUE "📋 Revisa manualmente el archivo .env"
    fi
    
    print_section "PRÓXIMOS PASOS"
    
    print_color $GREEN "✅ Configuración básica completada"
    print_color $BLUE "📋 Variables configuradas automáticamente:"
    echo "   - DB_PASSWORD: $DB_PASSWORD"
    echo "   - DB_DATABASE: $DB_DATABASE"
    echo "   - JWT_SECRET: [generado automáticamente]"
    
    if [ -z "$GOOGLE_CLIENT_ID" ] || [ -z "$GOOGLE_CLIENT_SECRET" ]; then
        print_color $YELLOW "⚠️  Variables pendientes de configuración:"
        echo "   - GOOGLE_CLIENT_ID"
        echo "   - GOOGLE_CLIENT_SECRET"
        print_color $BLUE "💡 Edita .env manualmente cuando tengas las credenciales"
    fi
    
    if [ -z "$MAIL_PASS" ]; then
        print_color $YELLOW "⚠️  Variable pendiente:"
        echo "   - MAIL_PASS (App Password de Gmail)"
        print_color $BLUE "💡 Edita .env manualmente cuando generes la App Password"
    fi
    
    print_color $BLUE "🚀 Para desplegar el backend:"
    echo "   docker-compose up --build"
    
    print_color $BLUE "📖 Documentación completa: docs/ENVIRONMENT_SETUP.md"
}

# Ejecutar función principal
main "$@" 