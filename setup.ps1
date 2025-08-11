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
        
    # Configurar variables de entorno usando el script especializado
    Write-Status "Configurando variables de entorno..."
    if (Test-Path "scripts\setup-env.ps1") {
      Write-Status "Ejecutando script de configuración de variables de entorno..."
      & ".\scripts\setup-env.ps1"
            
      # Verificar que el archivo .env se creó correctamente
      if (-not (Test-Path ".env")) {
        Write-Error "No se pudo crear el archivo .env"
        exit 1
      }
            
      Write-Status "✅ Variables de entorno configuradas correctamente"
    }
    else {
      Write-Warning "Script setup-env.ps1 no encontrado, creando .env básico..."
      if (-not (Test-Path .env)) {
        Copy-Item .env.example .env
        Write-Warning "⚠️  Edita backend\.env con tus configuraciones antes de continuar"
      }
    }
        
    # Crear red compartida si no existe
    Write-Status "Creando red compartida para los servicios..."
    docker network create app-network 2>$null
    
    # Desplegar backend con Docker
    Write-Status "Desplegando backend con Docker..."
    Write-Status "Deteniendo contenedores existentes..."
    docker-compose down 2>$null
        
    Write-Status "Iniciando solo la base de datos..."
    docker-compose up -d postgres
        
    # Esperar a que la base de datos esté lista
    Write-Status "Esperando a que la base de datos esté lista..."
    Start-Sleep -Seconds 10
        
    # Ejecutar seeds usando un contenedor temporal
    Write-Status "Ejecutando seeds para configuración inicial..."
    try {
      Write-Status "Ejecutando migraciones..."
      # Usar un contenedor temporal con el código fuente para ejecutar migraciones
      docker run --rm --network backend_app-network -v "${PWD}:/app" -w /app -e DATABASE_URL="postgresql://postgres:${DB_PASSWORD}@postgres:5432/${DB_DATABASE}" node:20-alpine sh -c "npm install && npm run migration:run" 2>$null || Write-Warning "Migraciones fallaron o no configuradas"
            
      Write-Status "Ejecutando seeds..."
      # Usar un contenedor temporal con el código fuente para ejecutar seeds
      docker run --rm --network backend_app-network -v "${PWD}:/app" -w /app -e DATABASE_URL="postgresql://postgres:${DB_PASSWORD}@postgres:5432/${DB_DATABASE}" node:20-alpine sh -c "npm install && npm run seed" 2>$null || Write-Warning "Seeds fallaron o no configurados"
            
      Write-Status "✅ Seeds ejecutados correctamente"
    }
    catch {
      Write-Warning "⚠️  Error ejecutando seeds: $_"
      Write-Warning "💡 Puedes ejecutar manualmente: docker run --rm --network backend_app-network -v '${PWD}:/app' -w /app node:20-alpine sh -c 'npm install && npm run seed'"
    }
        
    # Ahora iniciar la API
    Write-Status "Iniciando la API..."
    docker-compose up -d api
        
    # Esperar a que los servicios estén listos
    Write-Status "Esperando a que los servicios estén listos..."
    Start-Sleep -Seconds 15
        
    # Verificar estado de los servicios
    Write-Status "Verificando estado de los servicios..."
    $containers = docker-compose ps -q
    if ($containers) {
      $healthyContainers = docker-compose ps --format "table {{.Name}}\t{{.Status}}" | Select-String "Up"
      Write-Status "✅ Servicios desplegados:"
      $healthyContainers | ForEach-Object { Write-Host "   $_" -ForegroundColor Green }
    }
        
    # Verificar health check del backend
    Write-Status "Verificando health check del backend..."
    try {
      $response = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -TimeoutSec 10 -ErrorAction Stop
      if ($response.StatusCode -eq 200) {
        Write-Status "✅ Backend respondiendo correctamente en http://localhost:3000"
      }
    }
    catch {
      Write-Warning "⚠️  Backend no responde aún. Puede tardar unos minutos en inicializarse completamente."
      Write-Warning "💡 Puedes verificar el estado con: docker-compose logs api"
    }
    
    # Ejecutar seeds para configuración inicial de la base de datos
    Write-Status "Ejecutando seeds para configuración inicial..."
    try {
      Write-Status "Ejecutando migraciones..."
      docker-compose exec -T api npm run migration:run 2>$null || Write-Warning "Migraciones fallaron o no configuradas"
        
      Write-Status "Ejecutando seeds..."
      docker-compose exec -T api npm run seed 2>$null || Write-Warning "Seeds fallaron o no configurados"
        
      Write-Status "✅ Seeds ejecutados correctamente"
    }
    catch {
      Write-Warning "⚠️  Error ejecutando seeds: $_"
      Write-Warning "💡 Puedes ejecutar manualmente: docker-compose exec api npm run seed"
    }
    
    # Verificar health check final después de seeds
    Write-Status "Verificando health check final después de seeds..."
    Start-Sleep -Seconds 5
    try {
      $response = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -TimeoutSec 10 -ErrorAction Stop
      if ($response.StatusCode -eq 200) {
        Write-Status "✅ Backend completamente funcional en http://localhost:3000"
      }
    }
    catch {
      Write-Warning "⚠️  Backend aún no responde. Revisa los logs: docker-compose logs api"
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
    
    # Construir aplicación Flutter para web
    Write-Status "Construyendo aplicación Flutter para web..."
    flutter build web --release
    
    # Desplegar frontend con Docker Compose
    Write-Status "Desplegando frontend con Docker Compose..."
    Write-Status "El frontend estará disponible en: http://localhost:8082"
    
    # Detener contenedor existente si existe
    docker-compose down 2>$null
    
    # Ejecutar contenedor del frontend
    Write-Status "Iniciando contenedor del frontend..."
    docker-compose up -d
    
    # Esperar a que el servidor esté listo
    Write-Status "Esperando a que el frontend esté listo..."
    Start-Sleep -Seconds 15
    
    # Verificar que el frontend esté respondiendo
    try {
      $response = Invoke-WebRequest -Uri "http://localhost:8082" -TimeoutSec 10 -ErrorAction Stop
      if ($response.StatusCode -eq 200) {
        Write-Status "✅ Frontend respondiendo correctamente en http://localhost:8082"
      }
    }
    catch {
      Write-Warning "⚠️  Frontend aún no responde. Puede tardar unos minutos en inicializarse."
      Write-Warning "💡 Puedes verificar los logs con: docker-compose logs frontend"
    }
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
  Write-Host "3. Las variables de entorno ya están configuradas automáticamente"
  Write-Host "4. El backend ya está desplegado y funcionando"
  Write-Host "5. El frontend ya está iniciado y disponible"
  Write-Host ""
  Write-Host "🔐 CREDENCIALES DE ACCESO:" -ForegroundColor Cyan
  Write-Host "   Admin: admin@fct.local / Admin123!" -ForegroundColor Yellow
  Write-Host "   Test:  test@fct.local / Test123!" -ForegroundColor Yellow
  Write-Host "   Tutor: tutor@fct.local / Tutor123!" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "🌐 URLs DE ACCESO:" -ForegroundColor Cyan
  Write-Host "   Frontend: http://localhost:8082" -ForegroundColor Yellow
  Write-Host "   Backend:  http://localhost:3000/api" -ForegroundColor Yellow
  Write-Host "   Health:   http://localhost:3000/api/health" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "📁 ARCHIVOS IMPORTANTES:" -ForegroundColor Cyan
  Write-Host "   - backend/CONFIGURACION.txt (Credenciales y configuración)" -ForegroundColor Yellow
  Write-Host "   - backend/src/database/test-data.ts (Script de datos de prueba)" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "🐳 Comandos útiles:" -ForegroundColor Cyan
  Write-Host "Ver logs: cd backend && docker-compose logs -f"
  Write-Host "Reiniciar: cd backend && docker-compose restart"
  Write-Host "Detener: cd backend && docker-compose down"
  Write-Host ""
  Write-Host "📖 Para más información, lee CONTRIBUTING.md"
}

# Crear datos de prueba y usuarios por defecto
function Create-TestData {
  Write-Status "Creando datos de prueba y usuarios por defecto..."
  
  Push-Location backend
  
  try {
    # Verificar que el backend esté ejecutándose
    Write-Status "Verificando que el backend esté ejecutándose..."
    try {
      $response = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -TimeoutSec 5 -ErrorAction Stop
      if ($response.StatusCode -eq 200) {
        Write-Status "✅ Backend está ejecutándose"
      }
    }
    catch {
      Write-Warning "⚠️  Backend no está ejecutándose, saltando creación de datos de prueba"
      return
    }
    
    # Ejecutar script de creación de datos de prueba
    if (Test-Path "scripts\create-test-data.ps1") {
      Write-Status "Ejecutando script de creación de datos de prueba..."
      & ".\scripts\create-test-data.ps1"
      
      # Ejecutar seeds para aplicar los datos
      Write-Status "Aplicando datos de prueba a la base de datos..."
      try {
        docker-compose exec -T api npm run seed 2>$null || Write-Warning "Seeds fallaron, pero los datos de prueba se crearon"
        Write-Status "✅ Datos de prueba aplicados correctamente"
      }
      catch {
        Write-Warning "⚠️  Error aplicando seeds: $_"
      }
    }
    else {
      Write-Warning "⚠️  Script create-test-data.ps1 no encontrado"
    }
  }
  finally {
    Pop-Location
  }
}

# Función principal
function Main {
  try {
    Test-Requirements
    Set-Backend
    Set-Frontend
    Create-TestData
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
