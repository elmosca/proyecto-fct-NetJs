# 📁 Scripts de Mantenimiento del Proyecto

## 🔄 Recuperación de Documentos de Seguimiento

### **Problema:**
Los archivos de documentación (`DEVELOPMENT_CHECKLIST.md` y `FRONTEND_DEVELOPMENT_GUIDE.md`) se pueden perder al cambiar de ramas debido a conflictos con archivos generados automáticamente por Flutter.

### **Solución:**
Scripts automáticos para recuperar los documentos desde cualquier commit.

## 🚀 Uso de los Scripts

### **En Windows (PowerShell):**
```powershell
# Recuperar desde el commit por defecto (0af93a5)
.\scripts\restore_docs.ps1

# Recuperar desde un commit específico
.\scripts\restore_docs.ps1 "commit_hash"
```

### **En Linux/Mac (Bash):**
```bash
# Recuperar desde el commit por defecto (0af93a5)
./scripts/restore_docs.sh

# Recuperar desde un commit específico
./scripts/restore_docs.sh "commit_hash"
```

## 📋 Archivos que se Recuperan

1. **`DEVELOPMENT_CHECKLIST.md`** - Checklist de progreso del proyecto
2. **`FRONTEND_DEVELOPMENT_GUIDE.md`** - Guía completa de desarrollo frontend

## 🔧 Configuración del .gitignore

El archivo `.gitignore` está configurado para:
- ✅ **Ignorar** archivos generados automáticamente por Flutter
- ✅ **Preservar** archivos de documentación importantes
- ✅ **Evitar** conflictos al cambiar de ramas

## 📝 Comandos Manuales de Recuperación

Si los scripts no funcionan, puedes usar estos comandos manualmente:

```bash
# Recuperar DEVELOPMENT_CHECKLIST.md
git show 0af93a5:frontend/DEVELOPMENT_CHECKLIST.md > DEVELOPMENT_CHECKLIST.md

# Recuperar FRONTEND_DEVELOPMENT_GUIDE.md
git show 0af93a5:frontend/FRONTEND_DEVELOPMENT_GUIDE.md > FRONTEND_DEVELOPMENT_GUIDE.md
```

## 🎯 Flujo de Trabajo Recomendado

1. **Antes de cambiar de rama**: Ejecutar script de recuperación
2. **Después de cambiar de rama**: Verificar que los documentos estén presentes
3. **Si faltan documentos**: Ejecutar script de recuperación
4. **Commit de cambios**: Incluir documentos en el commit

## 📊 Estado de los Archivos

| Archivo | Importancia | Se Regenera | Problema si se Pierde |
|---------|-------------|-------------|----------------------|
| `.flutter-plugins-dependencies` | ⭐⭐⭐⭐⭐ | ✅ Automático | Flutter no funciona |
| `GeneratedPluginRegistrant.java` | ⭐⭐⭐⭐⭐ | ✅ Automático | Plugins no funcionan |
| `local.properties` | ⭐⭐⭐⭐ | ✅ Automático | No encuentra SDKs |
| `DEVELOPMENT_CHECKLIST.md` | ⭐⭐⭐⭐ | ❌ Manual | Pérdida de seguimiento |
| `FRONTEND_DEVELOPMENT_GUIDE.md` | ⭐⭐⭐⭐ | ❌ Manual | Pérdida de documentación |
| `cspell.json` | ⭐⭐ | ✅ Manual | No hay spell checking |

---

**Última actualización**: 2025-07-29
**Responsable**: Equipo de desarrollo frontend