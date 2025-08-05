# Script para limpiar archivos generados por Flutter de forma segura (PowerShell)
# Uso: .\clean_generated_files.ps1

Write-Host "�� Limpiando archivos generados por Flutter..." -ForegroundColor Cyan

# Lista de archivos generados que SÍ se pueden eliminar del tracking
$generatedFiles = @(
    "frontend/.flutter-plugins-dependencies",
    "frontend/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java",
    "frontend/android/local.properties"
)

# Lista de archivos importantes que NO se deben eliminar
$importantFiles = @(
    "frontend/DEVELOPMENT_CHECKLIST.md",
    "frontend/FRONTEND_DEVELOPMENT_GUIDE.md", 
    "frontend/PROJECT_CONTEXT.md",
    "frontend/assets/i18n/app_es.arb",
    "frontend/cspell.json",
    "frontend/.gitignore"
)

Write-Host "�� Archivos generados que se eliminarán del tracking:" -ForegroundColor Yellow
foreach ($file in $generatedFiles) {
    Write-Host "  - $file" -ForegroundColor Gray
}

Write-Host "🛡️ Archivos importantes que se mantienen protegidos:" -ForegroundColor Green
foreach ($file in $importantFiles) {
    Write-Host "  - $file" -ForegroundColor Gray
}

# Confirmar antes de proceder
$confirmation = Read-Host "¿Continuar con la limpieza? (y/N)"
if ($confirmation -ne "y" -and $confirmation -ne "Y") {
    Write-Host "❌ Operación cancelada" -ForegroundColor Red
    exit 0
}

# Eliminar archivos generados del tracking
Write-Host "🗑️ Eliminando archivos generados del tracking..." -ForegroundColor Yellow
foreach ($file in $generatedFiles) {
    if (git ls-files --error-unmatch $file 2>$null) {
        git rm --cached $file
        Write-Host "  ✅ $file eliminado del tracking" -ForegroundColor Green
    }
    else {
        Write-Host "  ⚠️ $file ya no está en tracking" -ForegroundColor Yellow
    }
}

# Verificar que los archivos importantes siguen protegidos
Write-Host "🔍 Verificando protección de archivos importantes..." -ForegroundColor Cyan
foreach ($file in $importantFiles) {
    if (git ls-files --error-unmatch $file 2>$null) {
        Write-Host "  ✅ $file protegido" -ForegroundColor Green
    }
    else {
        Write-Host "  ❌ $file NO está protegido - REQUIERE ATENCIÓN" -ForegroundColor Red
    }
}

Write-Host "✅ Limpieza completada!" -ForegroundColor Green
Write-Host "�� Los archivos generados se regenerarán automáticamente con:" -ForegroundColor Cyan
Write-Host "   flutter pub get" -ForegroundColor Gray
Write-Host "   flutter build" -ForegroundColor Gray