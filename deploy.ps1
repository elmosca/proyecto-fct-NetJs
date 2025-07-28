# =================================================
# Script de Despliegue PowerShell - Backend API TFG
# =================================================
# Uso: .\deploy.ps1 [environment] [action]
# Environments: local, staging, production
# Actions: build, start, stop, restart, logs, status

param(
    [string]$Environment = "local",
    [string]$Action = "start"
)

# Variables globales
$ProjectName = "tfg-backend"
$ComposeFile = ""
$EnvFile = ""

# Funciones de utilidad para colores
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Función para mostrar ayuda
function Show-Help {
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "🚀 Script de Despliegue - Backend API TFG" -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Uso: .\deploy.ps1 [environment] [action]"
    Write-Host ""
    Write-Host "Environments:"
    Write-Host "  local      - Desarrollo local (default)"
    Write-Host "  staging    - Entorno de pruebas"
    Write-Host "  production - Producción"
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  build      - Construir imágenes Docker"
    Write-Host "  start      - Iniciar servicios (default)"
    Write-Host "  stop       - Detener servicios"
    Write-Host "  restart    - Reiniciar servicios"
    Write-Host "  logs       - Mostrar logs en tiempo real"
    Write-Host "  status     - Mostrar estado de servicios"
    Write-Host "  health     - Verificar health de la API"
    Write-Host "  backup     - Crear backup de base de datos"
    Write-Host "  cleanup    - Limpiar recursos no utilizados"
    Write-Host ""
    Write-Host "Ejemplos:"
    Write-Host "  .\deploy.ps1 local start"
    Write-Host "  .\deploy.ps1 production build"
    Write-Host "  .\deploy.ps1 staging logs"
    Write-Host ""
}

# Configurar entorno
function Configure-Environment {
    switch ($Environment) {
        "local" {
            $script:ComposeFile = "docker-compose.yml"
            $script:EnvFile = ".env"
        }
        "staging" {
            $script:ComposeFile = "docker-compose.staging.yml"
            $script:EnvFile = ".env.staging"
        }
        "production" {
            $script:ComposeFile = "docker-compose.prod.yml"
            $script:EnvFile = ".env.production"
        }
        default {
            Write-Error "Entorno desconocido: $Environment"
            Show-Help
            exit 1
        }
    }

    # Verificar archivos necesarios
    if (-not (Test-Path $ComposeFile)) {
        Write-Error "Archivo compose no encontrado: $ComposeFile"
        exit 1
    }

    if (-not (Test-Path $EnvFile)) {
        Write-Warning "Archivo de entorno no encontrado: $EnvFile"
        Write-Info "Creando archivo de ejemplo..."
        Copy-Item ".env.example" $EnvFile
        Write-Warning "Por favor, edita $EnvFile con tus configuraciones"
    }

    Write-Info "Entorno: $Environment"
    Write-Info "Compose file: $ComposeFile"
    Write-Info "Env file: $EnvFile"
}

# Verificar prerrequisitos
function Test-Prerequisites {
    Write-Info "Verificando prerrequisitos..."

    # Verificar Docker
    try {
        $dockerVersion = docker --version 2>$null
        if (-not $dockerVersion) {
            throw "Docker no está instalado"
        }
    }
    catch {
        Write-Error "Docker no está instalado o no está en el PATH"
        exit 1
    }

    # Verificar Docker Compose
    try {
        $composeVersion = docker-compose --version 2>$null
        if (-not $composeVersion) {
            throw "Docker Compose no está instalado"
        }
    }
    catch {
        Write-Error "Docker Compose no está instalado o no está en el PATH"
        exit 1
    }

    # Verificar que Docker esté corriendo
    try {
        docker info 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "Docker no está corriendo"
        }
    }
    catch {
        Write-Error "Docker no está corriendo"
        exit 1
    }

    Write-Success "Prerrequisitos verificados"
}

# Construir imágenes
function Build-Images {
    Write-Info "Construyendo imágenes Docker..."
    
    docker-compose -f $ComposeFile --env-file $EnvFile build --no-cache
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Imágenes construidas exitosamente"
    }
    else {
        Write-Error "Error al construir imágenes"
        exit 1
    }
}

# Iniciar servicios
function Start-Services {
    Write-Info "Iniciando servicios..."
    
    docker-compose -f $ComposeFile --env-file $EnvFile up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Servicios iniciados"
        
        # Esperar a que la API esté lista
        Write-Info "Esperando a que la API esté disponible..."
        Start-Sleep -Seconds 10
        
        Test-Health
    }
    else {
        Write-Error "Error al iniciar servicios"
        exit 1
    }
}

# Detener servicios
function Stop-Services {
    Write-Info "Deteniendo servicios..."
    
    docker-compose -f $ComposeFile --env-file $EnvFile down
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Servicios detenidos"
    }
    else {
        Write-Error "Error al detener servicios"
        exit 1
    }
}

# Reiniciar servicios
function Restart-Services {
    Write-Info "Reiniciando servicios..."
    
    Stop-Services
    Start-Sleep -Seconds 5
    Start-Services
}

# Mostrar logs
function Show-Logs {
    Write-Info "Mostrando logs en tiempo real (Ctrl+C para salir)..."
    
    docker-compose -f $ComposeFile --env-file $EnvFile logs -f
}

# Mostrar estado
function Show-Status {
    Write-Info "Estado de los servicios:"
    
    docker-compose -f $ComposeFile --env-file $EnvFile ps
    
    Write-Host ""
    Write-Info "Uso de recursos:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# Verificar health
function Test-Health {
    Write-Info "Verificando estado de salud de la API..."
    
    # Obtener puerto de la API
    $apiPort = 3000
    if (Test-Path $EnvFile) {
        $envContent = Get-Content $EnvFile
        $portLine = $envContent | Where-Object { $_ -match "^API_PORT=" }
        if ($portLine) {
            $apiPort = ($portLine -split "=")[1].Trim().Trim('"')
        }
    }
    
    # Verificar health endpoint
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$apiPort/api/auth/me" -Method GET -TimeoutSec 10 -UseBasicParsing
        Write-Success "API está respondiendo correctamente en puerto $apiPort"
    }
    catch {
        Write-Warning "API no está respondiendo o no tiene endpoint de health"
        Write-Info "Verificando que el puerto esté abierto..."
        
        # Verificar puerto con Test-NetConnection
        $connection = Test-NetConnection -ComputerName localhost -Port $apiPort -WarningAction SilentlyContinue
        if ($connection.TcpTestSucceeded) {
            Write-Success "Puerto $apiPort está abierto"
        }
        else {
            Write-Error "Puerto $apiPort no está disponible"
            return $false
        }
    }
    
    # Verificar estado de contenedores
    Write-Info "Estado de contenedores:"
    docker-compose -f $ComposeFile --env-file $EnvFile ps
    
    return $true
}

# Crear backup
function New-Backup {
    Write-Info "Creando backup de base de datos..."
    
    $backupDir = ".\backups"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = "$backupDir\tfg_backup_$timestamp.sql"
    
    # Crear directorio de backups si no existe
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    }
    
    # Obtener configuración de BD del archivo env
    $envContent = Get-Content $EnvFile
    $dbUser = ($envContent | Where-Object { $_ -match "^DB_USERNAME=" }) -replace "DB_USERNAME=", "" -replace '"', ''
    $dbName = ($envContent | Where-Object { $_ -match "^DB_DATABASE=" }) -replace "DB_DATABASE=", "" -replace '"', ''
    
    # Crear backup
    docker-compose -f $ComposeFile --env-file $EnvFile exec -T postgres pg_dump -U $dbUser $dbName > $backupFile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Backup creado: $backupFile"
        
        # Comprimir backup
        Compress-Archive -Path $backupFile -DestinationPath "$backupFile.zip" -Force
        Remove-Item $backupFile
        Write-Success "Backup comprimido: $backupFile.zip"
    }
    else {
        Write-Error "Error al crear backup"
        return $false
    }
    
    return $true
}

# Limpiar recursos
function Clear-Resources {
    Write-Info "Limpiando recursos no utilizados..."
    
    # Limpiar contenedores detenidos
    docker container prune -f
    
    # Limpiar imágenes no utilizadas
    docker image prune -f
    
    # Limpiar volúmenes no utilizados
    docker volume prune -f
    
    # Limpiar redes no utilizadas
    docker network prune -f
    
    Write-Success "Recursos limpiados"
}

# Función principal
function Main {
    # Mostrar banner
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "🚀 TFG Backend API - Deploy Script (PowerShell)" -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""

    # Verificar si se pidió ayuda
    if ($Environment -eq "help" -or $Environment -eq "-h" -or $Environment -eq "--help") {
        Show-Help
        return
    }

    # Configurar entorno
    Configure-Environment
    
    # Verificar prerrequisitos
    Test-Prerequisites
    
    # Ejecutar acción
    switch ($Action) {
        "build" {
            Build-Images
        }
        "start" {
            Start-Services
        }
        "stop" {
            Stop-Services
        }
        "restart" {
            Restart-Services
        }
        "logs" {
            Show-Logs
        }
        "status" {
            Show-Status
        }
        "health" {
            Test-Health
        }
        "backup" {
            New-Backup
        }
        "cleanup" {
            Clear-Resources
        }
        default {
            Write-Error "Acción desconocida: $Action"
            Show-Help
            return
        }
    }

    Write-Host ""
    Write-Success "¡Script completado exitosamente!"
}

# Ejecutar función principal
Main
