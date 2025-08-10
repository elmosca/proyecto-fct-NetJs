#!/usr/bin/env pwsh
# Script de sincronización de Windows a WSL
# Uso: .\scripts\sync-to-wsl.ps1 [backend|frontend|all]

param(
  [Parameter(Position = 0)]
  [ValidateSet("backend", "frontend", "all")]
  [string]$Service = "all"
)

$WSL_PATH = "/home/jualas/proyectos/proyecto-fct-NetJs"
$WINDOWS_PATH = "C:\dev\proyecto-fct-NetJs"

Write-Host "🔄 Sincronizando cambios a WSL..." -ForegroundColor Cyan
Write-Host "📁 Origen: $WINDOWS_PATH" -ForegroundColor Gray
Write-Host "📁 Destino: $WSL_PATH" -ForegroundColor Gray
Write-Host ""

# Verificar que rsync esté disponible en WSL
$rsyncCheck = wsl which rsync 2>$null
if (-not $rsyncCheck) {
  Write-Host "❌ Error: rsync no está instalado en WSL" -ForegroundColor Red
  Write-Host "💡 Instala rsync: sudo apt update && sudo apt install rsync" -ForegroundColor Yellow
  exit 1
}

if ($Service -eq "all" -or $Service -eq "backend") {
  Write-Host "📦 Sincronizando backend..." -ForegroundColor Green
  try {
    wsl rsync -av --delete "$WINDOWS_PATH/backend/" "$WSL_PATH/backend/" --exclude node_modules --exclude dist --exclude .env 2>$null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "✅ Backend sincronizado correctamente" -ForegroundColor Green
    }
    else {
      Write-Host "⚠️  Advertencia: Algunos archivos no se sincronizaron" -ForegroundColor Yellow
    }
  }
  catch {
    Write-Host "❌ Error sincronizando backend: $_" -ForegroundColor Red
  }
  Write-Host ""
}

if ($Service -eq "all" -or $Service -eq "frontend") {
  Write-Host "📱 Sincronizando frontend (sin build - se ejecuta en Windows)..." -ForegroundColor Green
  try {
    wsl rsync -av --delete "$WINDOWS_PATH/frontend/" "$WSL_PATH/frontend/" --exclude build --exclude .dart_tool --exclude .env --exclude node_modules 2>$null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "✅ Frontend sincronizado correctamente" -ForegroundColor Green
    }
    else {
      Write-Host "⚠️  Advertencia: Algunos archivos no se sincronizaron" -ForegroundColor Yellow
    }
  }
  catch {
    Write-Host "❌ Error sincronizando frontend: $_" -ForegroundColor Red
  }
  Write-Host ""
}

Write-Host "✅ Sincronización completada" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Para redesplegar en WSL, ejecuta:" -ForegroundColor Cyan
Write-Host "   wsl -e bash -c 'cd $WSL_PATH && ./scripts/redeploy.sh $Service'" -ForegroundColor White
Write-Host ""
Write-Host "📊 O verifica en Portainer: http://localhost:9000" -ForegroundColor Cyan

