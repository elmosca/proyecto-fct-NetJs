# Script completo para corregir errores de null safety en Flutter
# Este script aborda todos los patrones de null safety identificados

Write-Host "Corrigiendo errores de null safety completos..." -ForegroundColor Yellow

# Función para procesar un archivo
function Fix-NullSafetyInFile {
  param([string]$FilePath)
    
  $content = Get-Content $FilePath -Raw
  $originalContent = $content
  $changesMade = $false
    
  # Patrón 1: AppLocalizations.of(context) sin !
  if ($content -match 'AppLocalizations\.of\(context\)\.(\w+)') {
    $content = $content -replace 'AppLocalizations\.of\(context\)\.(\w+)', 'AppLocalizations.of(context)!.$1'
    $changesMade = $true
  }
    
  # Patrón 2: AppLocalizations? como parámetro
  if ($content -match 'AppLocalizations\?') {
    $content = $content -replace 'AppLocalizations\?', 'AppLocalizations'
    $changesMade = $true
  }
    
  # Patrón 3: Propiedades que no pueden ser null (remover ??)
  $nonNullableProperties = @(
    'title', 'description', 'priority', 'complexity', 'estimatedHours',
    'assignUsers', 'assignUserToTask', 'createExport', 'exportTitle',
    'titleRequired', 'exportDescription', 'exportFormat', 'cancel',
    'create', 'createMilestone', 'descriptionRequired', 'milestoneNumber',
    'plannedDate', 'milestoneType', 'milestoneStatus', 'projectId',
    'milestoneId', 'createdById', 'kanbanPosition', 'assignees',
    'dependents', 'deletedAt', 'id', 'name', 'email', 'role',
    'status', 'type', 'format', 'filters', 'schedule', 'createdAt',
    'updatedAt', 'dueDate', 'startDate', 'endDate', 'completedAt',
    'assignedUserId', 'createdByUserId', 'tags', 'dependencies',
    'comments', 'attachments', 'history', 'notifications'
  )
    
  foreach ($prop in $nonNullableProperties) {
    if ($content -match "(\w+)\.$prop\?\?") {
      $content = $content -replace "(\w+)\.$prop\?\?", "`$1.$prop"
      $changesMade = $true
    }
  }
    
  # Patrón 4: Propiedades que pueden ser null pero se usan sin verificación
  $nullableProperties = @(
    'assignUsers', 'assignUserToTask', 'createExport', 'createMilestone'
  )
    
  foreach ($prop in $nullableProperties) {
    $pattern = "(\w+)\.$prop\s*\("
    $replacement = "`$1.$prop?.("
    if ($content -match $pattern) {
      $content = $content -replace $pattern, $replacement
      $changesMade = $true
    }
  }
    
  if ($changesMade) {
    Set-Content -Path $FilePath -Value $content -NoNewline
    Write-Host "Corregido: $FilePath" -ForegroundColor Green
    return $true
  }
    
  return $false
}

# Procesar todos los archivos Dart
$dartFiles = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart"
$fixedCount = 0

foreach ($file in $dartFiles) {
  if (Fix-NullSafetyInFile -FilePath $file.FullName) {
    $fixedCount++
  }
}

Write-Host "Proceso completado. $fixedCount archivos corregidos." -ForegroundColor Green
