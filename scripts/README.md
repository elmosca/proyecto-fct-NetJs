# Scripts del Proyecto FCT

Esta carpeta contiene los scripts esenciales para el desarrollo y despliegue del proyecto.

## 📁 Scripts Disponibles

### 🚀 **Script Principal**
- `setup.ps1` - **Script principal** que configura todo el entorno (backend + frontend + base de datos)

### 🔧 **Scripts de Ayuda**
- `cursor-agent-helper.ps1` - Helper para el agente de Cursor (desarrollo)

## 🎯 **Uso Recomendado**

### **Primera vez y configuración completa:**
```powershell
# Windows - Configuración completa
.\setup.ps1
```

### **Desarrollo diario:**
```powershell
# Usar el helper de Cursor para operaciones específicas
.\scripts\cursor-agent-helper.ps1 [comando]
```

## 📝 **Notas**

- **setup.ps1** es el único script necesario para configurar todo el proyecto
- Incluye configuración de entorno, base de datos, backend y frontend
- Compatible con Docker Desktop en Windows
- Incluye manejo de errores y logs detallados
