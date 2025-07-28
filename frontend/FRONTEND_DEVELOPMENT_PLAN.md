# Plan de Desarrollo Frontend - Flutter

## 📑 Tabla de Contenidos

### 📋 Información General
- [Información del Proyecto](#-información-del-proyecto)
- [Objetivos del Frontend](#-objetivos-del-frontend)
- [Arquitectura del Proyecto](#️-arquitectura-del-proyecto)

### 📦 Stack y Herramientas
- [Stack Tecnológico](#-stack-tecnológico)
- [Herramientas de Diseño UI](#-herramientas-de-diseño-ui)
  - [Stitch - Design with AI (Google)](#stitch---design-with-ai-google)

### 📋 Plan de Desarrollo
- [Plan de Desarrollo por Fases](#-plan-de-desarrollo-por-fases)
  - [Fase 1: Configuración Base](#fase-1-configuración-base-️-1-2-semanas)
  - [Fase 2: Core y Shared](#fase-2-core-y-shared-️-1-2-semanas)
  - [Fase 3: Autenticación](#fase-3-autenticación-️-1-2-semanas)
  - [Fase 4: Dashboard y Navegación](#fase-4-dashboard-y-navegación-️-1-semana)
  - [Fase 5: Gestión de Usuarios](#fase-5-gestión-de-usuarios-️-1-2-semanas)
  - [Fase 6: Gestión de Proyectos](#fase-6-gestión-de-proyectos-️-2-3-semanas)
  - [Fase 7: Sistema de Anteproyectos](#fase-7-sistema-de-anteproyectos-️-3-4-semanas)
  - [Fase 8: Kanban de Tareas](#fase-8-kanban-de-tareas-️-2-3-semanas)
  - [Fase 9: Sistema de Comentarios](#fase-9-sistema-de-comentarios-️-1-2-semanas)
  - [Fase 10: Notificaciones](#fase-10-notificaciones-️-1-2-semanas)
  - [Fase 11: Sistema de Evaluaciones](#fase-11-sistema-de-evaluaciones-️-2-3-semanas)
  - [Fase 12: Optimización y Testing](#fase-12-optimización-y-testing-️-2-3-semanas)
  - [Fase 13: Preparación para Producción](#fase-13-preparación-para-producción-️-1-2-semanas)

### 📱 Plataformas y Testing
- [Características por Plataforma](#-características-por-plataforma)
  - [Web (PWA)](#web-pwa)
  - [Android](#android)
  - [iOS](#ios)
- [Testing Strategy](#-testing-strategy)
- [Métricas de Calidad](#-métricas-de-calidad)

### 🔄 Workflow y Git
- [Workflow de Desarrollo](#-workflow-de-desarrollo)
  - [Git Flow y Ciclo de Vida](#git-flow-y-ciclo-de-vida)
    - [Estructura de Ramas](#estructura-de-ramas)
    - [Flujo de Trabajo Detallado](#flujo-de-trabajo-detallado)
    - [Convenciones de Commits](#convenciones-de-commits-conventional-commits)
    - [GitHub Workflow](#github-workflow)
    - [Branches Protection Rules](#branches-protection-rules)
    - [Release Management](#release-management)
    - [Code Review Guidelines](#code-review-guidelines)
    - [Conflict Resolution](#conflict-resolution)
  - [Code Review](#code-review)
  - [Deployment](#deployment)
  - [Herramientas y Configuraciones](#herramientas-y-configuraciones)

### ⏱️ Estimaciones y Estado
- [Estimación de Tiempos](#️-estimación-de-tiempos)
- [Próximos Pasos Inmediatos](#-próximos-pasos-inmediatos)
- [Notas de Desarrollo](#-notas-de-desarrollo)
- [Estado Actual del Desarrollo](#-estado-actual-del-desarrollo)

---

## 📋 Información del Proyecto

- **Tecnología**: Flutter (Web, Android, iOS)
- **Arquitectura**: Clean Architecture + Riverpod
- **Navegación**: AutoRoute
- **Inyección de Dependencias**: getIt
- **Estado**: freezed + Riverpod
- **Backend**: NestJS API REST + WebSockets
- **Fecha de inicio**: 2024-12-25
- **Estado actual**: Configuración inicial

## 🎯 Objetivos del Frontend

### Funcionalidades Principales

1. **Sistema de Autenticación** (JWT + Google OAuth)
2. **Gestión de Usuarios** (perfiles, roles, permisos)
3. **Gestión de Proyectos** (CRUD, asignaciones)
4. **Sistema de Anteproyectos** (ciclo de vida completo)
5. **Kanban de Tareas** (drag & drop, asignaciones)
6. **Sistema de Comentarios** (en tareas y proyectos)
7. **Notificaciones en Tiempo Real** (WebSocket)
8. **Gestión de Archivos** (subida, descarga, preview)
9. **Sistema de Evaluaciones** (criterios, calificaciones)

### Plataformas Soportadas

- ✅ **Web** (PWA - Progressive Web App)
- ✅ **Android** (APK + Google Play Store)
- ✅ **iOS** (App Store)

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas (Clean Architecture)

```
frontend/
├── lib/
│   ├── core/                    # Código compartido
│   │   ├── constants/           # Constantes de la app
│   │   ├── extensions/          # Extensiones de Dart
│   │   ├── theme/              # Configuración de temas
│   │   ├── utils/              # Utilidades generales
│   │   └── widgets/            # Widgets reutilizables
│   ├── features/               # Módulos de funcionalidad
│   │   ├── auth/              # Autenticación
│   │   ├── users/             # Gestión de usuarios
│   │   ├── projects/          # Gestión de proyectos
│   │   ├── anteprojects/      # Anteproyectos
│   │   ├── tasks/             # Sistema de tareas
│   │   ├── comments/          # Comentarios
│   │   ├── notifications/     # Notificaciones
│   │   ├── files/             # Gestión de archivos
│   │   └── evaluations/       # Sistema de evaluaciones
│   ├── shared/                # Código compartido entre features
│   │   ├── models/            # Modelos de datos
│   │   ├── repositories/      # Repositorios
│   │   ├── services/          # Servicios
│   │   └── providers/         # Providers de Riverpod
│   └── main.dart              # Punto de entrada
├── test/                      # Tests unitarios
├── integration_test/          # Tests de integración
├── assets/                    # Recursos estáticos
└── pubspec.yaml              # Dependencias
```

### Patrones de Diseño

- **Clean Architecture**: Separación de capas (UI, Domain, Data)
- **Repository Pattern**: Abstracción de acceso a datos
- **Provider Pattern**: Gestión de estado con Riverpod
- **Dependency Injection**: Inyección con getIt
- **Observer Pattern**: Para notificaciones y WebSockets

## 📋 Plan de Desarrollo por Fases

### **Fase 1: Configuración Base** ⏱️ 1-2 semanas

- [ ] **1.1** Inicializar proyecto Flutter
- [ ] **1.2** Configurar estructura de carpetas (Clean Architecture)
- [ ] **1.3** Configurar dependencias principales:
  - [ ] Riverpod (gestión de estado)
  - [ ] AutoRoute (navegación)
  - [ ] getIt (inyección de dependencias)
  - [ ] freezed (modelos inmutables)
  - [ ] json_annotation (serialización)
  - [ ] dio (cliente HTTP)
  - [ ] web_socket_channel (WebSockets)
- [ ] **1.4** Configurar tema y estilos base
- [ ] **1.5** Configurar internacionalización (i18n)
- [ ] **1.6** Configurar logging y debugging
- [ ] **1.7** Configurar tests unitarios y de widgets

### **Fase 2: Core y Shared** ⏱️ 1-2 semanas

- [ ] **2.1** Implementar modelos de datos (entities)
- [ ] **2.2** Configurar cliente HTTP con interceptores
- [ ] **2.3** Implementar servicio de autenticación
- [ ] **2.4** Configurar manejo de errores global
- [ ] **2.5** Implementar sistema de logging
- [ ] **2.6** Configurar WebSocket service
- [ ] **2.7** Implementar widgets base (loading, error, empty states)

### **Fase 3: Autenticación** ⏱️ 1-2 semanas

- [ ] **3.1** Pantalla de login (email/password) - **Stitch**
- [ ] **3.2** Integración con Google OAuth
- [ ] **3.3** Pantalla de registro - **Stitch**
- [ ] **3.4** Recuperación de contraseña - **Stitch**
- [ ] **3.5** Gestión de tokens JWT
- [ ] **3.6** Middleware de autenticación
- [ ] **3.7** Tests de autenticación

### **Fase 4: Dashboard y Navegación** ⏱️ 1 semana

- [ ] **4.1** Layout principal con navegación - **Stitch**
- [ ] **4.2** Dashboard principal - **Stitch**
- [ ] **4.3** Menú lateral (drawer) - **Stitch**
- [ ] **4.4** Navegación por roles
- [ ] **4.5** Breadcrumbs y navegación

### **Fase 5: Gestión de Usuarios** ⏱️ 1-2 semanas

- [ ] **5.1** Lista de usuarios (con filtros y búsqueda) - **Stitch**
- [ ] **5.2** Perfil de usuario - **Stitch**
- [ ] **5.3** Edición de perfil - **Stitch**
- [ ] **5.4** Gestión de roles y permisos
- [ ] **5.5** Creación de usuarios (admin) - **Stitch**
- [ ] **5.6** Tests de usuarios

### **Fase 6: Gestión de Proyectos** ⏱️ 2-3 semanas

- [ ] **6.1** Lista de proyectos - **Stitch**
- [ ] **6.2** Creación de proyectos - **Stitch**
- [ ] **6.3** Detalle de proyecto - **Stitch**
- [ ] **6.4** Edición de proyectos - **Stitch**
- [ ] **6.5** Asignación de estudiantes
- [ ] **6.6** Gestión de tutores
- [ ] **6.7** Tests de proyectos

### **Fase 7: Sistema de Anteproyectos** ⏱️ 3-4 semanas

- [ ] **7.1** Lista de anteproyectos - **Stitch**
- [ ] **7.2** Creación de anteproyectos - **Stitch**
- [ ] **7.3** Detalle de anteproyecto - **Stitch**
- [ ] **7.4** Ciclo de vida completo:
  - [ ] Submit para revisión - **Stitch**
  - [ ] Revisión por tutores - **Stitch**
  - [ ] Aprobación/rechazo - **Stitch**
  - [ ] Programación de defensa - **Stitch**
  - [ ] Completado - **Stitch**
- [ ] **7.5** Sistema de archivos adjuntos
- [ ] **7.6** Tests de anteproyectos

### **Fase 8: Kanban de Tareas** ⏱️ 2-3 semanas

- [ ] **8.1** Vista Kanban con drag & drop - **Stitch**
- [ ] **8.2** Creación de tareas - **Stitch**
- [ ] **8.3** Edición de tareas - **Stitch**
- [ ] **8.4** Asignación de usuarios
- [ ] **8.5** Cambio de estado (drag & drop)
- [ ] **8.6** Filtros y búsqueda
- [ ] **8.7** Tests de tareas

### **Fase 9: Sistema de Comentarios** ⏱️ 1-2 semanas

- [ ] **9.1** Comentarios en tareas - **Stitch**
- [ ] **9.2** Comentarios en proyectos - **Stitch**
- [ ] **9.3** Editor de comentarios (markdown)
- [ ] **9.4** Notificaciones de comentarios
- [ ] **9.5** Tests de comentarios

### **Fase 10: Notificaciones** ⏱️ 1-2 semanas

- [ ] **10.1** WebSocket connection
- [ ] **10.2** Notificaciones en tiempo real
- [ ] **10.3** Centro de notificaciones - **Stitch**
- [ ] **10.4** Notificaciones push (mobile)
- [ ] **10.5** Configuración de notificaciones - **Stitch**
- [ ] **10.6** Tests de notificaciones

### **Fase 11: Sistema de Evaluaciones** ⏱️ 2-3 semanas

- [ ] **11.1** Criterios de evaluación - **Stitch**
- [ ] **11.2** Formularios de evaluación - **Stitch**
- [ ] **11.3** Calificaciones - **Stitch**
- [ ] **11.4** Reportes de evaluación - **Stitch**
- [ ] **11.5** Tests de evaluaciones

### **Fase 12: Optimización y Testing** ⏱️ 2-3 semanas

- [ ] **12.1** Tests de integración
- [ ] **12.2** Tests E2E
- [ ] **12.3** Optimización de rendimiento
- [ ] **12.4** Optimización de imágenes
- [ ] **12.5** Lazy loading
- [ ] **12.6** Caché de datos

### **Fase 13: Preparación para Producción** ⏱️ 1-2 semanas

- [ ] **13.1** Configuración de builds
- [ ] **13.2** Configuración de CI/CD
- [ ] **13.3** Configuración de PWA
- [ ] **13.4** Configuración de App Store
- [ ] **13.5** Configuración de Google Play
- [ ] **13.6** Documentación de despliegue

## 📦 Stack Tecnológico

### **Dependencias Principales**

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Gestión de Estado
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Navegación
  auto_route: ^7.8.4

  # Inyección de Dependencias
  get_it: ^7.6.4

  # Modelos y Serialización
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # HTTP Client
  dio: ^5.4.0

  # WebSockets
  web_socket_channel: ^2.4.0

  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  flutter_markdown: ^0.6.18

  # Utils
  intl: ^0.18.1
  url_launcher: ^6.2.2
  shared_preferences: ^2.2.2

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  auto_route_generator: ^7.3.2

  # Testing
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.4
```

## 🎨 Herramientas de Diseño UI

### **Stitch - Design with AI (Google)**

#### **Descripción**
Stitch es una herramienta de Google que permite crear interfaces de usuario utilizando inteligencia artificial. Es especialmente útil para generar código Flutter a partir de descripciones textuales o diseños visuales.

#### **Características Principales**
- **Generación de código Flutter** a partir de prompts de texto
- **Diseño responsive** automático
- **Integración con Material Design 3**
- **Exportación directa** de código Flutter
- **Optimización de UI** basada en IA
- **Soporte para temas** claro y oscuro

#### **Workflow de Integración con Stitch**

##### **1. Configuración Inicial**

```bash
# Acceso a Stitch
# URL: https://stitch.google.com/
# Requiere cuenta de Google
```

##### **2. Proceso de Diseño por Pantalla**

```markdown
## Proceso para cada pantalla:

1. **Análisis de Requisitos**
   - Definir funcionalidad de la pantalla
   - Identificar elementos UI necesarios
   - Establecer interacciones requeridas

2. **Prompt Engineering para Stitch**
   - Crear prompt descriptivo y específico
   - Incluir requisitos de diseño
   - Especificar componentes Flutter

3. **Generación con Stitch**
   - Generar código base
   - Revisar y ajustar resultado
   - Iterar si es necesario

4. **Integración en Proyecto**
   - Adaptar código generado
   - Integrar con arquitectura del proyecto
   - Añadir lógica de negocio

5. **Testing y Refinamiento**
   - Probar funcionalidad
   - Ajustar responsive design
   - Optimizar performance
```

##### **3. Templates de Prompts para Stitch**

###### **Pantalla de Login**
```markdown
Prompt para Stitch:
"Crear una pantalla de login para Flutter con Material Design 3 que incluya:
- Campo de email con validación
- Campo de contraseña con toggle de visibilidad
- Botón de login con estado de carga
- Botón de login con Google
- Enlace para recuperar contraseña
- Enlace para registro
- Diseño responsive para móvil y web
- Tema claro y oscuro
- Animaciones suaves en las transiciones"
```

###### **Dashboard Principal**
```markdown
Prompt para Stitch:
"Crear un dashboard principal para Flutter con Material Design 3 que incluya:
- AppBar con avatar de usuario y menú
- Cards con estadísticas de proyectos
- Lista de proyectos recientes
- Quick actions con FAB
- Bottom navigation con 4 tabs
- Drawer lateral con navegación
- Diseño responsive
- Tema claro y oscuro
- Animaciones de entrada"
```

###### **Kanban Board**
```markdown
Prompt para Stitch:
"Crear un tablero Kanban para Flutter con Material Design 3 que incluya:
- Columnas horizontales scrollables
- Cards de tareas con drag & drop
- Botón para añadir nueva tarea
- Filtros por estado y asignado
- Búsqueda de tareas
- Indicadores de prioridad
- Diseño responsive
- Tema claro y oscuro
- Animaciones de drag & drop"
```

##### **4. Guías de Diseño para Stitch**

###### **Convenciones de Naming**
```dart
// Widgets generados por Stitch
class StitchLoginScreen extends StatelessWidget
class StitchDashboardCard extends StatelessWidget
class StitchKanbanColumn extends StatelessWidget

// Archivos generados
stitch_login_screen.dart
stitch_dashboard_card.dart
stitch_kanban_column.dart
```

###### **Estructura de Carpetas para Stitch**
```
lib/
├── features/
│   ├── auth/
│   │   ├── ui/
│   │   │   ├── stitch/              # Código generado por Stitch
│   │   │   │   ├── stitch_login_screen.dart
│   │   │   │   └── stitch_register_screen.dart
│   │   │   └── screens/             # Pantallas adaptadas
│   │   │       ├── login_screen.dart
│   │   │       └── register_screen.dart
│   │   └── widgets/                 # Widgets personalizados
│   └── projects/
│       ├── ui/
│       │   ├── stitch/
│       │   └── screens/
│       └── widgets/
```

##### **5. Proceso de Adaptación del Código Stitch**

```dart
// 1. Código generado por Stitch (stitch_login_screen.dart)
class StitchLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Código generado...
    );
  }
}

// 2. Adaptación para el proyecto (login_screen.dart)
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return StitchLoginScreen(
      // Adaptar con lógica de negocio
      onLoginPressed: (email, password) {
        ref.read(authProvider.notifier).login(email, password);
      },
      onGoogleLoginPressed: () {
        ref.read(authProvider.notifier).loginWithGoogle();
      },
      isLoading: authState.isLoading,
      errorMessage: authState.error,
    );
  }
}
```

##### **6. Checklist de Integración Stitch**

- [ ] **Generación**: Código generado por Stitch
- [ ] **Adaptación**: Integrar con arquitectura del proyecto
- [ ] **Estado**: Conectar con Riverpod providers
- [ ] **Navegación**: Integrar con AutoRoute
- [ ] **Temas**: Adaptar a sistema de temas del proyecto
- [ ] **Responsive**: Verificar en diferentes tamaños
- [ ] **Accesibilidad**: Añadir soporte para lectores de pantalla
- [ ] **Testing**: Crear tests para la funcionalidad
- [ ] **Performance**: Optimizar si es necesario
- [ ] **Documentación**: Documentar cambios y decisiones

##### **7. Herramientas Complementarias**

###### **Figma Integration**
```markdown
- Exportar diseños de Figma a Stitch
- Usar Figma como base para prompts
- Mantener consistencia visual
```

###### **Material Theme Builder**
```markdown
- Generar temas personalizados
- Integrar con código Stitch
- Mantener consistencia de marca
```

##### **8. Comandos Útiles para Stitch**

```bash
# Crear estructura de carpetas para Stitch
mkdir -p lib/features/*/ui/stitch
mkdir -p lib/features/*/ui/screens
mkdir -p lib/features/*/ui/widgets

# Mover código generado
mv stitch_generated_file.dart lib/features/auth/ui/stitch/

# Generar código adaptado
flutter packages pub run build_runner build

# Verificar linting
flutter analyze lib/features/*/ui/stitch/
```

##### **9. Métricas de Calidad para Stitch**

###### **Eficiencia de Generación**
- Tiempo de generación por pantalla: <30 min
- Tasa de aceptación del código generado: >80%
- Iteraciones necesarias por pantalla: <3

###### **Calidad del Código**
- Cobertura de tests: >90%
- Cumplimiento de linting: 100%
- Performance score: >90

##### **10. Troubleshooting Stitch**

###### **Problemas Comunes**
```markdown
1. **Código no compila**
   - Verificar dependencias
   - Revisar imports
   - Ajustar sintaxis

2. **Diseño no responsive**
   - Ajustar constraints
   - Usar LayoutBuilder
   - Implementar MediaQuery

3. **Performance issues**
   - Optimizar rebuilds
   - Usar const constructors
   - Implementar lazy loading
```

###### **Solución de Errores**
```bash
# Limpiar y rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

# Verificar dependencias
flutter doctor
flutter pub deps
```

## 📱 Características por Plataforma

### **Web (PWA)**

- [ ] Service Worker para offline
- [ ] Instalación como app
- [ ] Notificaciones push
- [ ] Responsive design
- [ ] Optimización para SEO

### **Android**

- [ ] Permisos de archivos
- [ ] Notificaciones push
- [ ] Integración con Google Drive
- [ ] Compartir archivos
- [ ] Modo oscuro automático

### **iOS**

- [ ] Permisos de archivos
- [ ] Notificaciones push
- [ ] Integración con iCloud
- [ ] Compartir archivos
- [ ] Modo oscuro automático

## 🧪 Testing Strategy

### **Tests Unitarios**

- [ ] Models y Entities
- [ ] Services y Repositories
- [ ] Providers de Riverpod
- [ ] Utils y Helpers

### **Tests de Widgets**

- [ ] Componentes UI
- [ ] Pantallas principales
- [ ] Navegación
- [ ] Interacciones de usuario

### **Tests de Integración**

- [ ] Flujo de autenticación
- [ ] CRUD de entidades
- [ ] WebSocket connections
- [ ] Upload de archivos

### **Tests E2E**

- [ ] Flujos completos de usuario
- [ ] Cross-platform testing
- [ ] Performance testing

## 📊 Métricas de Calidad

### **Cobertura de Código**

- Objetivo: >80% de cobertura
- Tests unitarios: >90%
- Tests de widgets: >70%

### **Performance**

- Tiempo de carga inicial: <3s
- Tiempo de respuesta de UI: <100ms
- Tamaño de app: <50MB

### **Accesibilidad**

- Soporte para lectores de pantalla
- Navegación por teclado
- Contraste de colores adecuado

## 🔄 Workflow de Desarrollo

### **Git Flow y Ciclo de Vida**

#### **Estructura de Ramas**

```
main                    # Código de producción (solo releases)
├── develop            # Código de desarrollo (integración)
├── feature/           # Nuevas funcionalidades
│   ├── feature/auth-system
│   ├── feature/project-management
│   └── feature/kanban-board
├── bugfix/            # Correcciones de bugs
│   ├── bugfix/login-error
│   └── bugfix/memory-leak
├── hotfix/            # Correcciones urgentes de producción
│   └── hotfix/security-patch
└── release/           # Preparación de releases
    └── release/v1.0.0
```

#### **Flujo de Trabajo Detallado**

##### **1. Desarrollo de Features**

```bash
# 1. Crear rama desde develop
git checkout develop
git pull origin develop
git checkout -b feature/nombre-feature

# 2. Desarrollo con commits semánticos
git commit -m "feat: añadir sistema de autenticación"
git commit -m "test: añadir tests para auth service"
git commit -m "docs: actualizar documentación de API"

# 3. Push y crear Pull Request
git push origin feature/nombre-feature
```

##### **2. Pull Request y Code Review**

- **Título**: `feat: implementar sistema de autenticación`
- **Descripción**: Usar template de PR
- **Reviewers**: Mínimo 1 aprobación
- **Labels**: `feature`, `frontend`, `auth`
- **Assignees**: Desarrollador responsable

##### **3. Merge Strategy**

- **Squash and Merge**: Para features
- **Rebase and Merge**: Para hotfixes
- **Merge Commit**: Para releases

#### **Convenciones de Commits (Conventional Commits)**

```bash
# Estructura: <tipo>[<scope>]: <descripción>

# Features
feat(auth): añadir login con Google OAuth
feat(projects): implementar CRUD de proyectos

# Bug fixes
fix(ui): corregir layout en pantallas pequeñas
fix(api): resolver error en endpoint de usuarios

# Documentation
docs(readme): actualizar instrucciones de instalación
docs(api): añadir documentación de endpoints

# Tests
test(auth): añadir tests para login
test(ui): añadir tests de widgets

# Refactoring
refactor(services): reorganizar estructura de servicios
refactor(providers): optimizar providers de Riverpod

# Performance
perf(images): optimizar carga de imágenes
perf(api): implementar caché de respuestas

# Build
build(deps): actualizar dependencias de Flutter
build(ci): configurar GitHub Actions

# CI/CD
ci(workflow): añadir tests automáticos
ci(deploy): configurar despliegue automático

# Chore
chore(deps): actualizar dependencias
chore(lint): configurar reglas de linting
```

#### **GitHub Workflow**

##### **1. Issues y Project Management**

- **Issue Types**:
  - `bug`: Errores y problemas
  - `enhancement`: Mejoras de funcionalidad
  - `feature`: Nuevas funcionalidades
  - `documentation`: Mejoras en documentación
  - `question`: Preguntas y dudas

- **Issue Template**:
  ```markdown
  ## Descripción
  [Descripción clara del problema/feature]

  ## Comportamiento Esperado
  [Qué debería pasar]

  ## Comportamiento Actual
  [Qué está pasando actualmente]

  ## Pasos para Reproducir
  1. [Paso 1]
  2. [Paso 2]
  3. [Paso 3]

  ## Información Adicional
  - Plataforma: [Web/Android/iOS]
  - Versión: [Versión de Flutter]
  - Dispositivo: [Si aplica]
  ```

##### **2. Pull Request Template**

```markdown
## Descripción
[Descripción de los cambios realizados]

## Tipo de Cambio
- [ ] Bug fix
- [ ] Nueva feature
- [ ] Breaking change
- [ ] Documentación

## Checklist
- [ ] Tests añadidos/actualizados
- [ ] Documentación actualizada
- [ ] Código sigue las convenciones
- [ ] Self-review completado
- [ ] Screenshots añadidos (si aplica)

## Screenshots
[Si hay cambios visuales]

## Testing
- [ ] Tests unitarios pasan
- [ ] Tests de widgets pasan
- [ ] Tests de integración pasan
- [ ] Probado en Web/Android/iOS

## Breaking Changes
[Si hay breaking changes, describirlos aquí]
```

##### **3. GitHub Actions Workflow**

```yaml
# .github/workflows/flutter.yml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build web
      - run: flutter build apk

  deploy-web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build web
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

#### **Branches Protection Rules**

##### **main branch**
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Restrict pushes that create files that are larger than 100 MB
- Require linear history

##### **develop branch**
- Require pull request reviews before merging
- Require status checks to pass before merging
- Allow force pushes (solo para admins)

#### **Release Management**

##### **1. Versionado Semántico (SemVer)**

```bash
# Formato: MAJOR.MINOR.PATCH
# Ejemplo: 1.2.3

# MAJOR: Cambios incompatibles con versiones anteriores
# MINOR: Nuevas funcionalidades compatibles
# PATCH: Correcciones de bugs compatibles
```

##### **2. Release Process**

```bash
# 1. Crear rama de release
git checkout develop
git checkout -b release/v1.0.0

# 2. Actualizar versiones
# pubspec.yaml
version: 1.0.0+1

# 3. Commit de release
git commit -m "chore: preparar release v1.0.0"

# 4. Merge a main y develop
git checkout main
git merge release/v1.0.0
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin main --tags

git checkout develop
git merge release/v1.0.0
git push origin develop

# 5. Eliminar rama de release
git branch -d release/v1.0.0
git push origin --delete release/v1.0.0
```

##### **3. GitHub Releases**

- **Título**: `v1.0.0 - Sistema de Gestión de Proyectos`
- **Descripción**: Changelog detallado
- **Assets**: APK, Web build, iOS build
- **Pre-release**: Para versiones beta/alpha

#### **Code Review Guidelines**

##### **1. Checklist del Reviewer**

- [ ] **Funcionalidad**: ¿El código hace lo que debe?
- [ ] **Arquitectura**: ¿Sigue los principios de Clean Architecture?
- [ ] **Testing**: ¿Hay tests suficientes?
- [ ] **Performance**: ¿Hay problemas de rendimiento?
- [ ] **Security**: ¿Hay vulnerabilidades de seguridad?
- [ ] **Documentation**: ¿Está documentado correctamente?
- [ ] **Naming**: ¿Los nombres son descriptivos?
- [ ] **Error Handling**: ¿Se manejan los errores correctamente?

##### **2. Comentarios de Review**

```markdown
# Formato de comentarios
## Sugerencia
[Descripción de la sugerencia]

## Pregunta
[Pregunta sobre el código]

## Crítica
[Problema identificado]

## Elogio
[Algo que está bien hecho]
```

#### **Conflict Resolution**

##### **1. Resolver Conflictos en PR**

```bash
# 1. Actualizar rama con develop
git checkout feature/mi-feature
git fetch origin
git rebase origin/develop

# 2. Resolver conflictos
# Editar archivos con conflictos
git add .
git rebase --continue

# 3. Force push (solo si es necesario)
git push origin feature/mi-feature --force-with-lease
```

##### **2. Resolver Conflictos en develop**

```bash
# 1. Crear rama temporal
git checkout develop
git checkout -b temp/conflict-resolution

# 2. Resolver conflictos
git merge feature/conflicting-feature

# 3. Merge a develop
git checkout develop
git merge temp/conflict-resolution
git branch -d temp/conflict-resolution
```

### **Code Review**

- [ ] Revisión obligatoria antes de merge
- [ ] Tests automáticos en CI/CD
- [ ] Análisis de código estático
- [ ] Verificación de accesibilidad
- [ ] Checklist de review obligatorio
- [ ] Comentarios constructivos
- [ ] Aprobación de al menos 1 reviewer

### **Deployment**

- [ ] Web: Despliegue automático en Vercel/Netlify
- [ ] Android: Build automático para Google Play
- [ ] iOS: Build automático para App Store
- [ ] GitHub Pages para documentación
- [ ] Docker Hub para imágenes de contenedores

#### **Herramientas y Configuraciones**

##### **1. Git Hooks (Husky)**

```json
// package.json (para Flutter web)
{
  "husky": {
    "hooks": {
      "pre-commit": "flutter analyze && flutter test",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS",
      "pre-push": "flutter test --coverage"
    }
  }
}
```

##### **2. Commitlint Configuration**

```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',
        'fix',
        'docs',
        'style',
        'refactor',
        'perf',
        'test',
        'build',
        'ci',
        'chore',
        'revert'
      ]
    ],
    'scope-enum': [
      2,
      'always',
      [
        'auth',
        'ui',
        'api',
        'tests',
        'docs',
        'build',
        'ci',
        'deps'
      ]
    ]
  }
};
```

##### **3. Flutter Linting Rules**

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_empty_else
    - avoid_print
    - avoid_unused_constructor_parameters
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - constant_identifier_names
    - control_flow_in_finally
    - directives_ordering
    - empty_catches
    - empty_constructor_bodies
    - empty_statements
    - hash_and_equals
    - implementation_imports
    - library_names
    - library_prefixes
    - non_constant_identifier_names
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - prefer_const_constructors
    - prefer_final_fields
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_typing_uninitialized_variables
    - slash_for_doc_comments
    - test_types_in_equals
    - throw_in_finally
    - type_init_formals
    - unnecessary_brace_in_string_interps
    - unnecessary_getters_setters
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_statements
    - unrelated_type_equality_checks
    - use_rethrow_when_possible
    - valid_regexps
```

##### **4. GitHub Project Board**

```yaml
# .github/project.yml
name: Flutter Frontend Development
columns:
  - name: Backlog
    id: backlog
  - name: To Do
    id: todo
  - name: In Progress
    id: in-progress
  - name: Review
    id: review
  - name: Done
    id: done
```

##### **5. Dependabot Configuration**

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pub"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    reviewers:
      - "username"
    assignees:
      - "username"
    commit-message:
      prefix: "deps"
      include: "scope"
```

#### **Comandos Útiles para el Workflow**

```bash
# Configuración inicial del repositorio
git config --local core.autocrlf false
git config --local core.eol lf

# Verificar estado del repositorio
git status
git log --oneline --graph --decorate

# Limpiar ramas locales obsoletas
git remote prune origin
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

# Verificar convenciones de commits
npx commitlint --from HEAD~1 --to HEAD --verbose

# Generar changelog automático
npx conventional-changelog-cli -p angular -i CHANGELOG.md -s

# Verificar cobertura de tests
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## ⏱️ Estimación de Tiempos

### **Desarrollo Total**

- **Tiempo estimado**: 16-20 semanas
- **Desarrolladores**: 1-2
- **Horas por semana**: 20-40

### **Por Fase**

- Fase 1-2 (Configuración): 2-4 semanas
- Fase 3-5 (Core Features): 3-5 semanas
- Fase 6-8 (Main Features): 7-10 semanas
- Fase 9-11 (Advanced Features): 4-6 semanas
- Fase 12-13 (Testing & Deploy): 3-5 semanas

## 🚀 Próximos Pasos Inmediatos

### **Configuración del Repositorio**
1. **Inicializar proyecto Flutter**
2. **Configurar estructura de carpetas**
3. **Configurar Git workflow y GitHub Actions**
4. **Configurar templates de Issues y Pull Requests**
5. **Configurar branches protection rules**

### **Configuración del Proyecto**
6. **Instalar dependencias base**
7. **Configurar tema y estilos**
8. **Implementar modelos de datos**
9. **Configurar linting y formatting**
10. **Configurar tests unitarios**

### **Configuración de Stitch**
11. **Configurar acceso a Stitch (Google)**
12. **Crear estructura de carpetas para código generado**
13. **Definir templates de prompts para pantallas principales**
14. **Configurar workflow de integración Stitch → Proyecto**
15. **Crear guías de adaptación de código generado**

## 📝 Notas de Desarrollo

### **Consideraciones Técnicas**

- Usar `const` constructors donde sea posible
- Implementar lazy loading para listas grandes
- Optimizar imágenes y assets
- Implementar error boundaries
- Usar debounce para búsquedas

### **UX/UI Guidelines**

- Seguir Material Design 3
- Implementar modo oscuro
- Diseño responsive para todas las pantallas
- Feedback visual para todas las acciones
- Estados de carga y error claros

### **Seguridad**

- Validación de datos en cliente
- Sanitización de inputs
- Manejo seguro de tokens
- Cifrado de datos sensibles
- HTTPS obligatorio

## 📈 Estado Actual del Desarrollo

### **Progreso General**

- **Fase actual**: Fase 1 - Configuración Base
- **Progreso total**: 0%
- **Tareas completadas**: 0/89
- **Semanas transcurridas**: 0

### **Últimas Actualizaciones**

- **2024-12-25**: Creación del plan de desarrollo
- **Próxima actualización**: 2025-01-01

### **Bloqueadores Actuales**

- Ninguno identificado

### **Riesgos Identificados**

- Complejidad de la integración con Google OAuth
- Gestión de WebSockets en múltiples plataformas
- Optimización de rendimiento en dispositivos móviles
- **Dependencia de Stitch**: Posible limitación de acceso o cambios en la herramienta
- **Calidad del código generado**: Necesidad de revisión y adaptación manual
- **Consistencia de diseño**: Mantener coherencia visual entre pantallas generadas

### **Beneficios de Stitch**

- **Aceleración del desarrollo**: Reducción del 40-60% en tiempo de creación de UI
- **Consistencia de Material Design 3**: Implementación automática de guidelines
- **Responsive design**: Generación automática de layouts adaptativos
- **Reducción de errores**: Menos bugs de UI gracias a código probado
- **Documentación automática**: Código bien estructurado y comentado
- **Iteración rápida**: Posibilidad de generar múltiples versiones rápidamente

---

**Última actualización**: 2025-07-26
**Próxima revisión**: 2025-01-01
**Responsable**: Equipo de desarrollo frontend
