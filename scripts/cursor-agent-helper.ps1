#!/usr/bin/env pwsh
# Helper para el agente de Cursor - Maneja comandos en Windows local con Docker Desktop
# Uso: .\scripts\cursor-agent-helper.ps1 [comando] [parámetros]

param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]$Command,
    
  [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
  [string[]]$Arguments
)

# Configuración
$PROJECT_PATH = "C:\dev\proyecto-fct-NetJs"

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
  Write-Host "🚀 DESPLIEGUE:" -ForegroundColor Green
  Write-Host "  deploy-backend    - Desplegar backend con Docker"
  Write-Host "  deploy-frontend   - Desplegar frontend con Docker"
  Write-Host "  deploy-all        - Desplegar backend y frontend"
  Write-Host ""
  Write-Host "📊 MONITOREO:" -ForegroundColor Blue
  Write-Host "  status            - Estado de todos los servicios"
  Write-Host "  logs-backend      - Ver logs del backend"
  Write-Host "  logs-frontend     - Ver logs del frontend"
  Write-Host "  health-backend    - Health check del backend"
  Write-Host ""
  Write-Host "🔄 GESTIÓN:" -ForegroundColor Magenta
  Write-Host "  restart-backend   - Reiniciar backend"
  Write-Host "  restart-frontend  - Reiniciar frontend"
  Write-Host "  stop-all          - Detener todos los servicios"
  Write-Host "  clean-all         - Limpiar contenedores y volúmenes"
  Write-Host ""
  Write-Host "❓ AYUDA:" -ForegroundColor White
  Write-Host "  help              - Mostrar esta ayuda"
}

# Función para verificar Docker
function Test-Docker {
  try {
    docker --version | Out-Null
    return $true
  }
  catch {
    Write-Host "❌ Docker no está disponible. Asegúrate de que Docker Desktop esté ejecutándose." -ForegroundColor Red
    return $false
  }
}

# Función para compilar backend
function Build-Backend {
  Write-Host "🔨 Compilando backend..." -ForegroundColor Yellow
  Set-Location "$PROJECT_PATH\backend"
  
  try {
    npm install
    npm run build
    Write-Host "✅ Backend compilado correctamente" -ForegroundColor Green
  }
  catch {
    Write-Host "❌ Error compilando backend: $_" -ForegroundColor Red
  }
  finally {
    Set-Location $PROJECT_PATH
  }
}

# Función para compilar frontend
function Build-Frontend {
  Write-Host "🔨 Compilando frontend..." -ForegroundColor Yellow
  Set-Location "$PROJECT_PATH\frontend"
  
  try {
    flutter pub get
    flutter build web
    Write-Host "✅ Frontend compilado correctamente" -ForegroundColor Green
  }
  catch {
    Write-Host "❌ Error compilando frontend: $_" -ForegroundColor Red
  }
  finally {
    Set-Location $PROJECT_PATH
  }
}

# Función para desplegar backend
function Deploy-Backend {
  if (-not (Test-Docker)) { return }
  
  Write-Host "🚀 Desplegando backend..." -ForegroundColor Green
  Set-Location "$PROJECT_PATH\backend"
  
  try {
    docker compose down
    docker compose up -d --build
    Write-Host "✅ Backend desplegado correctamente" -ForegroundColor Green
  }
  catch {
    Write-Host "❌ Error desplegando backend: $_" -ForegroundColor Red
  }
  finally {
    Set-Location $PROJECT_PATH
  }
}

# Función para desplegar frontend
function Deploy-Frontend {
  if (-not (Test-Docker)) { return }
  
  Write-Host "🚀 Desplegando frontend..." -ForegroundColor Green
  Set-Location "$PROJECT_PATH\frontend"
  
  try {
    docker compose down
    docker compose up -d --build
    Write-Host "✅ Frontend desplegado correctamente" -ForegroundColor Green
  }
  catch {
    Write-Host "❌ Error desplegando frontend: $_" -ForegroundColor Red
  }
  finally {
    Set-Location $PROJECT_PATH
  }
}

# Función para ver estado
function Get-Status {
  if (-not (Test-Docker)) { return }
  
  Write-Host "📊 Estado de los servicios:" -ForegroundColor Cyan
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# Función para ver logs del backend
function Get-BackendLogs {
  if (-not (Test-Docker)) { return }
  
  Write-Host "📋 Logs del backend:" -ForegroundColor Cyan
  Set-Location "$PROJECT_PATH\backend"
  docker compose logs -f
}

# Función para ver logs del frontend
function Get-FrontendLogs {
  if (-not (Test-Docker)) { return }
  
  Write-Host "📋 Logs del frontend:" -ForegroundColor Cyan
  Set-Location "$PROJECT_PATH\frontend"
  docker compose logs -f
}

# Función para health check del backend
function Test-BackendHealth {
  Write-Host "🏥 Verificando health del backend..." -ForegroundColor Cyan
  try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/api/health" -Method GET -TimeoutSec 10
    Write-Host "✅ Backend saludable: $($response | ConvertTo-Json)" -ForegroundColor Green
  }
  catch {
    Write-Host "❌ Backend no responde: $_" -ForegroundColor Red
  }
}

# Función para reiniciar backend
function Restart-Backend {
  if (-not (Test-Docker)) { return }
  
  Write-Host "🔄 Reiniciando backend..." -ForegroundColor Yellow
  Set-Location "$PROJECT_PATH\backend"
  docker compose restart
  Set-Location $PROJECT_PATH
}

# Función para reiniciar frontend
function Restart-Frontend {
  if (-not (Test-Docker)) { return }
  
  Write-Host "🔄 Reiniciando frontend..." -ForegroundColor Yellow
  Set-Location "$PROJECT_PATH\frontend"
  docker compose restart
  Set-Location $PROJECT_PATH
}

# Función para detener todos los servicios
function Stop-AllServices {
  if (-not (Test-Docker)) { return }
  
  Write-Host "🛑 Deteniendo todos los servicios..." -ForegroundColor Yellow
  Set-Location "$PROJECT_PATH\backend"
  docker compose down
  Set-Location "$PROJECT_PATH\frontend"
  docker compose down
  Set-Location $PROJECT_PATH
  Write-Host "✅ Todos los servicios detenidos" -ForegroundColor Green
}

# Función para limpiar todo
function Clear-All {
  if (-not (Test-Docker)) { return }
  
  Write-Host "🧹 Limpiando contenedores y volúmenes..." -ForegroundColor Yellow
  docker system prune -f
  docker volume prune -f
  Write-Host "✅ Limpieza completada" -ForegroundColor Green
}

# Función para ejecutar tests del backend
function Test-Backend {
  Write-Host "🧪 Ejecutando tests del backend..." -ForegroundColor Yellow
  Set-Location "$PROJECT_PATH\backend"
  
  try {
    npm test
    Write-Host "✅ Tests del backend completados" -ForegroundColor Green
  }
  catch {
    Write-Host "❌ Error en tests del backend: $_" -ForegroundColor Red
  }
  finally {
    Set-Location $PROJECT_PATH
  }
}

# Función para ejecutar tests del frontend
function Test-Frontend {
  Write-Host "🧪 Ejecutando tests del frontend..." -ForegroundColor Yellow
  Set-Location "$PROJECT_PATH\frontend"
  
  try {
    flutter test
    Write-Host "✅ Tests del frontend completados" -ForegroundColor Green
  }
  catch {
    Write-Host "❌ Error en tests del frontend: $_" -ForegroundColor Red
  }
  finally {
    Set-Location $PROJECT_PATH
  }
}

# Switch principal
switch ($Command.ToLower()) {
  "build-backend" { Build-Backend }
  "build-frontend" { Build-Frontend }
  "deploy-backend" { Deploy-Backend }
  "deploy-frontend" { Deploy-Frontend }
  "deploy-all" { 
    Deploy-Backend
    Start-Sleep -Seconds 5
    Deploy-Frontend
  }
  "status" { Get-Status }
  "logs-backend" { Get-BackendLogs }
  "logs-frontend" { Get-FrontendLogs }
  "health-backend" { Test-BackendHealth }
  "restart-backend" { Restart-Backend }
  "restart-frontend" { Restart-Frontend }
  "stop-all" { Stop-AllServices }
  "clean-all" { Clear-All }
  "test-backend" { Test-Backend }
  "test-frontend" { Test-Frontend }
  "help" { Show-Help }
  default {
    Write-Host "❌ Comando '$Command' no reconocido" -ForegroundColor Red
    Write-Host "Usa 'help' para ver comandos disponibles" -ForegroundColor Yellow
  }
}
