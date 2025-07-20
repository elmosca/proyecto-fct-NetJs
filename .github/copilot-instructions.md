# Copilot Instructions - Proyecto FCT

## Arquitectura del Sistema

Este es un proyecto **full-stack** con arquitectura **Clean Architecture** que incluye:

- **Backend**: NestJS + TypeScript + PostgreSQL (puerto: `/backend`)
- **Frontend**: Flutter + Dart con Clean Architecture (puerto: `/frontend`)  
- **Patrones**: Repository, Service, Controller con inyección de dependencias

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
- **Navegación**: AutoRoute
- **Modelos**: Freezed + json_annotation
- **HTTP**: Dio para llamadas API
- **Testing**: flutter_test + mockito

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

## Archivos Clave para Contexto
- `/frontend/lib/core/` - Configuración base
- `/backend/src/app.module.ts` - Módulos principales
- `/.vscode/` - Configuración completa de desarrollo
- `/backend/docs/` - Documentación técnica específica
