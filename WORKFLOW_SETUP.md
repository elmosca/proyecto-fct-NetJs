# Flujo de Trabajo Optimizado - WSL + Windows + Docker

## Arquitectura Propuesta

```
Windows (Cursor IDE)
├── /c/dev/proyecto-fct-NetJs/  ← Desarrollo principal
│   ├── backend/                 ← Código fuente
│   ├── frontend/                ← Código fuente
│   └── scripts/                 ← Scripts de automatización
│
WSL (Servicios Docker)
├── /opt/proyecto-fct-NetJs/     ← Servicios en producción
│   ├── backend/                 ← Stack Docker
│   ├── frontend/                ← Stack Docker
│   └── proxy/                   ← Proxy reverso
│
GitHub
└── Repositorio único con CI/CD
```

## Configuración del Entorno

### 1. Windows (Desarrollo con Cursor)
```bash
# Clonar en Windows para desarrollo
cd /c/dev/
git clone https://github.com/tu-usuario/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs

# Configurar scripts de sincronización
```

### 2. WSL (Servicios Docker)
```bash
# Clonar en WSL para servicios
cd /opt/
git clone https://github.com/tu-usuario/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs

# Configurar Portainer y stacks
```

## Scripts de Automatización

### Script de Sincronización (Windows)
```powershell
# scripts/sync-to-wsl.ps1
param(
    [string]$Service = "all"
)

$WSL_PATH = "/opt/proyecto-fct-NetJs"
$WINDOWS_PATH = "C:\dev\proyecto-fct-NetJs"

Write-Host "🔄 Sincronizando cambios a WSL..."

if ($Service -eq "all" -or $Service -eq "backend") {
    Write-Host "📦 Sincronizando backend..."
    wsl rsync -av --delete "$WINDOWS_PATH/backend/" "$WSL_PATH/backend/" --exclude node_modules --exclude dist
}

if ($Service -eq "all" -or $Service -eq "frontend") {
    Write-Host "📱 Sincronizando frontend..."
    wsl rsync -av --delete "$WINDOWS_PATH/frontend/" "$WSL_PATH/frontend/" --exclude build --exclude .dart_tool
}

Write-Host "✅ Sincronización completada"
Write-Host "🚀 Ejecuta en WSL: cd $WSL_PATH && ./scripts/redeploy.sh $Service"
```

### Script de Redespliegue (WSL)
```bash
#!/bin/bash
# scripts/redeploy.sh
SERVICE=${1:-"all"}

echo "🚀 Redesplegando servicios..."

if [ "$SERVICE" = "all" ] || [ "$SERVICE" = "backend" ]; then
    echo "📦 Redesplegando backend..."
    cd /opt/proyecto-fct-NetJs/backend
    docker compose down
    docker compose up -d --build
fi

if [ "$SERVICE" = "all" ] || [ "$SERVICE" = "frontend" ]; then
    echo "📱 Redesplegando frontend..."
    cd /opt/proyecto-fct-NetJs/frontend
    docker compose down
    docker compose up -d --build
fi

echo "✅ Redespliegue completado"
echo "📊 Verificar en Portainer: http://localhost:9000"
```

## Flujo de Trabajo Diario

### 1. Desarrollo (Windows + Cursor)
```bash
# En Windows, editar código con Cursor
# Los errores se muestran correctamente
# Hacer commits frecuentes
git add .
git commit -m "feat: implementar nueva funcionalidad"
git push origin main
```

### 2. Sincronización y Despliegue
```bash
# En Windows PowerShell
.\scripts\sync-to-wsl.ps1 backend

# En WSL
cd /opt/proyecto-fct-NetJs
./scripts/redeploy.sh backend
```

### 3. Verificación
```bash
# Verificar health check
curl http://localhost:3000/api/health

# Ver logs en Portainer
# http://localhost:9000 → Stacks → backend → Logs
```

## Configuración de Cursor para WSL

### Opción A: Montaje de WSL en Windows
```json
// .vscode/settings.json
{
    "remote.WSL.enabled": true,
    "remote.WSL.debug": true,
    "files.watcherExclude": {
        "**/node_modules/**": true,
        "**/dist/**": true,
        "**/.git/**": true
    }
}
```

### Opción B: Desarrollo en Windows, Servicios en WSL
- Mantener código fuente en Windows
- Usar scripts de sincronización
- Servicios Docker solo en WSL

## Ventajas de esta Configuración

✅ **Cursor funciona perfectamente** en Windows con detección de errores
✅ **Docker/Portainer** en WSL sin conflictos
✅ **Separación clara** entre desarrollo y servicios
✅ **Sincronización automática** con scripts
✅ **CI/CD preparado** desde GitHub
✅ **Backup y versionado** centralizado

## Comandos Rápidos

```bash
# Desarrollo rápido
.\scripts\sync-to-wsl.ps1 backend
wsl -e bash -c "cd /opt/proyecto-fct-NetJs && ./scripts/redeploy.sh backend"

# Ver logs
wsl -e docker compose -f /opt/proyecto-fct-NetJs/backend/docker-compose.yml logs -f api

# Health check
curl http://localhost:3000/api/health
```

## Próximos Pasos

1. **Crear los scripts** de sincronización
2. **Configurar el repositorio** único en GitHub
3. **Migrar servicios** a `/opt/` en WSL
4. **Configurar CI/CD** para builds automáticos
5. **Documentar** el flujo para el equipo

¿Te parece bien esta estructura? Podemos empezar creando los scripts de automatización.

