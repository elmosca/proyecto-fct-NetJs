# Script de prueba para Rate Limiting
# Ejecutar con: .\test-rate-limiting.ps1

Write-Host "🚦 TESTING RATE LIMITING" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

$baseUrl = "http://localhost:3000"

# Función para hacer requests con manejo de errores
function Invoke-TestRequest {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Body = @{},
        [string]$Description = ""
    )
    
    try {
        if ($Description) {
            Write-Host "  → $Description" -ForegroundColor Cyan
        }
        
        $requestParams = @{
            Uri = $Url
            Method = $Method
            UseBasicParsing = $true
            ErrorAction = 'SilentlyContinue'
        }
        
        if ($Method -eq "POST" -and $Body.Count -gt 0) {
            $requestParams['Body'] = ($Body | ConvertTo-Json)
            $requestParams['ContentType'] = 'application/json'
        }
        
        $response = Invoke-WebRequest @requestParams
        
        # Verificar headers de rate limiting
        $rateLimitPolicy = $response.Headers['X-RateLimit-Policy']
        $rateLimitApplied = $response.Headers['X-RateLimit-Applied']
        
        Write-Host "    Status: $($response.StatusCode)" -ForegroundColor Green
        
        if ($rateLimitPolicy) {
            Write-Host "    ✅ Header X-RateLimit-Policy: $rateLimitPolicy" -ForegroundColor Green
        }
        
        if ($rateLimitApplied) {
            Write-Host "    ✅ Header X-RateLimit-Applied: $rateLimitApplied" -ForegroundColor Green
        }
        
        return @{
            Success = $true
            StatusCode = $response.StatusCode
            Headers = $response.Headers
        }
    }
    catch {
        $statusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { 500 }
        
        if ($statusCode -eq 429) {
            Write-Host "    ❌ BLOQUEADO (429 Too Many Requests)" -ForegroundColor Red
            
            # Intentar obtener el header Retry-After
            try {
                $retryAfter = $_.Exception.Response.Headers['Retry-After']
                if ($retryAfter) {
                    Write-Host "    ⏱️  Retry-After: $retryAfter segundos" -ForegroundColor Yellow
                }
            } catch { }
            
        } elseif ($statusCode -eq 0 -or $null -eq $statusCode) {
            Write-Host "    ❌ ERROR: No se puede conectar al servidor" -ForegroundColor Red
        } else {
            Write-Host "    ❌ ERROR: Status $statusCode" -ForegroundColor Red
        }
        
        return @{
            Success = $false
            StatusCode = $statusCode
            Error = $_.Exception.Message
        }
    }
}

# Test 1: Verificar que el servidor está funcionando
Write-Host "`n🧪 Test 1: Verificar servidor" -ForegroundColor Yellow
$serverTest = Invoke-TestRequest -Url "$baseUrl" -Description "GET /"

if (-not $serverTest.Success) {
    Write-Host "❌ El servidor no está funcionando. Abortando tests." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Servidor funcionando correctamente" -ForegroundColor Green

# Test 2: Probar rate limiting en autenticación (muy restrictivo)
Write-Host "`n🧪 Test 2: Rate limiting en autenticación (5 requests/min)" -ForegroundColor Yellow

$blockedCount = 0
$loginData = @{
    email = "test@example.com"
    password = "wrongpassword"
}

Write-Host "  Haciendo 6 requests de login para triggear rate limit..." -ForegroundColor Gray

for ($i = 1; $i -le 6; $i++) {
    $result = Invoke-TestRequest -Url "$baseUrl/auth/login" -Method "POST" -Body $loginData -Description "Request $i"
    
    if ($result.StatusCode -eq 429) {
        $blockedCount++
    }
    
    # Pequeña pausa entre requests
    Start-Sleep -Milliseconds 200
}

if ($blockedCount -gt 0) {
    Write-Host "✅ Rate limiting funcionando: $blockedCount requests bloqueadas" -ForegroundColor Green
} else {
    Write-Host "⚠️  Rate limiting NO detectado en /auth/login" -ForegroundColor Yellow
}

# Test 3: Probar rate limiting general
Write-Host "`n🧪 Test 3: Rate limiting general" -ForegroundColor Yellow

Write-Host "  Haciendo múltiples requests rápidas..." -ForegroundColor Gray

$generalBlockedCount = 0
for ($i = 1; $i -le 15; $i++) {
    $result = Invoke-TestRequest -Url "$baseUrl" -Description "Request $i"
    
    if ($result.StatusCode -eq 429) {
        $generalBlockedCount++
        break  # Salir al primer bloqueo
    }
    
    # Sin pausa para triggear más rápido el límite
}

if ($generalBlockedCount -gt 0) {
    Write-Host "✅ Rate limiting general funcionando" -ForegroundColor Green
} else {
    Write-Host "⚠️  Rate limiting general muy permisivo" -ForegroundColor Yellow
}

# Test 4: Verificar diferentes endpoints
Write-Host "`n🧪 Test 4: Verificar endpoints específicos" -ForegroundColor Yellow

$endpoints = @(
    @{ Path = "/auth/register"; Name = "Register (AuthThrottle)" },
    @{ Path = "/users"; Name = "Users" }
)

foreach ($endpoint in $endpoints) {
    Write-Host "  Probando $($endpoint.Name): $($endpoint.Path)" -ForegroundColor Gray
    
    $testData = @{ test = "data" }
    $result = Invoke-TestRequest -Url "$baseUrl$($endpoint.Path)" -Method "POST" -Body $testData
    
    Start-Sleep -Milliseconds 500
}

# Test 5: Recovery test
Write-Host "`n🧪 Test 5: Verificar recovery tras rate limit" -ForegroundColor Yellow
Write-Host "  Esperando 10 segundos para que expire el rate limit..." -ForegroundColor Gray

Start-Sleep -Seconds 10

$recoveryTest = Invoke-TestRequest -Url "$baseUrl" -Description "Recovery test"

if ($recoveryTest.Success) {
    Write-Host "✅ Recovery exitoso: requests funcionan de nuevo" -ForegroundColor Green
} else {
    Write-Host "❌ Recovery falló: requests siguen bloqueadas" -ForegroundColor Red
}

# Resumen final
Write-Host "`n" + "="*50 -ForegroundColor Blue
Write-Host "📊 RESUMEN DE TESTS" -ForegroundColor Blue
Write-Host "="*50 -ForegroundColor Blue

if ($serverTest.Success) {
    Write-Host "✅ Servidor funcionando" -ForegroundColor Green
} else {
    Write-Host "❌ Servidor con problemas" -ForegroundColor Red
}

if ($blockedCount -gt 0) {
    Write-Host "✅ Rate limiting de autenticación: FUNCIONANDO" -ForegroundColor Green
} else {
    Write-Host "⚠️  Rate limiting de autenticación: NO DETECTADO" -ForegroundColor Yellow
}

if ($generalBlockedCount -gt 0) {
    Write-Host "✅ Rate limiting general: FUNCIONANDO" -ForegroundColor Green
} else {
    Write-Host "⚠️  Rate limiting general: MUY PERMISIVO" -ForegroundColor Yellow
}

Write-Host "`n🎯 Tests completados!" -ForegroundColor Blue 