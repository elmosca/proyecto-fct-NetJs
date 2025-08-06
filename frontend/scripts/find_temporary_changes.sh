#!/bin/bash

# Script para encontrar cambios temporales en el proyecto Flutter
# Uso: ./scripts/find_temporary_changes.sh

echo "🔍 Buscando cambios temporales en el proyecto..."
echo "=================================================="

# Buscar marcadores temporales
echo "📋 Marcadores temporales encontrados:"
echo "--------------------------------------"
grep -r "TODO: \[REVIEW_NEEDED\]" lib/ 2>/dev/null || echo "No se encontraron marcadores [REVIEW_NEEDED]"
echo ""

grep -r "TODO: \[TEMPORARY\]" lib/ 2>/dev/null || echo "No se encontraron marcadores [TEMPORARY]"
echo ""

grep -r "TODO: \[REMOVED\]" lib/ 2>/dev/null || echo "No se encontraron marcadores [REMOVED]"
echo ""

# Buscar placeholders
echo "🔄 Placeholders temporales:"
echo "---------------------------"
grep -r "TEMPORAL\|PLACEHOLDER" lib/ 2>/dev/null || echo "No se encontraron placeholders"
echo ""

# Buscar código comentado
echo "💬 Código comentado temporalmente:"
echo "----------------------------------"
grep -r "// TODO:" lib/ 2>/dev/null || echo "No se encontraron TODOs"
echo ""

# Buscar imports comentados
echo "📦 Imports comentados:"
echo "---------------------"
grep -r "// import" lib/ 2>/dev/null || echo "No se encontraron imports comentados"
echo ""

# Buscar métodos comentados
echo "🔧 Métodos comentados:"
echo "---------------------"
grep -r "// .*\(\)" lib/ 2>/dev/null || echo "No se encontraron métodos comentados"
echo ""

# Resumen
echo "📊 Resumen:"
echo "-----------"
echo "Archivos con cambios temporales:"
find lib/ -name "*.dart" -exec grep -l "TODO: \[REVIEW_NEEDED\]\|TEMPORAL\|PLACEHOLDER" {} \; 2>/dev/null | sort | uniq

echo ""
echo "✅ Búsqueda completada. Revisa TEMPORARY_CHANGES_LOG.md para más detalles." 