#!/usr/bin/env pwsh
# Script de diagnóstico para el agente de Cursor
# Uso: .\scripts\diagnose.ps1

Write-Host "🔍 Diagnóstico del Proyecto FCT NetJS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Configuración
$WSL_PATH = "/home/jualas/proyectos/proyecto-fct-NetJs"
$WINDOWS_PATH = "C:\dev\proyecto-fct-NetJs"

# Función para verificar WSL
function Test-WSL {
  Write-Host "🔧 Verificando WSL..." -ForegroundColor Yellow
  try {
    $null = wsl echo "test" 2>$null
    Write-Host "✅ WSL está disponible" -ForegroundColor Green
    return $true
  }
  catch {
    Write-Host "❌ WSL no está disponible" -ForegroundColor Red
    return $false
  }
}

# Función para verificar Docker en WSL
function Test-Docker {
  Write-Host "🐳 Verificando Docker en WSL..." -ForegroundColor Yellow
  try {
    $dockerVersion = wsl docker --version 2>$null
    if ($dockerVersion) {
      Write-Host "✅ Docker disponible: $dockerVersion" -ForegroundColor Green
      return $true
    }
    else {
      Write-Host "❌ Docker no está disponible en WSL" -ForegroundColor Red
      return $false
    }
  }
  catch {
    Write-Host "❌ Error verificando Docker" -ForegroundColor Red
    return $false
  }
}

# Función para verificar servicios
function Test-Services {
  Write-Host "📊 Verificando servicios..." -ForegroundColor Yellow
  try {
    $services = wsl docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>$null
    if ($services) {
      Write-Host "✅ Servicios encontrados:" -ForegroundColor Green
      Write-Host $services -ForegroundColor Gray
    }
    else {
      Write-Host "⚠️  No hay servicios corriendo" -ForegroundColor Yellow
    }
  }
  catch {
    Write-Host "❌ Error verificando servicios" -ForegroundColor Red
  }
}

# Función para verificar health del backend
function Test-BackendHealth {
  Write-Host "🏥 Verificando health del backend..." -ForegroundColor Yellow
  try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/api/health" -Method Get -TimeoutSec 5
    Write-Host "✅ Backend saludable: $($response | ConvertTo-Json)" -ForegroundColor Green
    return $true
  }
  catch {
    Write-Host "❌ Backend no responde: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
}

# Función para verificar archivos críticos
function Test-CriticalFiles {
  Write-Host "📁 Verificando archivos críticos..." -ForegroundColor Yellow
    
  $criticalFiles = @(
    "backend\src\app.module.ts",
    "backend\src\app.controller.ts", 
    "backend\src\main.ts",
    "backend\docker-compose.yml",
    "scripts\cursor-agent-helper.ps1",
    "scripts\sync-to-wsl.ps1",
    "scripts\quick-deploy.ps1"
  )
    
  foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
      Write-Host "✅ $file" -ForegroundColor Green
    }
    else {
      Write-Host "❌ $file (faltante)" -ForegroundColor Red
    }
  }
}

# Función para verificar AppController en AppModule
function Test-AppControllerRegistration {
  Write-Host "🔍 Verificando registro de AppController..." -ForegroundColor Yellow
  try {
    $appModuleContent = Get-Content "backend\src\app.module.ts" -Raw
    if ($appModuleContent -match "controllers:\s*\[.*AppController.*\]") {
      Write-Host "✅ AppController está registrado en AppModule" -ForegroundColor Green
      return $true
    }
    else {
      Write-Host "❌ AppController NO está registrado en AppModule" -ForegroundColor Red
      Write-Host "💡 Añade 'controllers: [AppController]' en AppModule" -ForegroundColor Yellow
      return $false
    }
  }
  catch {
    Write-Host "❌ Error verificando AppModule" -ForegroundColor Red
    return $false
  }
}

# Función para verificar sincronización
function Test-Sync {
  Write-Host "🔄 Verificando sincronización..." -ForegroundColor Yellow
  try {
    $windowsFiles = Get-ChildItem "$WINDOWS_PATH\backend\src" -Recurse -File | Measure-Object | Select-Object -ExpandProperty Count
    $wslFiles = wsl find $WSL_PATH/backend/src -type f | wc -l 2>$null
        
    if ($windowsFiles -eq $wslFiles) {
      Write-Host "✅ Sincronización correcta ($windowsFiles archivos)" -ForegroundColor Green
    }
    else {
      Write-Host "⚠️  Posible desincronización: Windows=$windowsFiles, WSL=$wslFiles" -ForegroundColor Yellow
    }
  }
  catch {
    Write-Host "❌ Error verificando sincronización" -ForegroundColor Red
  }
}

# Función para mostrar recomendaciones
function Show-Recommendations {
  Write-Host ""
  Write-Host "💡 RECOMENDACIONES:" -ForegroundColor Cyan
  Write-Host "==================" -ForegroundColor Cyan
    
  if (-not (Test-WSL)) {
    Write-Host "• Instala WSL: wsl --install" -ForegroundColor Yellow
  }
    
  if (-not (Test-Docker)) {
    Write-Host "• Instala Docker en WSL: curl -fsSL https://get.docker.com | sh" -ForegroundColor Yellow
  }
    
  if (-not (Test-BackendHealth)) {
    Write-Host "• Despliega el backend: .\scripts\cursor-agent-helper.ps1 deploy-backend" -ForegroundColor Yellow
  }
    
  if (-not (Test-AppControllerRegistration)) {
    Write-Host "• Registra AppController en AppModule" -ForegroundColor Yellow
  }
    
  Write-Host ""
  Write-Host "🔧 COMANDOS ÚTILES:" -ForegroundColor Cyan
  Write-Host "• Ver ayuda: .\scripts\cursor-agent-helper.ps1 help" -ForegroundColor White
  Write-Host "• Desplegar backend: .\scripts\cursor-agent-helper.ps1 deploy-backend" -ForegroundColor White
  Write-Host "• Ver logs: .\scripts\cursor-agent-helper.ps1 logs-backend" -ForegroundColor White
  Write-Host "• Verificar health: .\scripts\cursor-agent-helper.ps1 health-backend" -ForegroundColor White
}

# Ejecutar diagnóstico
Write-Host "🚀 Iniciando diagnóstico..." -ForegroundColor Green
Write-Host ""

Test-WSL
Write-Host ""

Test-Docker
Write-Host ""

Test-Services
Write-Host ""

Test-CriticalFiles
Write-Host ""

Test-AppControllerRegistration
Write-Host ""

Test-Sync
Write-Host ""

Test-BackendHealth
Write-Host ""

Show-Recommendations
