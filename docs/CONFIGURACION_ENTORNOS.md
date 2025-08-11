# 🌍 Configuración de Entornos - Frontend

## 📋 Descripción

Este documento explica cómo configurar el frontend para conectarse a diferentes entornos de backend, desde desarrollo local hasta producción.

## 🏗️ Arquitectura de Entornos

### Entornos Disponibles

| Entorno | Descripción | URL Backend | Caso de Uso |
|---------|-------------|-------------|-------------|
| `development` | Desarrollo local (Windows + WSL) | `http://localhost:3000` | Desarrollo diario |
| `wsl` | WSL con Docker | `http://localhost:3000` | Desarrollo con contenedores |
| `production` | Producción | `https://api.tudominio.com` | Servidor de producción |
| `staging` | Staging/Testing | `https://staging-api.tudominio.com` | Pruebas antes de producción |
| `remote` | Backend en equipo remoto | `http://192.168.1.100:3000` | Desarrollo distribuido |
| `custom` | Configuración personalizada | Personalizable | Casos especiales |

## 🚀 Configuración Rápida

### 1. Configurar Entorno de Desarrollo (Recomendado)

```powershell
# Configurar para desarrollo local
.\scripts\cursor-agent-helper.ps1 configure-env-development

# O usar el comando directo
.\frontend\scripts\configure-environment.ps1 -Environment development
```

### 2. Configurar para Backend Remoto

```powershell
# Configurar para backend en otro equipo
.\scripts\cursor-agent-helper.ps1 configure-env-remote

# O configuración personalizada
.\scripts\cursor-agent-helper.ps1 configure-env-custom -ApiUrl "http://192.168.1.100:3000" -WsUrl "ws://192.168.1.100:3000"
```

### 3. Verificar Configuración

```powershell
# Ver información del entorno actual
.\scripts\cursor-agent-helper.ps1 configure-env
```

## 🔧 Configuración Manual

### Opción 1: Variables de Entorno

```powershell
# Compilar con entorno específico
flutter build web --dart-define=ENVIRONMENT=development
flutter build web --dart-define=ENVIRONMENT=production
flutter build web --dart-define=ENVIRONMENT=remote
```

### Opción 2: Archivo de Configuración

Editar `frontend/lib/core/config/app_config.dart`:

```dart
static const Map<String, EnvironmentConfig> _environments = {
  'mi-entorno': EnvironmentConfig(
    apiBaseUrl: 'http://mi-servidor:3000',
    wsBaseUrl: 'ws://mi-servidor:3000',
    apiVersion: '/api/v1',
  ),
};
```

## 📱 Ejecutar Frontend

### Desarrollo Local

```powershell
# Ejecutar con entorno específico
flutter run -d web-server --web-port 8082 --dart-define=ENVIRONMENT=development

# O usar el helper script
.\scripts\cursor-agent-helper.ps1 serve-frontend
```

### Producción

```powershell
# Compilar para producción
flutter build web --dart-define=ENVIRONMENT=production

# Servir archivos compilados
cd frontend/build/web
python -m http.server 8082
```

## 🔍 Diagnóstico de Problemas

### 1. Verificar Conectividad

```powershell
# Verificar si el backend responde
curl http://localhost:3000/api/health

# Verificar desde WSL
wsl curl http://localhost:3000/api/health
```

### 2. Verificar Configuración Actual

```powershell
# Ver configuración del frontend
.\scripts\cursor-agent-helper.ps1 configure-env
```

### 3. Logs del Backend

```powershell
# Ver logs del backend
.\scripts\cursor-agent-helper.ps1 logs-backend

# Ver estado de contenedores
.\scripts\cursor-agent-helper.ps1 status
```

## 🌐 Casos de Uso Comunes

### Caso 1: Desarrollo Local (Windows + WSL)

```powershell
# 1. Configurar entorno
.\scripts\cursor-agent-helper.ps1 configure-env-development

# 2. Verificar backend
.\scripts\cursor-agent-helper.ps1 health-backend

# 3. Ejecutar frontend
.\scripts\cursor-agent-helper.ps1 serve-frontend
```

### Caso 2: Backend en Equipo Remoto

```powershell
# 1. Configurar para equipo remoto
.\scripts\cursor-agent-helper.ps1 configure-env-custom -ApiUrl "http://192.168.1.100:3000" -WsUrl "ws://192.168.1.100:3000"

# 2. Verificar conectividad
curl http://192.168.1.100:3000/api/health

# 3. Ejecutar frontend
.\scripts\cursor-agent-helper.ps1 serve-frontend
```

### Caso 3: Producción

```powershell
# 1. Configurar para producción
.\scripts\cursor-agent-helper.ps1 configure-env-production

# 2. Compilar
flutter build web --dart-define=ENVIRONMENT=production

# 3. Desplegar archivos en build/web/
```

## 🔐 Seguridad

### Variables de Entorno Sensibles

Para configuraciones que contengan credenciales:

```powershell
# Usar variables de entorno
$env:API_URL = "https://api.tudominio.com"
$env:API_KEY = "tu-api-key"

# Configurar con variables
.\frontend\scripts\configure-environment.ps1 -Environment custom -CustomApiUrl $env:API_URL
```

### Configuración en Producción

- Nunca committear credenciales reales
- Usar variables de entorno del servidor
- Configurar HTTPS en producción
- Implementar autenticación adecuada

## 📊 Monitoreo

### Verificar Estado de Servicios

```powershell
# Estado general
.\scripts\cursor-agent-helper.ps1 status

# Health del backend
.\scripts\cursor-agent-helper.ps1 health-backend

# Logs en tiempo real
.\scripts\cursor-agent-helper.ps1 logs-backend
```

### Métricas de Conectividad

```powershell
# Test de latencia
Test-NetConnection -ComputerName localhost -Port 3000

# Test de conectividad HTTP
Invoke-WebRequest -Uri "http://localhost:3000/api/health" -Method GET
```

## 🛠️ Troubleshooting

### Problema: Frontend no se conecta al backend

**Síntomas:**
- Spinner de carga infinito en login
- Errores de red en consola del navegador
- Timeout en peticiones HTTP

**Soluciones:**
1. Verificar que el backend esté corriendo
2. Verificar la URL de configuración
3. Verificar firewall/red
4. Verificar CORS en el backend

### Problema: Cambios de configuración no se aplican

**Síntomas:**
- Frontend sigue usando configuración anterior
- Cambios en app_config.dart no tienen efecto

**Soluciones:**
1. Reiniciar el servidor de desarrollo
2. Limpiar cache: `flutter clean`
3. Recompilar: `flutter build web`
4. Verificar que el archivo se guardó correctamente

### Problema: Errores de CORS

**Síntomas:**
- Errores en consola del navegador sobre CORS
- Peticiones bloqueadas por el navegador

**Soluciones:**
1. Configurar CORS en el backend
2. Usar proxy de desarrollo
3. Verificar que las URLs coincidan

## 📝 Notas Importantes

1. **Sincronización**: Después de cambiar configuración, hacer commit y push
2. **Backup**: Guardar configuraciones importantes
3. **Documentación**: Documentar configuraciones especiales
4. **Testing**: Probar conectividad antes de desarrollo

## 🔄 Flujo de Trabajo Recomendado

1. **Configurar entorno** → `configure-env-development`
2. **Verificar conectividad** → `health-backend`
3. **Desarrollar** → `serve-frontend`
4. **Probar** → Acceder a `http://localhost:8082`
5. **Commit cambios** → `git add . && git commit -m "feat: nueva funcionalidad"`
6. **Desplegar** → `deploy-all`
