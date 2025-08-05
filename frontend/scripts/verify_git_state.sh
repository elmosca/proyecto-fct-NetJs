#!/bin/bash
# Script para verificar el estado de archivos en Git
# Uso: ./verify_git_state.sh

echo " Verificando estado de archivos en Git..."

# Archivos generados que NO deberían estar en Git
generated_files=(
    "frontend/.flutter-plugins-dependencies"
    "frontend/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java"
    "frontend/android/local.properties"
)

# Archivos importantes que SÍ deben estar en Git
important_files=(
    "frontend/DEVELOPMENT_CHECKLIST.md"
    "frontend/FRONTEND_DEVELOPMENT_GUIDE.md"
    "frontend/PROJECT_CONTEXT.md"
    "frontend/assets/i18n/app_es.arb"
    "frontend/cspell.json"
    "frontend/.gitignore"
)

echo "📋 Verificando archivos generados..."
generated_in_git=()
for file in "${generated_files[@]}"; do
    if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        generated_in_git+=("$file")
        echo "  ❌ $file está en Git (NO debería)"
    else
        echo "  ✅ $file NO está en Git (correcto)"
    fi
done

echo "🛡️ Verificando archivos importantes..."
important_missing=()
for file in "${important_files[@]}"; do
    if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        echo "  ✅ $file está protegido"
    else
        important_missing+=("$file")
        echo "  ❌ $file NO está protegido (CRÍTICO)"
    fi
done

# Resumen
echo ""
echo " Resumen del estado:"

if [ ${#generated_in_git[@]} -eq 0 ]; then
    echo "✅ No hay archivos generados en Git"
else
    echo "⚠️ Archivos generados en Git que requieren limpieza:"
    for file in "${generated_in_git[@]}"; do
        echo "  - $file"
    done
    echo "💡 Ejecutar: ./scripts/clean_generated_files.sh"
fi

if [ ${#important_missing[@]} -eq 0 ]; then
    echo "✅ Todos los archivos importantes están protegidos"
else
    echo "🚨 Archivos importantes faltantes:"
    for file in "${important_missing[@]}"; do
        echo "  - $file"
    done
    echo "💡 Ejecutar: ./scripts/restore_docs.sh"
fi

# Estado general
if [ ${#generated_in_git[@]} -eq 0 ] && [ ${#important_missing[@]} -eq 0 ]; then
    echo " Estado de Git: PERFECTO"
elif [ ${#important_missing[@]} -eq 0 ]; then
    echo "⚠️ Estado de Git: Requiere limpieza"
else
    echo " Estado de Git: CRÍTICO - Requiere atención inmediata"
fi 