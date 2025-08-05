---
name: Performance Issue
about: Reportar un problema de rendimiento
title: '[PERFORMANCE] '
labels: 'performance'
assignees: ''
---

## 🚀 Descripción del Problema de Performance
Una descripción clara y concisa del problema de rendimiento observado.

## 📊 Métricas Afectadas
- [ ] Tiempo de carga inicial
- [ ] Tiempo de respuesta de UI
- [ ] Uso de memoria
- [ ] Uso de CPU
- [ ] Tamaño del bundle
- [ ] Tiempo de compilación

## 🔍 Pasos para Reproducir
1. Ve a '...'
2. Haz clic en '...'
3. Desliza hacia '...'
4. Observar problema de performance

## 📱 Información del Dispositivo
**Frontend (Flutter):**
- Dispositivo: [e.g. iPhone 12, Samsung Galaxy S21]
- OS: [e.g. iOS 15.1, Android 12]
- Versión de la App: [e.g. 1.0.0]
- Plataforma: [e.g. Android, iOS, Web, PWA]
- Memoria disponible: [e.g. 4GB, 8GB]

**Backend:**
- OS: [e.g. Ubuntu 20.04]
- Node.js: [e.g. 18.0.0]
- Base de datos: [e.g. PostgreSQL 13]

## ⏱️ Mediciones de Performance
- **Tiempo de carga**: [e.g. 5 segundos]
- **Uso de memoria**: [e.g. 150MB]
- **FPS promedio**: [e.g. 30 FPS]
- **Tamaño del APK**: [e.g. 25MB]

## 🔧 Análisis Técnico
- [ ] ¿Hay widgets que no usan `const`?
- [ ] ¿Hay listas largas sin `ListView.builder`?
- [ ] ¿Hay operaciones pesadas en el hilo principal?
- [ ] ¿Hay memory leaks detectados?
- [ ] ¿Hay imágenes no optimizadas?
- [ ] ¿Hay rebuilds innecesarios?

## 🎯 Optimizaciones Sugeridas
- [ ] Implementar `RepaintBoundary`
- [ ] Usar `compute()` para operaciones pesadas
- [ ] Implementar lazy loading
- [ ] Optimizar imágenes
- [ ] Reducir rebuilds con `ValueNotifier`

## 📸 Capturas de Pantalla
Si es aplicable, añade capturas de pantalla del problema de performance.

## 📋 Logs de Performance
```
Pega aquí logs de performance relevantes
```

## 🔗 Contexto Adicional
Añade cualquier otro contexto sobre el problema de performance aquí. 