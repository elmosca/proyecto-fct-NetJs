# Script simplificado para verificar el estado de archivos en Git
# Uso: .\verify_git_state_simple.ps1

Write-Host " Verificando estado de archivos en Git..." -ForegroundColor Cyan

# Archivos generados que NO deberían estar en Git
$generatedFiles = @(
    "frontend/.flutter-plugins-dependencies",
    "frontend/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java",
    "frontend/android/local.properties"
)

# Archivos importantes que SÍ deben estar en Git
$importantFiles = @(
    "frontend/DEVELOPMENT_CHECKLIST.md",
    "frontend/FRONTEND_DEVELOPMENT_GUIDE.md",
    "frontend/PROJECT_CONTEXT.md",
    "frontend/assets/i18n/app_es.arb",
    "frontend/cspell.json",
    "frontend/.gitignore"
)

Write-Host "📋 Verificando archivos generados..." -ForegroundColor Yellow
$generatedInGit = @()
foreach ($file in $generatedFiles) {
    $exists = git ls-files $file 2>$null
    if ($exists) {
        $generatedInGit += $file
        Write-Host "  ❌ $file está en Git (NO debería)" -ForegroundColor Red
    }
    else {
        Write-Host "  ✅ $file NO está en Git (correcto)" -ForegroundColor Green
    }
}

Write-Host "🛡️ Verificando archivos importantes..." -ForegroundColor Yellow
$importantMissing = @()
foreach ($file in $importantFiles) {
    $exists = git ls-files $file 2>$null
    if ($exists) {
        Write-Host "  ✅ $file está protegido" -ForegroundColor Green
    }
    else {
        $importantMissing += $file
        Write-Host "  ❌ $file NO está protegido (CRÍTICO)" -ForegroundColor Red
    }
}

# Resumen
Write-Host "`n Resumen del estado:" -ForegroundColor Cyan

if ($generatedInGit.Count -eq 0) {
    Write-Host "✅ No hay archivos generados en Git" -ForegroundColor Green
}
else {
    Write-Host "⚠️ Archivos generados en Git que requieren limpieza:" -ForegroundColor Yellow
    foreach ($file in $generatedInGit) {
        Write-Host "  - $file" -ForegroundColor Gray
    }
    Write-Host "💡 Ejecutar: .\scripts\clean_generated_files.ps1" -ForegroundColor Cyan
}

if ($importantMissing.Count -eq 0) {
    Write-Host "✅ Todos los archivos importantes están protegidos" -ForegroundColor Green
}
else {
    Write-Host "🚨 Archivos importantes faltantes:" -ForegroundColor Red
    foreach ($file in $importantMissing) {
        Write-Host "  - $file" -ForegroundColor Gray
    }
    Write-Host "💡 Ejecutar: .\scripts\restore_docs.ps1" -ForegroundColor Cyan
}

# Estado general
if ($generatedInGit.Count -eq 0 -and $importantMissing.Count -eq 0) {
    Write-Host " Estado de Git: PERFECTO" -ForegroundColor Green
}
elseif ($importantMissing.Count -eq 0) {
    Write-Host "⚠️ Estado de Git: Requiere limpieza" -ForegroundColor Yellow
}
else {
    Write-Host " Estado de Git: CRÍTICO - Requiere atención inmediata" -ForegroundColor Red
} 