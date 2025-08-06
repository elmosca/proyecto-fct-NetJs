# Script PowerShell para encontrar cambios temporales en el proyecto Flutter
# Uso: .\scripts\find_temporary_changes.ps1

Write-Host "🔍 Buscando cambios temporales en el proyecto..." -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Buscar marcadores temporales
Write-Host "📋 Marcadores temporales encontrados:" -ForegroundColor Yellow
Write-Host "--------------------------------------" -ForegroundColor Yellow

$reviewNeeded = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Select-String "TODO: \[REVIEW_NEEDED\]"
if ($reviewNeeded) {
  $reviewNeeded | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
}
else {
  Write-Host "No se encontraron marcadores [REVIEW_NEEDED]" -ForegroundColor Gray
}
Write-Host ""

$temporary = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Select-String "TODO: \[TEMPORARY\]"
if ($temporary) {
  $temporary | ForEach-Object { Write-Host $_.Line -ForegroundColor Yellow }
}
else {
  Write-Host "No se encontraron marcadores [TEMPORARY]" -ForegroundColor Gray
}
Write-Host ""

$removed = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Select-String "TODO: \[REMOVED\]"
if ($removed) {
  $removed | ForEach-Object { Write-Host $_.Line -ForegroundColor Magenta }
}
else {
  Write-Host "No se encontraron marcadores [REMOVED]" -ForegroundColor Gray
}
Write-Host ""

# Buscar placeholders
Write-Host "🔄 Placeholders temporales:" -ForegroundColor Yellow
Write-Host "---------------------------" -ForegroundColor Yellow
$placeholders = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Select-String "TEMPORAL|PLACEHOLDER"
if ($placeholders) {
  $placeholders | ForEach-Object { Write-Host $_.Line -ForegroundColor Blue }
}
else {
  Write-Host "No se encontraron placeholders" -ForegroundColor Gray
}
Write-Host ""

# Buscar código comentado
Write-Host "💬 Código comentado temporalmente:" -ForegroundColor Yellow
Write-Host "----------------------------------" -ForegroundColor Yellow
$todos = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Select-String "// TODO:"
if ($todos) {
  $todos | ForEach-Object { Write-Host $_.Line -ForegroundColor Green }
}
else {
  Write-Host "No se encontraron TODOs" -ForegroundColor Gray
}
Write-Host ""

# Resumen
Write-Host "📊 Resumen:" -ForegroundColor Yellow
Write-Host "-----------" -ForegroundColor Yellow
Write-Host "Archivos con cambios temporales:" -ForegroundColor Cyan

$filesWithChanges = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Where-Object {
  $content = Get-Content $_.FullName -Raw
  $content -match "TODO: \[REVIEW_NEEDED\]|TEMPORAL|PLACEHOLDER"
}

if ($filesWithChanges) {
  $filesWithChanges | ForEach-Object { Write-Host $_.Name -ForegroundColor White }
}
else {
  Write-Host "No se encontraron archivos con cambios temporales" -ForegroundColor Gray
}

Write-Host ""
Write-Host "✅ Búsqueda completada. Revisa TEMPORARY_CHANGES_LOG.md para más detalles." -ForegroundColor Green 