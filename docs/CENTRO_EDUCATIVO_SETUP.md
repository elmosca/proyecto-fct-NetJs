# Configuración para Centro Educativo - Proyecto FCT

## 🎯 Descripción

Esta guía proporciona opciones de despliegue realistas para centros educativos, considerando limitaciones de presupuesto, infraestructura y acceso técnico.

## 📋 Opciones de Despliegue

### **Opción 1: Servidor Local Puro (Recomendada)**

**Ventajas:**

- ✅ **Coste cero** - Sin costes mensuales
- ✅ **Control total** - Hardware propio del centro
- ✅ **Sin dependencias externas** - No requiere servicios de terceros
- ✅ **Acceso desde red local** - Cualquier dispositivo en la red
- ✅ **Configuración simple** - Un solo comando para desplegar

**Requisitos:**

- Servidor/PC con Docker
- Conexión a red local
- Puerto 80 disponible (o configurar otro puerto)

### **Opción 2: VPS Económico (Alternativa)**

**Ventajas:**

- ✅ **Bajo coste** - Desde 1€/mes
- ✅ **Acceso 24/7** - Siempre disponible
- ✅ **Sin dependencia local** - No requiere servidor propio

**Limitaciones:**

- ❌ **Coste mensual** - Aunque mínimo
- ❌ **Recursos limitados** - En opciones económicas

### **Opción 3: Servicios Cloud Educativos**

**Opciones:**

- **Google Cloud Platform** - Créditos gratuitos para educación
- **Microsoft Azure** - Créditos para estudiantes
- **AWS Educate** - Recursos gratuitos para educación

## 🚀 Configuración Recomendada: Servidor Local Puro

### **1. Requisitos del Sistema**

```bash
# Servidor mínimo recomendado
CPU: 2 cores
RAM: 4GB
Almacenamiento: 20GB
OS: Ubuntu 20.04+ / Windows 10+ / macOS 10.15+
```

### **2. Instalación Automática**

```bash
# Clonar el proyecto
git clone https://github.com/elmosca/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs

# Instalar dependencias
chmod +x install-dependencies.sh
./install-dependencies.sh

# Ejecutar configuración automática
chmod +x deploy-centro-educativo.sh
./deploy-centro-educativo.sh
```

### **3. Configuración Manual (si es necesario)**

#### **A. Instalar Docker**

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Windows/macOS
# Descargar Docker Desktop desde docker.com
```

#### **B. Verificar Configuración de Red**

```bash
# Verificar IP del servidor
hostname -I

# Verificar puerto 80 disponible
sudo netstat -tulpn | grep :80

# Si el puerto 80 está ocupado, cambiar en docker-compose.centro.yml
```

### **4. Configuración de Variables**

```bash
# Editar archivo .env
nano .env

# Configuraciones importantes:
DB_PASSWORD=contraseña_segura_aqui
JWT_SECRET=clave_secreta_muy_larga_aqui
GOOGLE_CLIENT_ID=tu_google_client_id
GOOGLE_CLIENT_SECRET=tu_google_client_secret
```

## 🌐 Acceso desde Red Local

### **1. URLs Disponibles**

```bash
# URL local
http://localhost/api

# URL desde red local (reemplazar con IP del servidor)
http://192.168.1.100/api
```

### **2. Configuración para Dispositivos**

#### **Flutter Móvil**

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://192.168.1.100/api'; // IP del servidor
}
```

#### **Flutter Web**

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://localhost/api';
}
```

### **3. Configuración de Firewall (Opcional)**

```bash
# Permitir acceso al puerto 80
sudo ufw allow 80/tcp

# Verificar reglas
sudo ufw status
```

## 📊 Monitoreo y Mantenimiento

### **1. Verificar Estado**

```bash
# Estado general
./monitor-centro.sh

# Logs en tiempo real
docker-compose -f docker-compose.centro.yml logs -f
```

### **2. Backup Automático**

```bash
# Backup manual
./backup-centro.sh

# Backup automático (configurar cron)
# 0 2 * * * /ruta/al/proyecto/backup-centro.sh
```

### **3. Actualizaciones**

```bash
# Actualizar código
git pull origin main

# Reconstruir contenedores
docker-compose -f docker-compose.centro.yml build --no-cache
docker-compose -f docker-compose.centro.yml up -d
```

## 🎓 Configuración para Presentación

### **1. Preparación Antes de la Presentación**

```bash
# 1. Verificar que todo funciona
./monitor-centro.sh

# 2. Crear backup
./backup-centro.sh

# 3. Obtener IP del servidor
hostname -I

# 4. Probar desde otro dispositivo
curl http://[IP-DEL-SERVIDOR]/health
```

### **2. Durante la Presentación**

```bash
# Mostrar estado en tiempo real
watch -n 5 ./monitor-centro.sh

# Ver logs en tiempo real
docker-compose -f docker-compose.centro.yml logs -f api
```

### **3. Demostración de Funcionalidades**

1. **Acceso desde móvil** - Usar http://[IP-DEL-SERVIDOR]/api
2. **Autenticación Google** - Probar login
3. **Gestión de proyectos** - Crear/editar proyectos
4. **Subida de archivos** - Probar uploads
5. **Sistema de evaluaciones** - Mostrar workflow completo

## 🔧 Configuración Avanzada

### **1. Configurar Dominio Personalizado**

Si el centro tiene un dominio:

```bash
# 1. Configurar DNS en Cloudflare
# Añadir registro A apuntando a la IP del servidor

# 2. Configurar tunnel permanente
cloudflared tunnel create fct-centro
cloudflared tunnel route dns fct-centro api.tu-centro.edu

# 3. Configurar archivo de configuración
cat > ~/.cloudflared/config.yml << EOF
tunnel: [tunnel-id]
credentials-file: ~/.cloudflared/[tunnel-id].json
ingress:
  - hostname: api.tu-centro.edu
    service: http://localhost:8080
  - service: http_status:404
EOF
```

### **2. Configurar SSL Local**

```bash
# Generar certificado autofirmado
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx-selfsigned.key \
  -out /etc/ssl/certs/nginx-selfsigned.crt

# Configurar Nginx con SSL
# (Ver nginx/nginx.conf para configuración completa)
```

### **3. Configurar Firewall**

```bash
# Ubuntu/Debian
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8080/tcp  # Aplicación local
sudo ufw --force enable

# Windows
# Configurar Windows Firewall para permitir puerto 8080
```

## 🛠️ Troubleshooting

### **Problema: Docker no inicia**

```bash
# Verificar que Docker está corriendo
sudo systemctl status docker

# Reiniciar Docker
sudo systemctl restart docker
```

### **Problema: Contenedores no se levantan**

```bash
# Ver logs detallados
docker-compose -f docker-compose.local.yml logs

# Verificar puertos
netstat -tulpn | grep :8080
```

### **Problema: Cloudflare Tunnel no funciona**

```bash
# Verificar instalación
cloudflared version

# Probar tunnel manualmente
cloudflared tunnel --url http://localhost:8080
```

### **Problema: Base de datos no conecta**

```bash
# Verificar contenedor
docker ps | grep postgres

# Ver logs de PostgreSQL
docker logs fct-postgres-local

# Conectar manualmente
docker exec -it fct-postgres-local psql -U postgres -d fct_local
```

## 📚 Recursos Adicionales

### **Documentación del Proyecto**

- [README.md](../README.md) - Documentación principal
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Guía de contribución
- [backend/docs/](../backend/docs/) - Documentación técnica

### **Recursos Externos**

- [Docker Documentation](https://docs.docker.com/)
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

### **Soporte**

- **Email**: jualas@gmail.com
- **Issues**: [GitHub Issues](https://github.com/elmosca/proyecto-fct-NetJs/issues)
- **Documentación**: [Wiki del proyecto](https://github.com/elmosca/proyecto-fct-NetJs/wiki)

---

**Nota**: Esta configuración está optimizada para centros educativos con recursos limitados, proporcionando una solución profesional sin costes adicionales.
