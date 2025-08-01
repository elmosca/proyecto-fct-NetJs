#!/bin/bash

# Script para recuperar documentos de seguimiento del proyecto
# Uso: ./restore_docs.sh [commit_hash]

COMMIT_HASH=${1:-"0af93a5"}  # Commit por defecto donde están los docs

echo "🔄 Recuperando documentos de seguimiento desde commit: $COMMIT_HASH"

# Recuperar DEVELOPMENT_CHECKLIST.md
echo "📋 Recuperando DEVELOPMENT_CHECKLIST.md..."
git show $COMMIT_HASH:frontend/DEVELOPMENT_CHECKLIST.md > DEVELOPMENT_CHECKLIST.md

# Recuperar FRONTEND_DEVELOPMENT_GUIDE.md
echo "📚 Recuperando FRONTEND_DEVELOPMENT_GUIDE.md..."
git show $COMMIT_HASH:frontend/FRONTEND_DEVELOPMENT_GUIDE.md > FRONTEND_DEVELOPMENT_GUIDE.md

# Verificar que los archivos se recuperaron
if [ -f "DEVELOPMENT_CHECKLIST.md" ] && [ -f "FRONTEND_DEVELOPMENT_GUIDE.md" ]; then
    echo "✅ Documentos recuperados exitosamente!"
    echo "📁 Archivos disponibles:"
    ls -la *.md
else
    echo "❌ Error al recuperar documentos"
    exit 1
fi

echo "🎯 Documentos listos para usar en el desarrollo"