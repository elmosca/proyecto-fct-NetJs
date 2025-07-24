# Frontend - Proyecto FCT

## 📱 Descripción

Frontend de la aplicación móvil para la gestión de proyectos FCT, desarrollado con Flutter siguiendo principios de Clean Architecture.

## 🚧 Estado Actual

**⚠️ EN DESARROLLO** - El frontend se encuentra en fase inicial de desarrollo.

### ✅ Completado

- ✅ Estructura básica del proyecto Flutter
- ✅ Configuración inicial de Android
- ✅ Configuración de VS Code para desarrollo

### 🔄 En Desarrollo

- 🔄 Arquitectura Clean Architecture
- 🔄 Sistema de autenticación con Google OAuth
- 🔄 Gestión de estado con Riverpod
- 🔄 Navegación con AutoRoute
- 🔄 Integración con backend NestJS

### 📋 Pendiente

- 📋 Implementación de pantallas principales
- 📋 Sistema de gestión de proyectos
- 📋 Sistema de tareas y comentarios
- 📋 Gestión de archivos
- 📋 Sistema de evaluaciones
- 📋 Testing completo

## 🏗️ Arquitectura Planificada

```
lib/
├── core/                    # Configuración y utilidades
│   ├── config/             # Configuración de la app
│   ├── constants/          # Constantes globales
│   ├── extensions/         # Extensiones de Dart
│   └── utils/              # Utilidades comunes
├── features/               # Módulos por característica
│   ├── auth/              # Autenticación
│   │   ├── data/          # Repositories, DataSources
│   │   ├── domain/        # Entities, UseCases
│   │   └── presentation/  # Widgets, Controllers
│   ├── projects/          # Gestión de proyectos
│   ├── tasks/             # Gestión de tareas
│   └── evaluations/       # Sistema de evaluaciones
└── shared/                # Componentes compartidos
    ├── widgets/           # Widgets reutilizables
    ├── services/          # Servicios compartidos
    └── models/            # Modelos de datos
```

## 🛠️ Stack Tecnológico Planificado

- **Framework**: Flutter + Dart
- **Arquitectura**: Clean Architecture
- **Estado**: Riverpod con `@riverpod` generators
- **Navegación**: AutoRoute
- **DI**: GetIt
- **Modelos**: Freezed + json_annotation
- **HTTP**: Dio para llamadas API
- **Testing**: flutter_test + mockito

## 📋 Requisitos Previos

- **Flutter**: Versión 3.16.0 o superior
- **Dart**: Versión 3.0.0 o superior
- **Android Studio** / **VS Code**
- **Android SDK** / **iOS SDK** (para desarrollo móvil)

### Instalación de Flutter

```bash
# Verificar versión actual
flutter --version

# Si necesitas actualizar Flutter
flutter upgrade
```

## 🚀 Configuración del Entorno

### 1. Instalar Dependencias

```bash
cd frontend
flutter pub get
```

### 2. Generar Código

```bash
# Generar código con build_runner
flutter packages pub run build_runner build --delete-conflicting-outputs

# Para desarrollo continuo
flutter packages pub run build_runner watch
```

### 3. Ejecutar la Aplicación

```bash
# Desarrollo
flutter run

# Con dispositivo específico
flutter run -d <device-id>

# Modo debug
flutter run --debug

# Modo release
flutter run --release
```

## 🔧 Scripts Disponibles

```bash
# Análisis de código
flutter analyze

# Formatear código
dart format .

# Tests
flutter test

# Tests con cobertura
flutter test --coverage

# Limpiar proyecto
flutter clean

# Obtener dependencias
flutter pub get
```

## 📱 Configuración de Dispositivos

### Android

- Android SDK instalado
- Dispositivo Android conectado o emulador ejecutándose
- `flutter doctor` debe mostrar Android como configurado

### iOS (macOS)

- Xcode instalado
- Simulador iOS o dispositivo físico
- Certificados de desarrollo configurados

## 🔗 Integración con Backend

### Configuración de API

- URL base configurada en `lib/core/config/`
- Autenticación JWT implementada
- Interceptores para manejo de errores

### Variables de Entorno

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
}
```

## 🧪 Testing

### Tests Unitarios

```bash
# Ejecutar todos los tests
flutter test

# Tests específicos
flutter test test/auth_test.dart

# Tests con cobertura
flutter test --coverage
```

### Tests de Widget

```dart
// Ejemplo de test de widget
testWidgets('Login button shows loading state', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  // Test implementation
});
```

## 📦 Build y Despliegue

### Android APK

```bash
# Build debug
flutter build apk --debug

# Build release
flutter build apk --release

# Build para diferentes arquitecturas
flutter build apk --split-per-abi
```

### Android App Bundle

```bash
flutter build appbundle
```

### Web

```bash
flutter build web
```

## 🔍 Debugging

### VS Code

- Configuración de debugging incluida en `.vscode/launch.json`
- Breakpoints y hot reload disponibles
- Extensiones recomendadas configuradas

### Flutter Inspector

```bash
# Abrir Flutter Inspector
flutter run --debug
# Luego presiona 'i' en la terminal
```

## 📚 Documentación Adicional

- [Documentación de Flutter](https://flutter.dev/docs)
- [Clean Architecture en Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [AutoRoute Documentation](https://autoroute.dev/)

## 🤝 Contribuir

Para contribuir al frontend:

1. Sigue las convenciones establecidas en `.github/copilot-instructions.md`
2. Usa los snippets de VS Code configurados
3. Escribe tests para nuevas funcionalidades
4. Mantén la arquitectura Clean Architecture

## 📞 Soporte

Para preguntas sobre el frontend:

- 📧 Email: [jualas@gmail.com]
- 📱 Issues: [GitHub Issues](https://github.com/elmosca/proyecto-fct-NetJs/issues)

---

**Nota**: Este frontend está en desarrollo activo. La documentación se actualizará conforme avance el desarrollo.
