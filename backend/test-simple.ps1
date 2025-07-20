# Test simple de conectividad al servidor
param(
    [string]$BaseUrl = "http://localhost:3000"
)

Write-Host "🧪 PRUEBA SIMPLE DEL SERVIDOR" -ForegroundColor Blue
Write-Host "=================================" -ForegroundColor Blue

# Función para probar conexión
function Test-ServerConnection {
    param([string]$Url)
    
    try {
        Write-Host "  → Probando conexión a $Url..." -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri $Url -Method GET -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
        
        Write-Host "    ✅ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "    ✅ Servidor respondiendo correctamente" -ForegroundColor Green
        
        # Verificar headers de rate limiting
        $rateLimitPolicy = $response.Headers['X-RateLimit-Policy']
        $rateLimitApplied = $response.Headers['X-RateLimit-Applied']
        
        if ($rateLimitPolicy) {
            Write-Host "    ✅ Header X-RateLimit-Policy: $rateLimitPolicy" -ForegroundColor Green
        } else {
            Write-Host "    ⚠️  Header X-RateLimit-Policy no encontrado" -ForegroundColor Yellow
        }
        
        if ($rateLimitApplied) {
            Write-Host "    ✅ Header X-RateLimit-Applied: $rateLimitApplied" -ForegroundColor Green
        } else {
            Write-Host "    ⚠️  Header X-RateLimit-Applied no encontrado" -ForegroundColor Yellow
        }
        
        return $true
    }
    catch {
        Write-Host "    ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Verificar si hay algo escuchando en el puerto 3000
Write-Host "`n🔍 Verificando puerto 3000..." -ForegroundColor Yellow
$portCheck = netstat -an | findstr ":3000"
if ($portCheck) {
    Write-Host "  ✅ Puerto 3000 en uso:" -ForegroundColor Green
    Write-Host "    $portCheck" -ForegroundColor Gray
} else {
    Write-Host "  ❌ Puerto 3000 no está en uso" -ForegroundColor Red
    Write-Host "  💡 El servidor probablemente no está corriendo" -ForegroundColor Yellow
}

# Probar conexión al servidor
Write-Host "`n🌐 Probando conexión HTTP..." -ForegroundColor Yellow
$connectionSuccess = Test-ServerConnection -Url $BaseUrl

if ($connectionSuccess) {
    Write-Host "`n🎉 ¡Servidor funcionando correctamente!" -ForegroundColor Green
} else {
    Write-Host "`n💔 Servidor no disponible" -ForegroundColor Red
    Write-Host "  Asegúrate de que el servidor NestJS esté corriendo con:" -ForegroundColor Yellow
    Write-Host "  npm run start:dev" -ForegroundColor Gray
}

Write-Host "`n=================================" -ForegroundColor Blue 