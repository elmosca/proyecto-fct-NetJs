#!/bin/bash
# Script para limpiar archivos generados por Flutter de forma segura (Linux/Mac)
# Uso: ./clean_generated_files.sh

echo " Limpiando archivos generados por Flutter del tracking de Git..."

# Lista de archivos generados que SÍ se pueden eliminar del tracking
generated_files=(
    "frontend/.flutter-plugins-dependencies"
    "frontend/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java"
    "frontend/android/local.properties"
)

# Lista de archivos importantes que NO se deben eliminar
important_files=(
    "frontend/DEVELOPMENT_CHECKLIST.md"
    "frontend/FRONTEND_DEVELOPMENT_GUIDE.md"
    "frontend/PROJECT_CONTEXT.md"
    "frontend/assets/i18n/app_es.arb"
    "frontend/cspell.json"
    "frontend/.gitignore"
)

echo " Archivos generados que se eliminarán del tracking:"
for file in "${generated_files[@]}"; do
    echo "  - $file"
done

echo "🛡️ Archivos importantes que se mantienen protegidos:"
for file in "${important_files[@]}"; do
    echo "  - $file"
done

# Confirmar antes de proceder
read -p "¿Continuar con la limpieza? (y/N): " confirmation
if [[ ! $confirmation =~ ^[Yy]$ ]]; then
    echo "❌ Operación cancelada"
    exit 0
fi

# Eliminar archivos generados del tracking
echo "🗑️ Eliminando archivos generados del tracking..."
for file in "${generated_files[@]}"; do
    if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        git rm --cached "$file"
        echo "  ✅ $file eliminado del tracking"
    else
        echo "  ⚠️ $file ya no está en tracking"
    fi
done

# Verificar que los archivos importantes siguen protegidos
echo "🔍 Verificando protección de archivos importantes..."
for file in "${important_files[@]}"; do
    if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        echo "  ✅ $file protegido"
    else
        echo "  ❌ $file NO está protegido - REQUIERE ATENCIÓN"
    fi
done

echo "✅ Limpieza completada!"
echo " Los archivos generados se regenerarán automáticamente con:"
echo "   flutter pub get"
echo "   flutter build"
echo " Ahora solo se committearán archivos de código fuente" 