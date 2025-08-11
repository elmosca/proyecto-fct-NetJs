# 🚀 Inicio Rápido - Proyecto FCT NetJS

## 📋 Pasos para Configurar el Entorno

### 1. Abrir el Proyecto en Cursor

**Opción A: Usar el Workspace (Recomendado)**
```bash
# Abrir el archivo workspace
cursor proyecto-fct-NetJs.code-workspace
```

**Opción B: Abrir la carpeta directamente**
```bash
# Navegar al proyecto
cd C:\dev\proyecto-fct-NetJs
cursor .
```

### 2. Verificar la Configuración

Una vez abierto el proyecto, ejecuta el diagnóstico:

**Desde el terminal de Cursor:**
```powershell
.\scripts\diagnose.ps1
```

**O desde el menú de tareas:**
- `Ctrl + Shift + P` → "Tasks: Run Task" → "Diagnóstico del Proyecto"

### 3. Configurar WSL (Si no está configurado)

Si el diagnóstico muestra problemas con WSL:

```bash
# En WSL
cd /opt/
git clone https://github.com/tu-usuario/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs
chmod +x scripts/setup-wsl.sh
./scripts/setup-wsl.sh
```

### 4. Desplegar el Backend

```powershell
# Desde el terminal de Cursor
.\scripts\cursor-agent-helper.ps1 deploy-backend
```

### 5. Verificar que Todo Funciona

```powershell
# Verificar health
.\scripts\cursor-agent-helper.ps1 health-backend

# Ver estado de servicios
.\scripts\cursor-agent-helper.ps1 status
```

## 🎯 Comandos Rápidos Disponibles

### Desde el Menú de Tareas (`Ctrl + Shift + P` → "Tasks: Run Task")
- **Diagnóstico del Proyecto** - Verificar estado completo
- **Desplegar Backend** - Sincronizar y desplegar backend
- **Ver Health Backend** - Verificar que el backend responde
- **Ver Logs Backend** - Ver logs en tiempo real

### Desde el Terminal
```powershell
# Comandos principales
.\scripts\cursor-agent-helper.ps1 help                    # Ver todos los comandos
.\scripts\cursor-agent-helper.ps1 deploy-backend          # Desplegar backend
.\scripts\cursor-agent-helper.ps1 health-backend          # Verificar health
.\scripts\cursor-agent-helper.ps1 logs-backend            # Ver logs
.\scripts\cursor-agent-helper.ps1 status                  # Estado de servicios
```

## 🔧 Configuración Automática

El workspace incluye:
- ✅ Terminal PowerShell configurado
- ✅ Extensiones recomendadas
- ✅ Tareas predefinidas
- ✅ Configuración de TypeScript
- ✅ Formateo automático

## 📊 Verificar que Todo Funciona

### 1. Health Check del Backend
```powershell
.\scripts\cursor-agent-helper.ps1 health-backend
```
**Respuesta esperada:**
```json
{
  "status": "ok",
  "timestamp": "2025-01-09T22:30:00.000Z",
  "uptime": 123.45
}
```

### 2. Estado de Servicios
```powershell
.\scripts\cursor-agent-helper.ps1 status
```
**Verificar que todos los contenedores estén "Up"**

### 3. Endpoints Disponibles
- **Backend Health**: http://localhost:3000/api/health
- **Portainer**: http://localhost:9000
- **Frontend**: http://localhost:8080 (cuando esté desplegado)

## 🚨 Solución de Problemas

### Si el diagnóstico falla:
1. **Verificar WSL**: `wsl --status`
2. **Verificar Docker**: `wsl docker --version`
3. **Reinstalar WSL**: `wsl --unregister Ubuntu` → `wsl --install Ubuntu`

### Si el backend no responde:
1. **Ver logs**: `.\scripts\cursor-agent-helper.ps1 logs-backend`
2. **Reiniciar**: `.\scripts\cursor-agent-helper.ps1 restart-backend`
3. **Redesplegar**: `.\scripts\cursor-agent-helper.ps1 deploy-backend`

## 🎯 Próximos Pasos

Una vez que todo esté funcionando:

1. **Editar código** en `backend/src/` o `frontend/lib/`
2. **Compilar**: `.\scripts\cursor-agent-helper.ps1 build-backend`
3. **Desplegar**: `.\scripts\cursor-agent-helper.ps1 deploy-backend`
4. **Verificar**: `.\scripts\cursor-agent-helper.ps1 health-backend`

¡Listo para desarrollar! 🚀
