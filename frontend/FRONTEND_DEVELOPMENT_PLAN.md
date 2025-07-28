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
- [Internacionalización (i18n) - Soporte Bilingüe](#-internacionalización-i18n---soporte-bilingüe)
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
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
## 📋 Información del Proyecto

- **Tecnología**: Flutter (Web, Android, iOS)
- **Arquitectura**: Clean Architecture + Riverpod
- **Navegación**: AutoRoute
- **Inyección de Dependencias**: getIt
- **Estado**: freezed + Riverpod
- **Backend**: NestJS API REST + WebSockets
- **Fecha de inicio**: 2025-07-28
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

### **Idiomas Soportados**

- ✅ **Castellano** (idioma principal)
- ✅ **Inglés** (idioma secundario)
- 🔄 **Sistema de cambio de idioma en tiempo real**
- 🔄 **Contenido dinámico multilingüe**

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas (Clean Architecture)

```
frontend/
├── lib/
│   ├── core/                    # Código compartido
│   │   ├── constants/           # Constantes de la app
│   │   ├── extensions/          # Extensiones de Dart
│   │   ├── i18n/               # Internacionalización
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
- [ ] **1.5** Configurar internacionalización (i18n) - **Soporte Bilingüe Castellano/Inglés**
  - [ ] Configurar `flutter_localizations`
  - [ ] Crear archivos de traducción para castellano e inglés
  - [ ] Implementar selector de idioma en tiempo real
  - [ ] Configurar `MaterialApp` con soporte multilingüe
  - [ ] Crear sistema de fallback para traducciones faltantes
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

<<<<<<< HEAD
- [ ] **3.1** Pantalla de login (email/password) - **Stitch**
- [ ] **3.2** Integración con Google OAuth
- [ ] **3.3** Pantalla de registro - **Stitch**
- [ ] **3.4** Recuperación de contraseña - **Stitch**
=======
- [ ] **3.1** Pantalla de login (email/password)
- [ ] **3.2** Integración con Google OAuth
- [ ] **3.3** Pantalla de registro
- [ ] **3.4** Recuperación de contraseña
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **3.5** Gestión de tokens JWT
- [ ] **3.6** Middleware de autenticación
- [ ] **3.7** Tests de autenticación

### **Fase 4: Dashboard y Navegación** ⏱️ 1 semana

<<<<<<< HEAD
- [ ] **4.1** Layout principal con navegación - **Stitch**
- [ ] **4.2** Dashboard principal - **Stitch**
- [ ] **4.3** Menú lateral (drawer) - **Stitch**
=======
- [ ] **4.1** Layout principal con navegación
- [ ] **4.2** Dashboard principal
- [ ] **4.3** Menú lateral (drawer)
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **4.4** Navegación por roles
- [ ] **4.5** Breadcrumbs y navegación

### **Fase 5: Gestión de Usuarios** ⏱️ 1-2 semanas

<<<<<<< HEAD
- [ ] **5.1** Lista de usuarios (con filtros y búsqueda) - **Stitch**
- [ ] **5.2** Perfil de usuario - **Stitch**
- [ ] **5.3** Edición de perfil - **Stitch**
- [ ] **5.4** Gestión de roles y permisos
- [ ] **5.5** Creación de usuarios (admin) - **Stitch**
=======
- [ ] **5.1** Lista de usuarios (con filtros y búsqueda)
- [ ] **5.2** Perfil de usuario
- [ ] **5.3** Edición de perfil
- [ ] **5.4** Gestión de roles y permisos
- [ ] **5.5** Creación de usuarios (admin)
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **5.6** Tests de usuarios

### **Fase 6: Gestión de Proyectos** ⏱️ 2-3 semanas

<<<<<<< HEAD
- [ ] **6.1** Lista de proyectos - **Stitch**
- [ ] **6.2** Creación de proyectos - **Stitch**
- [ ] **6.3** Detalle de proyecto - **Stitch**
- [ ] **6.4** Edición de proyectos - **Stitch**
=======
- [ ] **6.1** Lista de proyectos
- [ ] **6.2** Creación de proyectos
- [ ] **6.3** Detalle de proyecto
- [ ] **6.4** Edición de proyectos
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **6.5** Asignación de estudiantes
- [ ] **6.6** Gestión de tutores
- [ ] **6.7** Tests de proyectos

### **Fase 7: Sistema de Anteproyectos** ⏱️ 3-4 semanas

<<<<<<< HEAD
- [ ] **7.1** Lista de anteproyectos - **Stitch**
- [ ] **7.2** Creación de anteproyectos - **Stitch**
- [ ] **7.3** Detalle de anteproyecto - **Stitch**
- [ ] **7.4** Ciclo de vida completo:
  - [ ] Submit para revisión - **Stitch**
  - [ ] Revisión por tutores - **Stitch**
  - [ ] Aprobación/rechazo - **Stitch**
  - [ ] Programación de defensa - **Stitch**
  - [ ] Completado - **Stitch**
=======
- [ ] **7.1** Lista de anteproyectos
- [ ] **7.2** Creación de anteproyectos
- [ ] **7.3** Detalle de anteproyecto
- [ ] **7.4** Ciclo de vida completo:
  - [ ] Submit para revisión
  - [ ] Revisión por tutores
  - [ ] Aprobación/rechazo
  - [ ] Programación de defensa
  - [ ] Completado
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **7.5** Sistema de archivos adjuntos
- [ ] **7.6** Tests de anteproyectos

### **Fase 8: Kanban de Tareas** ⏱️ 2-3 semanas

<<<<<<< HEAD
- [ ] **8.1** Vista Kanban con drag & drop - **Stitch**
- [ ] **8.2** Creación de tareas - **Stitch**
- [ ] **8.3** Edición de tareas - **Stitch**
=======
- [ ] **8.1** Vista Kanban con drag & drop
- [ ] **8.2** Creación de tareas
- [ ] **8.3** Edición de tareas
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **8.4** Asignación de usuarios
- [ ] **8.5** Cambio de estado (drag & drop)
- [ ] **8.6** Filtros y búsqueda
- [ ] **8.7** Tests de tareas

### **Fase 9: Sistema de Comentarios** ⏱️ 1-2 semanas

<<<<<<< HEAD
- [ ] **9.1** Comentarios en tareas - **Stitch**
- [ ] **9.2** Comentarios en proyectos - **Stitch**
=======
- [ ] **9.1** Comentarios en tareas
- [ ] **9.2** Comentarios en proyectos
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **9.3** Editor de comentarios (markdown)
- [ ] **9.4** Notificaciones de comentarios
- [ ] **9.5** Tests de comentarios

### **Fase 10: Notificaciones** ⏱️ 1-2 semanas

- [ ] **10.1** WebSocket connection
- [ ] **10.2** Notificaciones en tiempo real
<<<<<<< HEAD
- [ ] **10.3** Centro de notificaciones - **Stitch**
- [ ] **10.4** Notificaciones push (mobile)
- [ ] **10.5** Configuración de notificaciones - **Stitch**
=======
- [ ] **10.3** Centro de notificaciones
- [ ] **10.4** Notificaciones push (mobile)
- [ ] **10.5** Configuración de notificaciones
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
- [ ] **10.6** Tests de notificaciones

### **Fase 11: Sistema de Evaluaciones** ⏱️ 2-3 semanas

<<<<<<< HEAD
- [ ] **11.1** Criterios de evaluación - **Stitch**
- [ ] **11.2** Formularios de evaluación - **Stitch**
- [ ] **11.3** Calificaciones - **Stitch**
- [ ] **11.4** Reportes de evaluación - **Stitch**
=======
- [ ] **11.1** Criterios de evaluación
- [ ] **11.2** Formularios de evaluación
- [ ] **11.3** Calificaciones
- [ ] **11.4** Reportes de evaluación
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
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

  # Internacionalización
  flutter_localizations:
    sdk: flutter

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

<<<<<<< HEAD
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

=======
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
## 🌍 Internacionalización (i18n) - Soporte Bilingüe

### **Requisitos del Centro Bilingüe**

La aplicación debe soportar completamente dos idiomas para facilitar el trabajo en un entorno educativo bilingüe:

#### **Idiomas Soportados**
- **Castellano**: Idioma principal del centro
- **Inglés**: Idioma secundario para estudiantes internacionales y contenido bilingüe

#### **Funcionalidades de Internacionalización**

##### **1. Cambio de Idioma en Tiempo Real**
- Selector de idioma en el perfil de usuario
- Cambio instantáneo sin reiniciar la aplicación
- Persistencia de la preferencia de idioma
- Detección automática del idioma del sistema

##### **2. Contenido Dinámico Multilingüe**
- **Interfaz de usuario**: Todos los textos, botones, etiquetas
- **Contenido de usuario**: Títulos de proyectos, descripciones, comentarios
- **Documentación**: Ayuda, tutoriales, mensajes de error
- **Notificaciones**: Emails, push notifications, mensajes del sistema

##### **3. Estructura de Archivos de Traducción**

```dart
// lib/core/i18n/
├── app_es.arb          # Traducciones en castellano
├── app_en.arb          # Traducciones en inglés
├── i18n_config.dart    # Configuración de internacionalización
└── locale_provider.dart # Provider para gestión de idioma
```

##### **4. Ejemplo de Archivos de Traducción**

```json
// app_es.arb
{
  "loginTitle": "Iniciar Sesión",
  "emailLabel": "Correo Electrónico",
  "passwordLabel": "Contraseña",
  "loginButton": "Entrar",
  "forgotPassword": "¿Olvidaste tu contraseña?",
  "registerLink": "¿No tienes cuenta? Regístrate",
  "projectTitle": "Título del Proyecto",
  "projectDescription": "Descripción del Proyecto",
  "createProject": "Crear Proyecto",
  "editProject": "Editar Proyecto",
  "deleteProject": "Eliminar Proyecto",
  "confirmDelete": "¿Estás seguro de que quieres eliminar este elemento?",
  "save": "Guardar",
  "cancel": "Cancelar",
  "loading": "Cargando...",
  "error": "Error",
  "success": "Éxito",
  "warning": "Advertencia"
}

// app_en.arb
{
  "loginTitle": "Login",
  "emailLabel": "Email",
  "passwordLabel": "Password",
  "loginButton": "Sign In",
  "forgotPassword": "Forgot your password?",
  "registerLink": "Don't have an account? Sign up",
  "projectTitle": "Project Title",
  "projectDescription": "Project Description",
  "createProject": "Create Project",
  "editProject": "Edit Project",
  "deleteProject": "Delete Project",
  "confirmDelete": "Are you sure you want to delete this item?",
  "save": "Save",
  "cancel": "Cancel",
  "loading": "Loading...",
  "error": "Error",
  "success": "Success",
  "warning": "Warning"
}
```

##### **5. Implementación en el Código**

```dart
// Uso en widgets
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginTitle),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.emailLabel,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(AppLocalizations.of(context)!.loginButton),
          ),
        ],
      ),
    );
  }
}

// Provider para cambio de idioma
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('es');
  
  Locale get locale => _locale;
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
  
  void toggleLanguage() {
    _locale = _locale.languageCode == 'es' 
        ? const Locale('en') 
        : const Locale('es');
    notifyListeners();
  }
}
```

##### **6. Configuración en MaterialApp**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Castellano
        Locale('en', ''), // Inglés
      ],
      locale: context.watch<LocaleProvider>().locale,
      home: HomeScreen(),
    );
  }
}
```

##### **7. Testing de Internacionalización**

- [ ] Tests unitarios para traducciones
- [ ] Tests de widgets con diferentes idiomas
- [ ] Tests de integración con cambio de idioma
- [ ] Verificación de textos largos en ambos idiomas
- [ ] Tests de accesibilidad en ambos idiomas

##### **8. Consideraciones Especiales**

###### **Textos Dinámicos**
- Manejo de plurales en ambos idiomas
- Formateo de fechas según locale
- Formateo de números según locale
- Dirección del texto (LTR/RTL)

###### **Contenido de Usuario**
- Soporte para contenido creado en ambos idiomas
- Búsqueda multilingüe
- Filtros por idioma de contenido
- Etiquetas de idioma en contenido

###### **Performance**
- Carga lazy de archivos de traducción
- Caché de traducciones
- Optimización de strings largos

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

### **Git Flow Simplificado**

#### **Estructura de Ramas (Buenas Prácticas)**

```
main                    # Código de producción (solo releases)
├── develop            # Código de desarrollo (integración)
├── feature/           # Nuevas funcionalidades
│   ├── feature/auth-system
│   ├── feature/project-management
│   └── feature/kanban-board
├── bugfix/            # Correcciones de bugs
│   └── bugfix/ui-fixes
├── hotfix/            # Correcciones urgentes de producción
│   └── hotfix/security-patch
└── release/           # Preparación de releases
    └── release/v1.0.0
```

#### **Flujo de Trabajo Simplificado**

##### **1. Desarrollo de Features**

```bash
# 1. Crear rama desde develop
git checkout develop
git pull origin develop
git checkout -b feature/nombre-feature

# 2. Desarrollo con commits semánticos
git commit -m "feat: añadir sistema de autenticación"
git commit -m "test: añadir tests para auth service"
git commit -m "docs: actualizar documentación"

# 3. Push y crear Pull Request
git push origin feature/nombre-feature
```

##### **2. Convenciones de Commits (Conventional Commits)**

```bash
# Estructura: <tipo>[<scope>]: <descripción>

# Features
feat(auth): añadir login con Google OAuth
feat(projects): implementar CRUD de proyectos
feat(ui): crear pantalla de dashboard

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

# Chore
chore(deps): actualizar dependencias
chore(lint): configurar reglas de linting
```

##### **3. Pull Request y Code Review**

- **Título**: `feat: implementar sistema de autenticación`
- **Descripción**: Usar template de PR
- **Reviewers**: Mínimo 1 aprobación
- **Labels**: `feature`, `frontend`, `auth`
- **Assignees**: Desarrollador responsable

##### **4. Merge Strategy**

- **Squash and Merge**: Para features
- **Rebase and Merge**: Para hotfixes
- **Merge Commit**: Para releases

#### **Workflow por Fases (Simplificado)**

##### **Para cada fase del proyecto:**

```bash
# 1. Crear rama de feature para la fase
git checkout develop
git pull origin develop
git checkout -b feature/fase1-configuracion-base

# 2. Desarrollar todas las tareas de la fase
git commit -m "feat(fase1): inicializar proyecto Flutter"
git commit -m "feat(fase1): configurar estructura Clean Architecture"
git commit -m "feat(fase1): instalar dependencias principales"
git commit -m "feat(fase1): configurar tema y estilos base"
git commit -m "feat(fase1): configurar internacionalización"
git commit -m "feat(fase1): configurar logging y debugging"
git commit -m "feat(fase1): configurar tests unitarios"

# 3. Crear Pull Request a develop
git push origin feature/fase1-configuracion-base

# 4. Code review y merge
# 5. Eliminar rama de feature
git branch -d feature/fase1-configuracion-base
```

#### **Comandos Útiles**

```bash
# Ver estado actual
git status
git log --oneline --graph --decorate -10

# Ver ramas activas
git branch -a

# Limpiar ramas obsoletas
git remote prune origin
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

# Verificar convenciones de commits
git log --oneline --grep="feat\|fix\|docs\|test\|refactor\|perf\|build\|chore"

# Resolver conflictos
git fetch origin
git rebase origin/develop
```

### **Code Review**

- [ ] Revisión obligatoria antes de merge
- [ ] Tests automáticos en CI/CD
- [ ] Análisis de código estático
- [ ] Verificación de accesibilidad
- [ ] Checklist de review obligatorio
- [ ] Aprobación de al menos 1 reviewer

### **Deployment**

- [ ] Web: Despliegue automático en Vercel/Netlify
- [ ] Android: Build automático para Google Play
- [ ] iOS: Build automático para App Store

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

<<<<<<< HEAD
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
=======
1. **Inicializar proyecto Flutter**
2. **Configurar estructura de carpetas**
3. **Instalar dependencias base**
4. **Configurar tema y estilos**
5. **Implementar modelos de datos**
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001

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
- **Soporte completo para castellano e inglés**
- **Textos adaptables a diferentes longitudes**
- **Iconografía universal (no dependiente del idioma)**

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

<<<<<<< HEAD
- **2025-07-28**: Creación del plan de desarrollo
- **Próxima actualización**: 2025-08-04
=======
- **2025-07-28**: Creación del plan de desarrollo
- **Próxima actualización**: 2025-08-04
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001

### **Bloqueadores Actuales**

- Ninguno identificado

### **Riesgos Identificados**

- Complejidad de la integración con Google OAuth
- Gestión de WebSockets en múltiples plataformas
- Optimización de rendimiento en dispositivos móviles
<<<<<<< HEAD
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

**Última actualización**: 2025-07-28
**Próxima revisión**: 2025-08-04
=======

---

**Última actualización**: 2024-12-19
**Próxima revisión**: 2024-12-26
>>>>>>> 44217fba1d2d6cc6eb1c305a14638bfe7213a001
**Responsable**: Equipo de desarrollo frontend
