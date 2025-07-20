# Script de inicialización rápida para el proyecto FCT (Windows)
# Uso: .\setup.ps1

param(
    [switch]$SkipTests = $false
)

Write-Host "🚀 Configurando proyecto FCT..." -ForegroundColor Green

# Función para imprimir mensajes con colores
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Verificar requisitos previos
function Test-Requirements {
    Write-Status "Verificando requisitos previos..."
    
    $missingRequirements = @()
    
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        $missingRequirements += "Node.js 18+ (https://nodejs.org)"
    }
    
    if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
        $missingRequirements += "Flutter (https://flutter.dev)"
    }
    
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        $missingRequirements += "Docker (https://docker.com)"
    }
    
    if ($missingRequirements.Count -gt 0) {
        Write-Error "Faltan los siguientes requisitos:"
        $missingRequirements | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
        exit 1
    }
    
    Write-Status "✅ Todos los requisitos están instalados"
}

# Configurar backend
function Set-Backend {
    Write-Status "Configurando backend..."
    
    Push-Location backend
    
    try {
        # Instalar dependencias
        Write-Status "Instalando dependencias del backend..."
        npm install
        
        # Configurar variables de entorno
        if (-not (Test-Path .env)) {
            Write-Status "Creando archivo .env..."
            Copy-Item .env.example .env
            Write-Warning "⚠️  Edita backend\.env con tus configuraciones antes de continuar"
        }
        
        # Iniciar base de datos
        Write-Status "Iniciando base de datos con Docker..."
        docker-compose up -d
        
        # Esperar a que la DB esté lista
        Write-Status "Esperando a que la base de datos esté lista..."
        Start-Sleep -Seconds 10
        
        # Ejecutar migraciones y seeds
        Write-Status "Ejecutando migraciones..."
        try {
            npm run migration:run
        }
        catch {
            Write-Warning "Migraciones fallaron o no configuradas"
        }
        
        Write-Status "Ejecutando seeds..."
        try {
            npm run seed
        }
        catch {
            Write-Warning "Seeds fallaron o no configurados"
        }
    }
    finally {
        Pop-Location
    }
}

# Configurar frontend
function Set-Frontend {
    Write-Status "Configurando frontend..."
    
    Push-Location frontend
    
    try {
        # Instalar dependencias
        Write-Status "Instalando dependencias de Flutter..."
        flutter pub get
        
        # Generar código
        Write-Status "Generando código con build_runner..."
        flutter packages pub run build_runner build --delete-conflicting-outputs
    }
    finally {
        Pop-Location
    }
}

# Ejecutar tests
function Invoke-Tests {
    if ($SkipTests) {
        Write-Status "Saltando tests..."
        return
    }
    
    Write-Status "Ejecutando tests..."
    
    # Tests del backend
    Write-Status "Ejecutando tests del backend..."
    Push-Location backend
    try {
        npm test
    }
    catch {
        Write-Warning "Algunos tests del backend fallaron"
    }
    finally {
        Pop-Location
    }
    
    # Tests del frontend
    Write-Status "Ejecutando tests del frontend..."
    Push-Location frontend
    try {
        flutter test
    }
    catch {
        Write-Warning "Algunos tests del frontend fallaron"
    }
    finally {
        Pop-Location
    }
}

# Mostrar información final
function Show-FinalInfo {
    Write-Status "🎉 Configuración completada!"
    Write-Host ""
    Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "1. Abre el proyecto en VS Code"
    Write-Host "2. Instala las extensiones recomendadas"
    Write-Host "3. Edita backend\.env con tus configuraciones"
    Write-Host ""
    Write-Host "🚀 Para iniciar el desarrollo:" -ForegroundColor Cyan
    Write-Host "Backend:  cd backend && npm run start:dev"
    Write-Host "Frontend: cd frontend && flutter run"
    Write-Host ""
    Write-Host "📖 Para más información, lee CONTRIBUTING.md"
}

# Función principal
function Main {
    try {
        Test-Requirements
        Set-Backend
        Set-Frontend
        Invoke-Tests
        Show-FinalInfo
    }
    catch {
        Write-Error "Error durante la configuración: $_"
        exit 1
    }
}

# Ejecutar función principal
Main
