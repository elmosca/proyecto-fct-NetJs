#!/usr/bin/env pwsh
# Script de despliegue rápido: sincroniza y redesplega en un comando
# Uso: .\scripts\quick-deploy.ps1 [backend|frontend|all]

param(
  [Parameter(Position = 0)]
  [ValidateSet("backend", "frontend", "all")]
  [string]$Service = "all"
)

Write-Host "🚀 Despliegue rápido iniciado..." -ForegroundColor Cyan
Write-Host "🔧 Servicio: $Service" -ForegroundColor Yellow
Write-Host ""

# Paso 1: Sincronizar
Write-Host "📤 Paso 1: Sincronizando cambios a WSL..." -ForegroundColor Green
& "$PSScriptRoot\sync-to-wsl.ps1" $Service

# Nota: sync-to-wsl.ps1 puede mostrar advertencias pero no es un error fatal
Write-Host ""

Write-Host ""

# Paso 2: Redesplegar en WSL
Write-Host "📥 Paso 2: Redesplegando en WSL..." -ForegroundColor Green
$wslCommand = "cd /home/jualas/proyectos/proyecto-fct-NetJs && chmod +x ./scripts/redeploy.sh && ./scripts/redeploy.sh $Service"

Write-Host "🔧 Ejecutando: $wslCommand" -ForegroundColor Gray
wsl -e bash -c $wslCommand

if ($LASTEXITCODE -ne 0) {
  Write-Host "❌ Error en redespliegue." -ForegroundColor Red
  Write-Host "💡 Verifica los logs manualmente en WSL" -ForegroundColor Yellow
  exit 1
}

Write-Host ""
Write-Host "🎉 ¡Despliegue completado exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Verificar en:" -ForegroundColor Cyan
Write-Host "   • Portainer: http://localhost:9000" -ForegroundColor White
Write-Host "   • Backend Health: http://localhost:3000/api/health" -ForegroundColor White
Write-Host "   • Frontend: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "🔍 Para ver logs:" -ForegroundColor Cyan
Write-Host "   wsl -e docker compose -f /home/jualas/proyectos/proyecto-fct-NetJs/backend/docker-compose.yml logs -f" -ForegroundColor White

