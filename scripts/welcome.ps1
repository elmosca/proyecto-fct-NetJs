#!/usr/bin/env pwsh
# Script de bienvenida para el proyecto FCT NetJS
# Se ejecuta automáticamente al abrir el proyecto

Write-Host "🎉 ¡Bienvenido al Proyecto FCT NetJS!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "🔧 Entorno Híbrido Configurado:" -ForegroundColor Yellow
Write-Host "   • Windows: Desarrollo con Cursor" -ForegroundColor White
Write-Host "   • WSL: Servicios Docker" -ForegroundColor White
Write-Host "   • GitHub: Repositorio centralizado" -ForegroundColor White
Write-Host ""

Write-Host "📋 Comandos Disponibles:" -ForegroundColor Yellow
Write-Host "   • .\scripts\cursor-agent-helper.ps1 help" -ForegroundColor White
Write-Host "   • .\scripts\diagnose.ps1" -ForegroundColor White
Write-Host "   • .\scripts\cursor-agent-helper.ps1 deploy-backend" -ForegroundColor White
Write-Host ""

Write-Host "🎯 Próximos Pasos:" -ForegroundColor Yellow
Write-Host "   1. Ejecutar diagnóstico: .\scripts\diagnose.ps1" -ForegroundColor White
Write-Host "   2. Desplegar backend: .\scripts\cursor-agent-helper.ps1 deploy-backend" -ForegroundColor White
Write-Host "   3. Verificar health: .\scripts\cursor-agent-helper.ps1 health-backend" -ForegroundColor White
Write-Host ""

Write-Host "📚 Documentación:" -ForegroundColor Yellow
Write-Host "   • QUICK_START.md - Guía de inicio rápido" -ForegroundColor White
Write-Host "   • .cursorrules - Reglas para el agente de Cursor" -ForegroundColor White
Write-Host "   • PROJECT_NOTES.md - Notas del proyecto" -ForegroundColor White
Write-Host ""

Write-Host "🚀 ¿Empezamos?" -ForegroundColor Green
Write-Host "   Ejecuta: .\scripts\diagnose.ps1" -ForegroundColor Cyan
Write-Host ""
