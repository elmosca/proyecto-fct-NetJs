# Script para recuperar documentos de seguimiento del proyecto (PowerShell)
# Uso: .\restore_docs.ps1 [commit_hash]

param(
    [string]$CommitHash = "0af93a5"  # Commit por defecto donde están los docs
)

Write-Host "🔄 Recuperando documentos de seguimiento desde commit: $CommitHash" -ForegroundColor Cyan

# Recuperar DEVELOPMENT_CHECKLIST.md
Write-Host "📋 Recuperando DEVELOPMENT_CHECKLIST.md..." -ForegroundColor Yellow
git show "$CommitHash`:frontend/DEVELOPMENT_CHECKLIST.md" > DEVELOPMENT_CHECKLIST.md

# Recuperar FRONTEND_DEVELOPMENT_GUIDE.md
Write-Host "📚 Recuperando FRONTEND_DEVELOPMENT_GUIDE.md..." -ForegroundColor Yellow
git show "$CommitHash`:frontend/FRONTEND_DEVELOPMENT_GUIDE.md" > FRONTEND_DEVELOPMENT_GUIDE.md

# Verificar que los archivos se recuperaron
if ((Test-Path "DEVELOPMENT_CHECKLIST.md") -and (Test-Path "FRONTEND_DEVELOPMENT_GUIDE.md")) {
    Write-Host "✅ Documentos recuperados exitosamente!" -ForegroundColor Green
    Write-Host "📁 Archivos disponibles:" -ForegroundColor Cyan
    Get-ChildItem *.md | Format-Table Name, Length, LastWriteTime
}
else {
    Write-Host "❌ Error al recuperar documentos" -ForegroundColor Red
    exit 1
}

Write-Host "🎯 Documentos listos para usar en el desarrollo" -ForegroundColor Green