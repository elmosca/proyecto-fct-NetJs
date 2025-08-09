#!/usr/bin/env pwsh
# Helper para el agente de Cursor - Maneja comandos entre Windows y WSL
# Uso: .\scripts\cursor-agent-helper.ps1 [comando] [parámetros]

param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]$Command,
    
  [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
  [string[]]$Arguments
)

# Configuración
$WSL_PATH = "/home/jualas/proyectos/proyecto-fct-NetJs"
$WINDOWS_PATH = "C:\dev\proyecto-fct-NetJs"

# Función para mostrar ayuda
function Show-Help {
  Write-Host "🔧 Cursor Agent Helper - Comandos disponibles:" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "📦 DESARROLLO:" -ForegroundColor Yellow
  Write-Host "  build-backend     - Compilar backend en Windows"
  Write-Host "  build-frontend    - Compilar frontend en Windows"
  Write-Host "  test-backend      - Ejecutar tests del backend"
  Write-Host "  test-frontend     - Ejecutar tests del frontend"
  Write-Host ""
  Write-Host "🚀 DESPLIEGUE:" -ForegroundColor Yellow
  Write-Host "  deploy-backend    - Sincronizar y desplegar backend"
  Write-Host "  deploy-frontend   - Sincronizar y desplegar frontend"
  Write-Host "  deploy-all        - Sincronizar y desplegar todo"
  Write-Host ""
  Write-Host "📊 MONITOREO:" -ForegroundColor Yellow
  Write-Host "  logs-backend      - Ver logs del backend"
  Write-Host "  logs-frontend     - Ver logs del frontend"
  Write-Host "  health-backend    - Verificar health del backend"
  Write-Host "  status            - Estado de todos los servicios"
  Write-Host ""
  Write-Host "🔧 UTILIDADES:" -ForegroundColor Yellow
  Write-Host "  sync-backend      - Solo sincronizar backend"
  Write-Host "  sync-frontend     - Solo sincronizar frontend"
  Write-Host "  restart-backend   - Reiniciar solo backend"
  Write-Host "  restart-frontend  - Reiniciar solo frontend"
  Write-Host ""
  Write-Host "💡 Ejemplos:" -ForegroundColor Gray
  Write-Host "  .\scripts\cursor-agent-helper.ps1 deploy-backend"
  Write-Host "  .\scripts\cursor-agent-helper.ps1 logs-backend"
  Write-Host "  .\scripts\cursor-agent-helper.ps1 health-backend"
}

# Función para ejecutar comandos en WSL
function Invoke-WSLCommand {
  param([string]$Command)
  Write-Host "🔧 Ejecutando en WSL: $Command" -ForegroundColor Gray
  wsl -e bash -c $Command
  return $LASTEXITCODE
}

# Función para verificar si WSL está disponible
function Test-WSL {
  try {
    $null = wsl echo "test" 2>$null
    return $true
  }
  catch {
    return $false
  }
}

# Verificar WSL
if (-not (Test-WSL)) {
  Write-Host "❌ Error: WSL no está disponible" -ForegroundColor Red
  Write-Host "💡 Asegúrate de que WSL esté instalado y funcionando" -ForegroundColor Yellow
  exit 1
}

# Procesar comandos
switch ($Command.ToLower()) {
  # ===== DESARROLLO =====
  "build-backend" {
    Write-Host "🔨 Compilando backend en Windows..." -ForegroundColor Green
    Set-Location "$WINDOWS_PATH\backend"
    npm ci
    npm run build
    if ($LASTEXITCODE -eq 0) {
      Write-Host "✅ Backend compilado correctamente" -ForegroundColor Green
    }
    else {
      Write-Host "❌ Error compilando backend" -ForegroundColor Red
      exit 1
    }
  }
    
  "build-frontend" {
    Write-Host "🔨 Compilando frontend en Windows..." -ForegroundColor Green
    Set-Location "$WINDOWS_PATH\frontend"
    flutter clean
    flutter pub get
    flutter build web
    if ($LASTEXITCODE -eq 0) {
      Write-Host "✅ Frontend compilado correctamente" -ForegroundColor Green
    }
    else {
      Write-Host "❌ Error compilando frontend" -ForegroundColor Red
      exit 1
    }
  }
    
  "test-backend" {
    Write-Host "🧪 Ejecutando tests del backend..." -ForegroundColor Green
    Set-Location "$WINDOWS_PATH\backend"
    npm test
  }
    
  "test-frontend" {
    Write-Host "🧪 Ejecutando tests del frontend..." -ForegroundColor Green
    Set-Location "$WINDOWS_PATH\frontend"
    flutter test
  }
    
  # ===== DESPLIEGUE =====
  "deploy-backend" {
    Write-Host "🚀 Desplegando backend..." -ForegroundColor Cyan
    & "$PSScriptRoot\quick-deploy.ps1" "backend"
  }
    
  "deploy-frontend" {
    Write-Host "🚀 Desplegando frontend..." -ForegroundColor Cyan
    & "$PSScriptRoot\quick-deploy.ps1" "frontend"
  }
    
  "deploy-all" {
    Write-Host "🚀 Desplegando todos los servicios..." -ForegroundColor Cyan
    & "$PSScriptRoot\quick-deploy.ps1" "all"
  }
    
  # ===== MONITOREO =====
  "logs-backend" {
    Write-Host "📋 Mostrando logs del backend..." -ForegroundColor Green
    Invoke-WSLCommand "docker compose -f $WSL_PATH/backend/docker-compose.yml logs -f api"
  }
    
  "logs-frontend" {
    Write-Host "📋 Mostrando logs del frontend..." -ForegroundColor Green
    Invoke-WSLCommand "docker compose -f $WSL_PATH/frontend/docker-compose.yml logs -f"
  }
    
  "health-backend" {
    Write-Host "🏥 Verificando health del backend..." -ForegroundColor Green
    try {
      $response = Invoke-RestMethod -Uri "http://localhost:3000/api/health" -Method Get -TimeoutSec 5
      Write-Host "✅ Backend saludable: $($response | ConvertTo-Json)" -ForegroundColor Green
    }
    catch {
      Write-Host "❌ Backend no responde: $($_.Exception.Message)" -ForegroundColor Red
      exit 1
    }
  }
    
  "status" {
    Write-Host "📊 Estado de servicios..." -ForegroundColor Green
    Invoke-WSLCommand "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
  }
    
  # ===== UTILIDADES =====
  "sync-backend" {
    Write-Host "📤 Sincronizando backend..." -ForegroundColor Green
    & "$PSScriptRoot\sync-to-wsl.ps1" "backend"
  }
    
  "sync-frontend" {
    Write-Host "📤 Sincronizando frontend..." -ForegroundColor Green
    & "$PSScriptRoot\sync-to-wsl.ps1" "frontend"
  }
    
  "restart-backend" {
    Write-Host "🔄 Reiniciando backend..." -ForegroundColor Green
    Invoke-WSLCommand "cd $WSL_PATH/backend && docker compose restart"
  }
    
  "restart-frontend" {
    Write-Host "🔄 Reiniciando frontend..." -ForegroundColor Green
    Invoke-WSLCommand "cd $WSL_PATH/frontend && docker compose restart"
  }
    
  # ===== AYUDA =====
  "help" { Show-Help }
  "?" { Show-Help }
  "-h" { Show-Help }
  "--help" { Show-Help }
    
  # ===== COMANDO NO RECONOCIDO =====
  default {
    Write-Host "❌ Comando no reconocido: $Command" -ForegroundColor Red
    Write-Host ""
    Show-Help
    exit 1
  }
}
