# 🚀 Sistema FCT - Frontend Flutter

Frontend multiplataforma del Sistema de Gestión de Proyectos FCT desarrollado con Flutter, siguiendo las mejores prácticas oficiales del equipo de Flutter.

## 📋 Descripción

Sistema completo de gestión de proyectos para Formación en Centros de Trabajo (FCT) que incluye:
- Gestión de usuarios y roles
- Gestión de proyectos y anteproyectos
- Sistema de tareas y milestones
- Evaluaciones y calificaciones
- Notificaciones en tiempo real
- Soporte bilingüe (Castellano/Inglés)

## 🏗️ Arquitectura

### Clean Architecture + 5 Recomendaciones Fundamentales del Equipo Flutter

Este proyecto implementa las **5 recomendaciones "Strongly recommend"** del equipo oficial de Flutter:

#### 1. **Separación de Concernidos** (STRONGLY RECOMMEND)
- Lógica de negocio separada de la UI
- Patrones MVVM, Clean Architecture
- Widgets enfocados solo en presentación

#### 2. **Inyección de Dependencias** (STRONGLY RECOMMEND)
- SIEMPRE usar inyección de dependencias (getIt, Riverpod)
- NUNCA objetos globalmente accesibles
- Abstract classes para facilitar testing

#### 3. **Navegación con go_router** (RECOMMEND)
- go_router como solución oficial recomendada
- Rutas nombradas y tipadas
- Deep linking y guards de autenticación

#### 4. **Convenciones de Nombres Estándar** (RECOMMEND)
- Nomenclatura según componente arquitectónico
- `ui/core/` en lugar de `/widgets/`
- Evitar nombres que se confundan con el SDK

#### 5. **Repositorios Abstractos** (STRONGLY RECOMMEND)
- Repositories como fuente de verdad
- SIEMPRE crear abstract repository classes
- Cache strategies y fallbacks

## 🛠️ Stack Tecnológico

### Dependencias Principales
- **Flutter**: 3.16.0+
- **Estado**: Riverpod (recomendación oficial)
- **Navegación**: go_router (recomendación oficial)
- **Inyección**: getIt
- **Modelos**: freezed + json_annotation
- **HTTP**: dio
- **WebSockets**: web_socket_channel
- **Internacionalización**: flutter_localizations

### Estructura del Proyecto
```
lib/
├── core/                    # Infraestructura y utilidades
│   ├── di/                 # Inyección de dependencias
│   ├── services/           # Servicios base
│   ├── routes/             # Configuración go_router
│   └── widgets/            # Widgets base
├── features/               # Módulos de características
│   ├── auth/              # Autenticación
│   ├── projects/          # Gestión de proyectos
│   ├── users/             # Gestión de usuarios
│   └── evaluations/       # Sistema de evaluaciones
└── shared/                # Recursos compartidos
    ├── models/            # Modelos de datos
    └── ui/                # UI compartida
```

## 🚀 Inicio Rápido

### Prerrequisitos
- Flutter 3.16.0 o superior
- Dart 3.0.0 o superior
- Android Studio / VS Code

### Instalación
```bash
# Clonar repositorio
git clone https://github.com/tu-usuario/proyecto-fct-NetJs.git
cd proyecto-fct-NetJs/frontend

# Instalar dependencias
flutter pub get

# Generar código
flutter packages pub run build_runner build

# Ejecutar aplicación
flutter run
```

### Comandos Útiles
```bash
# Generar código automáticamente
flutter packages pub run build_runner watch

# Ejecutar tests
flutter test

# Analizar código
flutter analyze

# Build para web
flutter build web

# Build para Android
flutter build apk
```

## 🌍 Internacionalización

El proyecto soporta completamente dos idiomas:
- **Castellano**: Idioma principal
- **Inglés**: Idioma secundario

### Cambio de Idioma
```dart
// En cualquier widget
context.read<LocaleProvider>().setLocale(const Locale('en'));
```

## 🧪 Testing

### Tipos de Tests
- **Unit Tests**: Lógica de negocio y servicios
- **Widget Tests**: Componentes de UI
- **Integration Tests**: Flujos completos
- **Golden Tests**: Consistencia visual

### Ejecutar Tests
```bash
# Todos los tests
flutter test

# Tests con coverage
flutter test --coverage

# Tests específicos
flutter test test/features/auth/
```

## 📱 Multiplataforma

### Soporte de Plataformas
- **Web**: PWA optimizada con responsive design
- **Android**: App nativa con Material Design 3
- **iOS**: App nativa con Cupertino Design

### Características Multiplataforma
- Desarrollo simultáneo para todas las plataformas
- Detección automática de plataforma con `kIsWeb`
- Navegación adaptada a cada plataforma
- Soporte offline para operaciones críticas
- Optimización específica por plataforma

## 🧪 Testing

### Tipos de Tests
- **Unit Tests**: Lógica de negocio y servicios
- **Widget Tests**: Componentes de UI
- **Integration Tests**: Flujos completos
- **Golden Tests**: Consistencia visual

### Ejecutar Tests
```bash
# Todos los tests
flutter test

# Tests con coverage
flutter test --coverage

# Tests específicos
flutter test test/features/auth/
```

## 🔒 Seguridad

### Principios de Seguridad
- Almacenamiento seguro de credenciales con `flutter_secure_storage`
- Validación de todas las entradas del usuario
- Rate limiting para APIs
- HTTPS obligatorio para todas las comunicaciones
- No almacenamiento de datos sensibles en SharedPreferences

## ♿ Accesibilidad

### Características de Accesibilidad
- Soporte completo para screen readers con `Semantics`
- Navegación por teclado con `FocusNode`
- Contraste de colores optimizado
- Alternativas de texto para imágenes
- Gestos alternativos para usuarios con discapacidades

## 🌍 Internacionalización

El proyecto soporta completamente dos idiomas:
- **Castellano**: Idioma principal
- **Inglés**: Idioma secundario

### Características i18n
- Pluralización correcta
- Formateo de fechas y números
- Soporte RTL (preparado para futuras expansiones)
- Cambio de idioma en tiempo real

### Cambio de Idioma
```dart
// En cualquier widget
context.read<LocaleProvider>().setLocale(const Locale('en'));
```

## 🚀 Performance

### Optimizaciones Implementadas
- Widgets `const` para optimización
- `RepaintBoundary` para widgets complejos
- Lazy loading para listas grandes
- `compute()` para operaciones pesadas
- Cache strategies en repositories

## 🔧 Desarrollo

### Git Workflow
- **Git Flow**: Gestión de ramas estructurada
- **Conventional Commits**: Formato estándar de commits
- **Pull Requests**: Code reviews obligatorios
- **GitHub Actions**: CI/CD automatizado

### Comandos de Desarrollo
```bash
# Generar código automáticamente
flutter packages pub run build_runner watch

# Analizar código
flutter analyze

# Formatear código
flutter format .

# Ejecutar tests
flutter test

# Build para producción
flutter build web --release
flutter build apk --release
```

## 📊 Monitoreo y Analytics

### Herramientas de Monitoreo
- **Error Reporting**: Firebase Crashlytics
- **Analytics**: Firebase Analytics
- **Performance**: Flutter Inspector
- **Logging**: Logger estructurado

## 📚 Documentación

### Documentos Disponibles
- **Guía de Desarrollo**: `FRONTEND_DEVELOPMENT_GUIDE.md`
- **Checklist de Desarrollo**: `DEVELOPMENT_CHECKLIST.md`
- **Recomendaciones Flutter**: `docs/FLUTTER_OFFICIAL_RECOMMENDATIONS_CHECKLIST.md`
- **Configuración OAuth**: `docs/GOOGLE_SIGN_IN_SETUP.md`
- **Implementación Auth Guard**: `docs/AUTH_GUARD_IMPLEMENTATION.md`

### Web (PWA)
- Service Worker para offline
- Instalación como app
- Notificaciones push
- SEO optimizado

### Móvil
- Android e iOS
- Notificaciones push
- Gestos nativos
- Offline capabilities

## 🔧 Desarrollo

### Workflow Git
```bash
# Crear feature
git checkout -b feature/nueva-funcionalidad

# Desarrollo con commits semánticos
git commit -m "feat: añadir sistema de autenticación"
git commit -m "test: añadir tests para auth service"

# Push y crear Pull Request
git push origin feature/nueva-funcionalidad
```

### Convenciones de Commits
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bugs
- `docs`: Documentación
- `style`: Formato de código
- `refactor`: Refactorización
- `test`: Tests
- `chore`: Tareas de mantenimiento

## 📊 Estado del Proyecto

### Progreso General: 42.3%
- **Fases Completadas**: 8/15
- **Tareas Completadas**: 47/111

### Próximas Fases
- Fase 10: Gestión de Archivos
- Fase 11: Notificaciones
- Fase 12: Reportes y Analytics
- Fase 13: Testing
- Fase 14: Optimización y Deploy

## 📚 Documentación

- [Guía de Desarrollo](FRONTEND_DEVELOPMENT_GUIDE.md)
- [Checklist de Desarrollo](DEVELOPMENT_CHECKLIST.md)
- [Recomendaciones Oficiales Flutter](docs/FLUTTER_OFFICIAL_RECOMMENDATIONS.md)
- [Configuración de Autenticación](docs/GOOGLE_SIGN_IN_SETUP.md)

## 🤝 Contribución

### Antes de Contribuir
1. Leer la [Guía de Desarrollo](FRONTEND_DEVELOPMENT_GUIDE.md)
2. Revisar las [Recomendaciones Oficiales](docs/FLUTTER_OFFICIAL_RECOMMENDATIONS.md)
3. Seguir las convenciones de código
4. Añadir tests para nuevas funcionalidades

### Proceso de Contribución
1. Fork del repositorio
2. Crear rama de feature
3. Implementar cambios
4. Añadir tests
5. Crear Pull Request
6. Code review
7. Merge

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](../LICENSE) para más detalles.

## 🆘 Soporte

- **Issues**: [GitHub Issues](https://github.com/tu-usuario/proyecto-fct-NetJs/issues)
- **Documentación**: [Guía de Desarrollo](FRONTEND_DEVELOPMENT_GUIDE.md)
- **Equipo**: Contactar al equipo de desarrollo

---

**Desarrollado con ❤️ siguiendo las mejores prácticas oficiales de Flutter**
