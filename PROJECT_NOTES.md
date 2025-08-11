# Notas del Proyecto FCT NetJS - Para el Agente de Cursor

## 🎯 INFORMACIÓN CRÍTICA

### Problema Principal Resuelto
- **Cursor arranca en Windows** pero los servicios corren en WSL
- **Solución**: Scripts helper que manejan la comunicación entre entornos

### Estructura de Directorios
```
C:\dev\proyecto-fct-NetJs\          ← Desarrollo (Windows)
├── backend/                         ← NestJS API
├── frontend/                        ← Flutter Web
└── scripts/                         ← Scripts de automatización

/opt/proyecto-fct-NetJs/             ← Servicios (WSL)
├── backend/                         ← Stack Docker
├── frontend/                        ← Stack Docker
└── proxy/                          ← Proxy reverso
```

## 🔧 COMANDOS CLAVE PARA EL AGENTE

### Desarrollo y Compilación
```powershell
# Backend
.\scripts\cursor-agent-helper.ps1 build-backend
.\scripts\cursor-agent-helper.ps1 test-backend

# Frontend  
.\scripts\cursor-agent-helper.ps1 build-frontend
.\scripts\cursor-agent-helper.ps1 test-frontend
```

### Despliegue
```powershell
# Desplegar backend (sincroniza + despliega)
.\scripts\cursor-agent-helper.ps1 deploy-backend

# Desplegar frontend
.\scripts\cursor-agent-helper.ps1 deploy-frontend

# Desplegar todo
.\scripts\cursor-agent-helper.ps1 deploy-all
```

### Monitoreo
```powershell
# Ver estado de servicios
.\scripts\cursor-agent-helper.ps1 status

# Ver logs
.\scripts\cursor-agent-helper.ps1 logs-backend
.\scripts\cursor-agent-helper.ps1 logs-frontend

# Verificar health
.\scripts\cursor-agent-helper.ps1 health-backend
```

## 🚨 PROBLEMAS CONOCIDOS Y SOLUCIONES

### 1. Error 404 en /api/health
**Causa**: AppController no registrado en AppModule
**Solución**: 
```powershell
# Verificar que AppController esté en app.module.ts
# Luego desplegar
.\scripts\cursor-agent-helper.ps1 deploy-backend
.\scripts\cursor-agent-helper.ps1 health-backend
```

### 2. Contenedor "unhealthy" en Portainer
**Causa**: Health check fallando
**Solución**:
```powershell
.\scripts\cursor-agent-helper.ps1 logs-backend
.\scripts\cursor-agent-helper.ps1 restart-backend
.\scripts\cursor-agent-helper.ps1 health-backend
```

### 3. Cursor no detecta errores en WSL
**Causa**: Problemas de permisos/FS en WSL
**Solución**: Desarrollar en Windows, sincronizar a WSL

## 📋 FLUJO DE TRABAJO ESTÁNDAR

### Para Cambios en Backend
1. Editar código en `backend/src/`
2. Compilar: `.\scripts\cursor-agent-helper.ps1 build-backend`
3. Commit: `git add . && git commit -m "descripción"`
4. Push: `git push origin main`
5. Desplegar: `.\scripts\cursor-agent-helper.ps1 deploy-backend`
6. Verificar: `.\scripts\cursor-agent-helper.ps1 health-backend`

### Para Cambios en Frontend
1. Editar código en `frontend/lib/`
2. Compilar: `.\scripts\cursor-agent-helper.ps1 build-frontend`
3. Commit: `git add . && git commit -m "descripción"`
4. Push: `git push origin main`
5. Desplegar: `.\scripts\cursor-agent-helper.ps1 deploy-frontend`

## 🔍 VERIFICACIONES IMPORTANTES

### Health Check del Backend
```powershell
.\scripts\cursor-agent-helper.ps1 health-backend
```
**Respuesta esperada**:
```json
{
  "status": "ok",
  "timestamp": "2025-01-09T22:30:00.000Z",
  "uptime": 123.45
}
```

### Estado de Servicios
```powershell
.\scripts\cursor-agent-helper.ps1 status
```
**Verificar que todos los contenedores estén "Up"**

## 📊 ENDPOINTS IMPORTANTES

### Backend
- **Health**: `http://localhost:3000/api/health`
- **API Base**: `http://localhost:3000/api/`
- **Swagger**: `http://localhost:3000/api/docs` (si está configurado)

### Frontend
- **Web**: `http://localhost:8080`
- **Portainer**: `http://localhost:9000`

## 🛠️ CONFIGURACIÓN ESPECÍFICA

### Backend (NestJS)
- **Puerto**: 3000
- **Base de datos**: PostgreSQL en WSL
- **Health check**: `/api/health`
- **Prefijo global**: `/api`

### Frontend (Flutter)
- **Puerto**: 8080
- **Build**: Web
- **Framework**: Flutter 3.x

## 📝 NOTAS DE DESARROLLO

### Archivos Críticos del Backend
- `src/app.module.ts` - Módulo principal (debe incluir AppController)
- `src/app.controller.ts` - Controlador principal con health check
- `src/main.ts` - Configuración de la aplicación
- `docker-compose.yml` - Configuración de Docker

### Variables de Entorno
- `.env` en backend/ (no committear)
- Configurar DB_HOST, DB_PORT, JWT_SECRET, etc.

## 🎯 RESUMEN PARA EL AGENTE

**RECUERDA**: 
1. **SIEMPRE** usa los scripts helper
2. **NUNCA** uses comandos Docker directamente desde Windows
3. **SIEMPRE** verifica health checks después del despliegue
4. **SIEMPRE** mantén el repositorio sincronizado
5. **SIEMPRE** documenta cambios importantes

**Comando principal**: `.\scripts\cursor-agent-helper.ps1 [comando]`
