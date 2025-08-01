# 🚀 Contexto Completo del Proyecto FCT - Frontend Flutter

## 📋 Información General del Proyecto

**Nombre**: Sistema de Gestión de Proyectos FCT  
**Tecnología**: Flutter con Clean Architecture  
**Estado actual**: Fase 5 - Gestión de Usuarios  
**Progreso**: 26.1% (29/111 tareas completadas)  
**Última actualización**: 2025-07-28  

## 🏗️ Arquitectura del Proyecto

### **Clean Architecture - Estructura**
```
lib/
├── core/                    # Infraestructura y utilidades
│   ├── constants/          # Constantes
│   ├── di/                 # Inyección de dependencias (GetIt)
│   ├── exceptions/         # Excepciones personalizadas
│   ├── extensions/         # Extensiones de Dart
│   ├── i18n/              # Internacionalización
│   ├── interceptors/       # Interceptores HTTP
│   ├── providers/          # Providers de estado global
│   ├── routes/             # Configuración de rutas (AutoRoute)
│   ├── services/           # Servicios base
│   ├── theme/              # Configuración de temas
│   ├── utils/              # Utilidades generales
│   └── widgets/            # Widgets base reutilizables
├── features/               # Características (módulos)
│   ├── auth/              # Autenticación
│   ├── dashboard/         # Dashboard
│   ├── projects/          # Proyectos
│   ├── users/             # Usuarios
│   └── notifications/     # Notificaciones
├── shared/                # Recursos compartidos
│   ├── models/            # Modelos de datos
│   └── widgets/           # Widgets compartidos
└── main.dart              # Punto de entrada
```

## 🔧 Stack Tecnológico

### **Dependencias Principales**
```yaml
# Estado y gestión de datos
flutter_riverpod: ^2.4.9
riverpod_annotation: ^2.3.3

# Navegación
auto_route: ^7.8.4

# Inyección de dependencias
get_it: ^7.6.4

# Generación de código
freezed_annotation: ^2.4.1
json_annotation: ^4.8.1

# HTTP y networking
dio: ^5.4.0
connectivity_plus: ^5.0.2

# Almacenamiento local
shared_preferences: ^2.2.2
hive: ^2.2.3
hive_flutter: ^1.1.0

# Internacionalización
flutter_localizations: sdk: flutter
intl: ^0.18.1

# Utilidades
logger: ^2.0.2+1
url_launcher: ^6.2.2
image_picker: ^1.0.4
file_picker: ^6.1.1
flutter_local_notifications: ^16.3.2
```

## 📊 Estado Actual del Desarrollo

### **Fases Completadas**
- ✅ **Fase 1**: Configuración Base (7/7 tareas)
- ✅ **Fase 2**: Core y Shared (7/7 tareas)
- ✅ **Fase 3**: Autenticación (7/7 tareas)
- ✅ **Fase 4**: Dashboard y Navegación (8/8 tareas)

### **Fase Actual**
- 🔴 **Fase 5**: Gestión de Usuarios (0/8 tareas) - **EN PROGRESO**

### **Funcionalidades Implementadas**
- ✅ Sistema de autenticación completo
- ✅ Dashboard principal con navegación
- ✅ Búsqueda global con sugerencias e historial
- ✅ Sistema de notificaciones push
- ✅ Layout responsive con drawer
- ✅ Internacionalización (Español/Inglés)
- ✅ Clean Architecture con Riverpod
- ✅ Inyección de dependencias con GetIt
- ✅ Navegación con AutoRoute

## 🎯 Funcionalidades de la Fase 4 (Recién Completada)

### **Búsqueda Global (4.5)**
- **Servicio**: `SearchService` con métodos para búsqueda global
- **Modelos**: `GlobalSearchResult`, `SearchFilters`, `SearchSuggestion`
- **Provider**: `SearchNotifier` con Riverpod
- **Widget**: `GlobalSearchWidget` integrado en AppBar
- **Características**: Sugerencias, historial, filtros

### **Notificaciones Push (4.6)**
- **Servicio**: `NotificationService` con `flutter_local_notifications`
- **Modelo**: `Notification` con `readAt` (DateTime nullable)
- **Provider**: `NotificationNotifier` para gestión de estado
- **Widget**: `NotificationBadgeWidget` con badge y diálogo
- **Características**: Badges, diálogos, gestión de estado

## 📋 Tareas Pendientes de la Fase 5

### **Gestión de Usuarios (8 tareas)**
- [ ] **5.1** Implementar CRUD de usuarios
- [ ] **5.2** Configurar roles y permisos
- [ ] **5.3** Implementar gestión de perfiles
- [ ] **5.4** Configurar validaciones de formularios
- [ ] **5.5** Implementar búsqueda y filtros de usuarios
- [ ] **5.6** Configurar paginación de listas
- [ ] **5.7** Implementar exportación de datos
- [ ] **5.8** Configurar auditoría de acciones

## 🔄 Git Workflow y Estrategia de Merge

### **Estructura de Ramas**
```
main                    # Producción
├── develop            # Desarrollo (integración)
├── feature/fase5-gestion-usuarios  # Rama actual
├── feature/fase4-dashboard         # Completada
└── [otras ramas de fases anteriores]
```

### **Estrategia de Merge Seguro**
- **Problema resuelto**: Pérdida de archivos de documentación durante merges
- **Solución implementada**: 
  - `.gitignore` configurado para ignorar archivos generados por Flutter
  - Scripts de recuperación: `restore_docs.ps1` y `restore_docs.sh`
  - Workflow recomendado: Merge en GitHub, luego actualizar local

### **Convenciones de Commits**
```bash
feat(users): implementar CRUD de usuarios
fix(ui): corregir layout en pantallas pequeñas
docs(api): actualizar documentación de endpoints
test(auth): añadir tests para login
refactor(services): reorganizar estructura de servicios
```

## 🌍 Internacionalización

### **Idiomas Soportados**
- **Castellano**: Idioma principal
- **Inglés**: Idioma secundario

### **Configuración**
- Archivos de traducción: `app_es.arb`, `app_en.arb`
- Provider: `LocaleProvider` para cambio en tiempo real
- Detección automática del idioma del sistema

## 🧪 Testing Strategy

### **Tipos de Tests**
- **Unitarios**: Lógica de negocio, servicios, providers
- **Widgets**: Componentes UI, pantallas
- **Integración**: Flujos completos, APIs
- **E2E**: Flujos de usuario completos

### **Cobertura Objetivo**
- **Total**: >80%
- **Unitarios**: >90%
- **Widgets**: >70%

## 📱 Características por Plataforma

### **Web (PWA)**
- Service Worker para offline
- Instalación como app
- Notificaciones push
- Responsive design

### **Android/iOS**
- Permisos de archivos
- Notificaciones push
- Integración con Google Drive/iCloud
- Modo oscuro automático

## 🎨 Patrones de Diseño

### **Clean Architecture**
- Separación de responsabilidades por capas
- Independencia de frameworks
- Testabilidad
- Principios SOLID

### **State Management**
- **Riverpod**: Gestión de estado reactivo
- **StateNotifier**: Para lógica compleja
- **Provider**: Para estado simple
- **FutureProvider**: Para operaciones asíncronas

### **Patrones UI**
- Widgets base reutilizables
- Layouts responsivos
- Componentes modulares
- Diseño adaptativo

## 🔐 Autenticación

### **Estrategia Implementada**
- **Google Identity Services**: Integración directa
- **JWT**: Tokens propios del backend
- **Interceptores**: Manejo automático de tokens
- **Refresh tokens**: Renovación automática

### **Flujo de Autenticación**
1. Login con Google OAuth
2. Backend valida token con Google
3. Backend emite JWT propio
4. Frontend usa JWT para requests
5. Refresh automático cuando expira

## 📊 Métricas de Calidad

### **Performance**
- Tiempo de carga inicial: <3s
- Tiempo de respuesta de UI: <100ms
- Tamaño de app: <50MB

### **Accesibilidad**
- Soporte para lectores de pantalla
- Navegación por teclado
- Contraste de colores adecuado

## 🚀 Próximos Pasos Inmediatos

### **Fase 5 - Gestión de Usuarios**
1. **Implementar CRUD de usuarios**
   - Lista de usuarios con filtros
   - Creación y edición de usuarios
   - Eliminación de usuarios
   - Validaciones de formularios

2. **Configurar roles y permisos**
   - Sistema de roles (Admin, Tutor, Estudiante)
   - Permisos granulares
   - Middleware de autorización

3. **Implementar gestión de perfiles**
   - Perfil de usuario editable
   - Cambio de contraseña
   - Preferencias de usuario

## 📚 Archivos de Documentación Clave

### **Archivos de Seguimiento**
- `DEVELOPMENT_CHECKLIST.md`: Estado general del proyecto
- `FRONTEND_DEVELOPMENT_GUIDE.md`: Guía técnica completa
- `PROJECT_CONTEXT.md`: Este archivo de contexto

### **Scripts de Mantenimiento**
- `scripts/restore_docs.ps1`: Recuperación de documentación (Windows)
- `scripts/restore_docs.sh`: Recuperación de documentación (Linux/Mac)
- `scripts/README.md`: Documentación de scripts

## 🎯 Comandos Útiles

### **Desarrollo**
```bash
# Ejecutar aplicación
flutter run

# Generar código
flutter packages pub run build_runner build

# Tests
flutter test

# Análisis de código
flutter analyze
```

### **Git**
```bash
# Ver estado
git status

# Ver ramas
git branch

# Recuperar documentación
.\scripts\restore_docs.ps1

# Crear nueva rama
git checkout -b feature/nueva-funcionalidad
```

## 🔧 Configuraciones Especiales

### **.gitignore**
- Ignora archivos generados por Flutter
- Mantiene archivos de documentación importantes
- Evita conflictos durante merges

### **Análisis de Código**
- Reglas de linting estrictas
- Formateo automático
- Convenciones de nomenclatura

## 📈 Estimación de Tiempos

### **Fase 5 - Gestión de Usuarios**
- **Tiempo estimado**: 2-3 semanas
- **Tareas**: 8 tareas principales
- **Complejidad**: Media

### **Proyecto Completo**
- **Tiempo total estimado**: 16-20 semanas
- **Fases restantes**: 10 fases
- **Progreso actual**: 26.1%

---

**Última actualización**: 2025-07-28  
**Versión del contexto**: 1.0.0  
**Preparado para**: Transferencia a nuevo chat