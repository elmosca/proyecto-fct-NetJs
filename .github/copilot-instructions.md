# Copilot Instructions - Proyecto FCT

## Arquitectura del Sistema

Este es un proyecto **full-stack** con arquitectura **Clean Architecture** que incluye:

- **Backend**: NestJS + TypeScript + PostgreSQL (puerto: `/backend`)
- **Frontend**: Flutter + Dart con Clean Architecture (puerto: `/frontend`)  
- **Patrones**: Repository, Service, Controller con inyección de dependencias

## 🎯 Flutter - Recomendaciones Fundamentales del Equipo Oficial

### ✅ 5 Recomendaciones Obligatorias
1. **Usa `const` constructors** siempre que sea posible
2. **Usa `SizedBox`** en lugar de `Container` para espaciado
3. **Usa `ListView.builder`** para listas largas
4. **Implementa `dispose()`** para limpiar recursos
5. **Usa `SliverAppBar`** para scroll effects complejos

## Convenciones Críticas

### Nomenclatura (Obligatorio)
- **Archivos/carpetas**: `underscore_case`
- **Clases**: `PascalCase`
- **Variables/métodos**: `camelCase`  
- **Constantes**: `UPPER_SNAKE_CASE`
- **Booleanos**: `isX`, `hasX`, `canX`

### Flutter - Arquitectura Específica
```
lib/
├── core/          # Configuración, constantes, extensiones
├── features/      # Módulos por característica
│   └── auth/
│       ├── data/       # Repositories, DataSources
│       ├── domain/     # Entities, UseCases
│       └── presentation/ # Widgets, Controllers
└── shared/        # Widgets/servicios compartidos
```

### Stack Tecnológico
- **Estado**: Riverpod con `@riverpod` generators
- **DI**: GetIt (`singleton`, `lazySingleton`, `factory`)
- **Navegación**: go_router (recomendación oficial)
- **Modelos**: Freezed + json_annotation
- **HTTP**: Dio para llamadas API
- **Testing**: flutter_test + mockito + integration_test

## 🚀 Performance y Optimización
- Usa `const` widgets para optimización
- Implementa `shouldRebuild` en `CustomPainter`
- Usa `RepaintBoundary` para widgets complejos
- Evita rebuilds innecesarios con `ValueNotifier`
- Usa `compute()` para operaciones pesadas
- Implementa lazy loading para listas grandes

## 📱 Multiplataforma
- **Web**: PWA optimizada con responsive design
- **Android**: App nativa con Material Design 3
- **iOS**: App nativa con Cupertino Design
- **Detección**: Usa `kIsWeb` para adaptación automática
- **Navegación**: Adaptada a cada plataforma

## 🔒 Seguridad
- Almacenamiento seguro con `flutter_secure_storage`
- Validación de todas las entradas del usuario
- Rate limiting para APIs
- HTTPS obligatorio para todas las comunicaciones

## ♿ Accesibilidad
- Soporte completo para screen readers con `Semantics`
- Navegación por teclado con `FocusNode`
- Contraste de colores optimizado
- Alternativas de texto para imágenes

## 🌍 Internacionalización
- Soporte completo para castellano e inglés
- Pluralización correcta
- Formateo de fechas y números
- Cambio de idioma en tiempo real

## Flujos de Desarrollo Críticos

### Antes de Programar
```bash
# Desde VSCode: Ctrl+Shift+P > Tasks: Run Task > "Flujo completo"
# O manualmente:
cd frontend
flutter clean && flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter analyze
```

### Backend - Comandos Esenciales
```bash
cd backend
npm run start:dev  # Desarrollo con hot reload
npm run test      # Tests unitarios
npm run test:e2e  # Tests de integración
```

### Snippets de Desarrollo
Usa prefijos `fl*` en VS Code:
- `flsw` → StatelessWidget con convenciones
- `flrepo` → Repository interface  
- `flcontroller` → Controller con Riverpod
- `fltest` → Test Arrange-Act-Assert
- `flroute` → Ruta con go_router
- `flmp` → Widget multiplataforma

## Patrones de Integración

### API Communication
- **Base URL**: Environment-dependent (`lib/core/config/`)
- **Auth**: JWT tokens via interceptors
- **Error Handling**: Custom exceptions con Result<T> pattern

### State Management Flow
```dart
// 1. Controller maneja UI state
@riverpod
class FeatureController extends _$FeatureController {
  // 2. Llama a Services
  final result = await ref.read(serviceProvider).action();
  // 3. Actualiza state según Result<T>
}
```

### Testing Approach  
- **Unit**: Repositories y Services con mocks
- **Widget**: UI components con testWidgets()
- **Integration**: E2E con real backend
- **Golden**: Tests para consistencia visual

## 🔧 Git Workflow
- **Git Flow**: Gestión de ramas estructurada
- **Conventional Commits**: Formato estándar de commits
- **Pull Requests**: Code reviews obligatorios
- **GitHub Actions**: CI/CD automatizado

## 📊 Gestión de Proyectos
- **GitHub Issues**: Tracking de tareas
- **Project Boards**: Gestión visual del progreso
- **Milestones**: Agrupación de funcionalidades
- **ADRs**: Decisiones de arquitectura documentadas

## Archivos Clave para Contexto
- `/frontend/lib/core/` - Configuración base
- `/backend/src/app.module.ts` - Módulos principales
- `/.vscode/` - Configuración completa de desarrollo
- `/backend/docs/` - Documentación técnica específica
- `/.cursor/rules/flutter.mdc` - Reglas completas del proyecto
