#!/bin/bash

# Script de Despliegue para VPS IONOS - Proyecto FCT
# Configuración profesional para centro de enseñanza

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

# Variables de configuración
DOMAIN=${1:-"your-domain.com"}
EMAIL=${2:-"admin@your-domain.com"}
VPS_IP=${3:-"your-vps-ip"}

print_status "🚀 Iniciando despliegue en VPS IONOS..."
print_status "Dominio: $DOMAIN"
print_status "Email: $EMAIL"
print_status "IP VPS: $VPS_IP"

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.prod.yml" ]; then
    print_error "No se encontró docker-compose.prod.yml. Ejecuta desde el directorio raíz del proyecto."
    exit 1
fi

# 1. Instalar dependencias del sistema
print_status "📦 Instalando dependencias del sistema..."
sudo apt update
sudo apt install -y docker.io docker-compose nginx certbot python3-certbot-nginx

# 2. Configurar Docker
print_status "🐳 Configurando Docker..."
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# 3. Crear directorios necesarios
print_status "📁 Creando estructura de directorios..."
sudo mkdir -p /opt/fct-project
sudo mkdir -p /var/www/static
sudo mkdir -p /var/log/nginx
sudo mkdir -p /etc/nginx/ssl

# 4. Copiar archivos del proyecto
print_status "📋 Copiando archivos del proyecto..."
sudo cp -r . /opt/fct-project/
sudo chown -R $USER:$USER /opt/fct-project

# 5. Configurar variables de entorno
print_status "⚙️ Configurando variables de entorno..."
cd /opt/fct-project

if [ ! -f ".env" ]; then
    print_warning "Archivo .env no encontrado. Creando desde .env.example..."
    cp backend/.env.example .env
    
    # Generar contraseñas seguras
    DB_PASSWORD=$(openssl rand -base64 32)
    JWT_SECRET=$(openssl rand -base64 64)
    
    # Actualizar .env con valores seguros
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env
    sed -i "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" .env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=fct_production/" .env
    
    print_success "Variables de entorno configuradas con contraseñas seguras"
    print_warning "⚠️ Edita el archivo .env con tus configuraciones específicas"
fi

# 6. Configurar Nginx
print_status "🌐 Configurando Nginx..."
sudo cp nginx/nginx.conf /etc/nginx/nginx.conf

# Actualizar configuración con el dominio real
sudo sed -i "s/your-domain.com/$DOMAIN/g" /etc/nginx/nginx.conf

# 7. Obtener certificado SSL
print_status "🔒 Obteniendo certificado SSL..."
sudo certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --non-interactive

# 8. Construir y levantar contenedores
print_status "🐳 Construyendo y levantando contenedores..."
docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d

# 9. Configurar firewall
print_status "🔥 Configurando firewall..."
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw --force enable

# 10. Configurar monitoreo básico
print_status "📊 Configurando monitoreo..."
sudo apt install -y htop iotop nethogs

# Crear script de monitoreo
cat > /opt/fct-project/monitor.sh << 'EOF'
#!/bin/bash
echo "=== Estado de Contenedores ==="
docker ps
echo ""
echo "=== Uso de Recursos ==="
docker stats --no-stream
echo ""
echo "=== Logs de Nginx ==="
tail -n 10 /var/log/nginx/access.log
EOF

chmod +x /opt/fct-project/monitor.sh

# 11. Configurar backup automático
print_status "💾 Configurando backup automático..."
cat > /opt/fct-project/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup de base de datos
docker exec tfg-postgres-prod pg_dump -U postgres fct_production > $BACKUP_DIR/db_backup_$DATE.sql

# Backup de archivos
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz /opt/fct-project/storage

# Mantener solo los últimos 7 backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completado: $DATE"
EOF

chmod +x /opt/fct-project/backup.sh

# Agregar al crontab (backup diario a las 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /opt/fct-project/backup.sh") | crontab -

# 12. Configurar renovación automática de SSL
print_status "🔄 Configurando renovación automática de SSL..."
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -

# 13. Verificar despliegue
print_status "🔍 Verificando despliegue..."
sleep 10

# Verificar que los contenedores están corriendo
if docker ps | grep -q "tfg-api-prod"; then
    print_success "✅ Backend API está corriendo"
else
    print_error "❌ Backend API no está corriendo"
    exit 1
fi

# Verificar que Nginx está corriendo
if sudo systemctl is-active --quiet nginx; then
    print_success "✅ Nginx está corriendo"
else
    print_error "❌ Nginx no está corriendo"
    exit 1
fi

# Verificar SSL
if curl -s -I "https://$DOMAIN/health" | grep -q "200"; then
    print_success "✅ SSL y API funcionando correctamente"
else
    print_warning "⚠️ Verificar configuración SSL manualmente"
fi

# 14. Mostrar información final
print_success "🎉 Despliegue completado exitosamente!"
echo ""
echo "📋 Información del despliegue:"
echo "   🌐 URL de la API: https://$DOMAIN/api"
echo "   🔒 SSL: Configurado automáticamente"
echo "   📊 Monitoreo: /opt/fct-project/monitor.sh"
echo "   💾 Backup: Automático diario a las 2 AM"
echo "   🔄 SSL: Renovación automática configurada"
echo ""
echo "📝 Comandos útiles:"
echo "   Ver estado: docker-compose -f docker-compose.prod.yml ps"
echo "   Ver logs: docker-compose -f docker-compose.prod.yml logs -f"
echo "   Reiniciar: docker-compose -f docker-compose.prod.yml restart"
echo "   Backup manual: /opt/fct-project/backup.sh"
echo "   Monitoreo: /opt/fct-project/monitor.sh"
echo ""
print_warning "⚠️ Recuerda configurar Cloudflare DNS para apuntar a $VPS_IP"
print_warning "⚠️ Edita el archivo .env con tus configuraciones específicas" 