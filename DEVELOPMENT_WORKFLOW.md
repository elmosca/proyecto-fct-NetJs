# Flujo de Trabajo - Desarrollo Híbrido WSL + Windows

## 🎯 Objetivo

Resolver los problemas de desarrollo con Cursor en WSL y mantener un flujo de trabajo eficiente entre Windows (desarrollo) y WSL (servicios Docker).

## 🏗️ Arquitectura

```
Windows (Cursor IDE)          WSL (Servicios Docker)
├── /c/dev/proyecto-fct-NetJs/  ├── /opt/proyecto-fct-NetJs/
│   ├── backend/                 │   ├── backend/ (Stack Docker)
│   ├── frontend/                │   ├── frontend/ (Stack Docker)
│   └── scripts/                 │   └── proxy/ (Proxy reverso)
│                                │
GitHub                         Portainer
└── Repositorio único          └── Gestión de stacks
```

## 🚀 Configuración Inicial

### 1. Windows (Desarrollo)
```powershell
# Clonar en Windows para desarrollo con Cursor
cd C:\dev\
git clone https://github.com/tu-usuario/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs

# Verificar que los scripts estén disponibles
ls scripts/
```

### 2. WSL (Servicios)
```bash
# Ejecutar script de configuración inicial
cd /opt/
git clone https://github.com/tu-usuario/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs
chmod +x scripts/setup-wsl.sh
./scripts/setup-wsl.sh
```

## 📋 Flujo de Trabajo Diario

### Desarrollo (Windows + Cursor)
1. **Editar código** en Windows con Cursor
   - ✅ Errores se muestran correctamente
   - ✅ IntelliSense funciona perfectamente
   - ✅ Git integrado

2. **Hacer commits frecuentes**
   ```bash
   git add .
   git commit -m "feat: nueva funcionalidad"
   git push origin main
   ```

### Despliegue (WSL + Docker)
1. **Sincronizar cambios** (desde Windows)
   ```powershell
   # Sincronizar solo backend
   .\scripts\sync-to-wsl.ps1 backend
   
   # Sincronizar solo frontend
   .\scripts\sync-to-wsl.ps1 frontend
   
   # Sincronizar todo
   .\scripts\sync-to-wsl.ps1 all
   ```

2. **Redesplegar servicios** (en WSL)
   ```bash
   cd /opt/proyecto-fct-NetJs
   ./scripts/redeploy.sh backend
   ```

3. **O usar despliegue rápido** (desde Windows)
   ```powershell
   # Sincroniza y redesplega en un comando
   .\scripts\quick-deploy.ps1 backend
   ```

## 🔧 Scripts Disponibles

### Windows (PowerShell)
- `sync-to-wsl.ps1` - Sincroniza cambios a WSL
- `quick-deploy.ps1` - Sincroniza y redesplega en un comando

### WSL (Bash)
- `setup-wsl.sh` - Configuración inicial de WSL
- `redeploy.sh` - Redespliega servicios Docker

## 📊 Verificación y Monitoreo

### Health Checks
```bash
# Backend
curl http://localhost:3000/api/health

# Verificar en Portainer
# http://localhost:9000 → Stacks → backend → Health
```

### Logs
```bash
# Ver logs del backend
wsl -e docker compose -f /opt/proyecto-fct-NetJs/backend/docker-compose.yml logs -f api

# Ver logs en Portainer
# http://localhost:9000 → Stacks → backend → Logs
```

### Estado de Servicios
```bash
# Listar contenedores
wsl -e docker ps

# Verificar redes
wsl -e docker network ls
```

## 🛠️ Solución de Problemas

### Error: "docker: command not found"
- **Causa**: Docker CLI no disponible en Windows
- **Solución**: Usar WSL para comandos Docker
  ```powershell
  wsl -e docker ps
  ```

### Error: "rsync: command not found"
- **Causa**: rsync no instalado en WSL
- **Solución**: 
  ```bash
  sudo apt update && sudo apt install rsync
  ```

### Error: "Permission denied"
- **Causa**: Scripts sin permisos de ejecución
- **Solución**:
  ```bash
  chmod +x scripts/*.sh
  ```

### Cursor no detecta errores en WSL
- **Causa**: Problemas de permisos/FS en WSL
- **Solución**: Desarrollar en Windows, sincronizar a WSL

## 🔄 Comandos Rápidos

### Desarrollo Rápido
```powershell
# Editar → Sincronizar → Desplegar
.\scripts\quick-deploy.ps1 backend
```

### Solo Sincronizar
```powershell
.\scripts\sync-to-wsl.ps1 backend
```

### Solo Redesplegar
```bash
wsl -e bash -c "cd /opt/proyecto-fct-NetJs && ./scripts/redeploy.sh backend"
```

### Ver Logs
```bash
wsl -e docker compose -f /opt/proyecto-fct-NetJs/backend/docker-compose.yml logs -f
```

## 📝 Buenas Prácticas

### ✅ Hacer
- Desarrollar siempre en Windows con Cursor
- Hacer commits frecuentes
- Usar scripts de automatización
- Verificar health checks después del despliegue
- Mantener sincronizados los repositorios

### ❌ No Hacer
- Editar directamente en WSL
- Modificar archivos .env en producción
- Usar `docker compose` desde Windows
- Ignorar los logs de error

## 🎯 Ventajas de esta Configuración

1. **Cursor funciona perfectamente** en Windows
2. **Docker/Portainer** en WSL sin conflictos
3. **Separación clara** entre desarrollo y servicios
4. **Sincronización automática** con scripts
5. **CI/CD preparado** desde GitHub
6. **Backup y versionado** centralizado

## 📞 Soporte

Si encuentras problemas:
1. Verifica que rsync esté instalado en WSL
2. Comprueba que Docker esté funcionando en WSL
3. Revisa los logs con `docker compose logs -f`
4. Verifica el health check: `curl http://localhost:3000/api/health`

---

**Nota**: Este flujo de trabajo está optimizado para resolver los problemas específicos de Cursor en WSL y mantener un desarrollo eficiente con Docker/Portainer.

