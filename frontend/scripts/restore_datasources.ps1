# Descripción: Script de PowerShell para restaurar el directorio 'datasources' desde un commit específico.
# Uso: .\scripts\restore_datasources.ps1 [commit_hash]

param (
    [string]$CommitHash = "0af93a5" # Commit por defecto donde los datasources existen
)

$ProjectRoot = (Get-Location).Path
$TargetDir = Join-Path $ProjectRoot "frontend\lib\features\anteprojects\data\datasources"
$GitPath = "frontend/lib/features/anteprojects/data/datasources"

Write-Host "Restaurando el directorio '$GitPath' desde el commit '$CommitHash'..."

# Asegurarse de que el directorio de destino exista y esté vacío para evitar conflictos
if (Test-Path $TargetDir) {
    Write-Host "El directorio de destino existe. Limpiando..."
    Remove-Item -Recurse -Force $TargetDir
}
New-Item -ItemType Directory -Force $TargetDir | Out-Null

# Usar git archive para extraer el contenido y tar para descomprimirlo
try {
    git archive --format=tar --remote=origin $CommitHash -- "$GitPath" | tar -x -C $TargetDir
    Write-Host "Éxito: El directorio '$GitPath' ha sido restaurado."
    Write-Host "Contenido restaurado en: $TargetDir"
}
catch {
    Write-Error "Error: No se pudo restaurar el directorio. Verifica que el commit '$CommitHash' y la ruta '$GitPath' son correctos."
    exit 1
}

Write-Host "Operación completada."
