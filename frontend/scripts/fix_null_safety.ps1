# Script para corregir errores de null safety en Flutter
# Este script agrega el operador ! a las propiedades de AppLocalizations que no pueden ser null

Write-Host "🔧 Corrigiendo errores de null safety..." -ForegroundColor Yellow

# Función para procesar un archivo
function Fix-NullSafetyInFile {
  param([string]$FilePath)
    
  $content = Get-Content $FilePath -Raw
  $originalContent = $content
    
  # Patrones comunes de null safety que necesitan corrección
  $patterns = @(
    # AppLocalizations properties
    @{
      Pattern     = 'AppLocalizations\.of\(context\)\.(\w+)'
      Replacement = 'AppLocalizations.of(context)!.$1'
    },
    # Properties that can't be null
    @{
      Pattern     = '(\w+)\.title\?\?'
      Replacement = '$1.title'
    },
    @{
      Pattern     = '(\w+)\.description\?\?'
      Replacement = '$1.description'
    },
    @{
      Pattern     = '(\w+)\.priority\?\?'
      Replacement = '$1.priority'
    },
    @{
      Pattern     = '(\w+)\.complexity\?\?'
      Replacement = '$1.complexity'
    },
    @{
      Pattern     = '(\w+)\.estimatedHours\?\?'
      Replacement = '$1.estimatedHours'
    }
  )
    
  foreach ($pattern in $patterns) {
    $content = $content -replace $pattern.Pattern, $pattern.Replacement
  }
    
  if ($content -ne $originalContent) {
    Set-Content -Path $FilePath -Value $content -NoNewline
    Write-Host "✅ Corregido: $FilePath" -ForegroundColor Green
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

Write-Host "🎉 Proceso completado. $fixedCount archivos corregidos." -ForegroundColor Green
