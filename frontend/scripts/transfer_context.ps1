#!/usr/bin/env pwsh
# Script para transferir contexto completo del proyecto a un nuevo chat
# Uso: .\scripts\transfer_context.ps1

Write-Host "🚀 Preparando transferencia de contexto del proyecto FCT" -ForegroundColor Cyan
Write-Host ""

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Error: Este script debe ejecutarse desde el directorio frontend/" -ForegroundColor Red
    exit 1
}

# Verificar que existe el archivo de contexto
if (-not (Test-Path "PROJECT_CONTEXT.md")) {
    Write-Host "❌ Error: No se encontró PROJECT_CONTEXT.md" -ForegroundColor Red
    exit 1
}

Write-Host "📋 Archivos de contexto disponibles:" -ForegroundColor Green
Write-Host ""

# Listar archivos de contexto
$contextFiles = @(
    "PROJECT_CONTEXT.md",
    "DEVELOPMENT_CHECKLIST.md", 
    "FRONTEND_DEVELOPMENT_GUIDE.md"
)

foreach ($file in $contextFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        $sizeKB = [math]::Round($size / 1KB, 1)
        Write-Host "✅ $file ($sizeKB KB)" -ForegroundColor Green
    } else {
        Write-Host "❌ $file (no encontrado)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎯 ESTRATEGIAS PARA NUEVO CHAT:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1️⃣ ESTRATEGIA RÁPIDA (Recomendada):" -ForegroundColor Cyan
Write-Host "   - Adjunta solo: PROJECT_CONTEXT.md"
Write-Host "   - Contiene: Todo el contexto esencial en un solo archivo"
Write-Host "   - Tamaño: ~$(Get-Item PROJECT_CONTEXT.md).Length bytes"
Write-Host ""

Write-Host "2️⃣ ESTRATEGIA COMPLETA:" -ForegroundColor Cyan
Write-Host "   - Adjunta: PROJECT_CONTEXT.md + DEVELOPMENT_CHECKLIST.md + FRONTEND_DEVELOPMENT_GUIDE.md"
Write-Host "   - Contiene: Contexto completo + seguimiento + guía técnica"
Write-Host "   - Tamaño: ~$((Get-Item PROJECT_CONTEXT.md, DEVELOPMENT_CHECKLIST.md, FRONTEND_DEVELOPMENT_GUIDE.md | Measure-Object -Property Length -Sum).Sum) bytes"
Write-Host ""

Write-Host "3️⃣ ESTRATEGIA SELECTIVA:" -ForegroundColor Cyan
Write-Host "   - Adjunta: Solo los archivos que necesites"
Write-Host "   - Útil para: Consultas específicas o problemas concretos"
Write-Host ""

Write-Host "📝 INSTRUCCIONES PARA NUEVO CHAT:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Crea un nuevo chat en Cursor"
Write-Host "2. Adjunta el archivo PROJECT_CONTEXT.md"
Write-Host "3. Escribe un mensaje como:" -ForegroundColor Green
Write-Host ""
Write-Host "   'Hola! Soy el desarrollador del proyecto FCT. Adjunto el contexto completo del proyecto.'"
Write-Host "   'Estamos en la Fase 5 - Gestión de Usuarios. Necesito ayuda con [tarea específica].'"
Write-Host ""

Write-Host "🔧 COMANDOS ÚTILES PARA EL NUEVO CHAT:" -ForegroundColor Yellow
Write-Host ""

Write-Host "# Ver estado actual"
Write-Host "git status"
Write-Host ""

Write-Host "# Ver ramas disponibles"
Write-Host "git branch"
Write-Host ""

Write-Host "# Ver progreso del proyecto"
Write-Host "cat DEVELOPMENT_CHECKLIST.md | Select-String 'Progreso total'"
Write-Host ""

Write-Host "# Ver tareas de la Fase 5"
Write-Host "cat DEVELOPMENT_CHECKLIST.md | Select-String 'Fase 5' -Context 10"
Write-Host ""

Write-Host "✅ Contexto preparado para transferencia!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Tip: El archivo PROJECT_CONTEXT.md contiene toda la información esencial"
Write-Host "   para que el nuevo chat entienda el estado completo del proyecto."