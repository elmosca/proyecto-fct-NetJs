# 🚀 Guía de Desarrollo Frontend - Sistema FCT

## 📋 Descripción General

Este documento define la arquitectura, patrones de diseño y guías de implementación para el desarrollo del frontend del Sistema de Gestión de Proyectos FCT utilizando Flutter con Clean Architecture.

## 🏗️ Arquitectura del Proyecto

### Clean Architecture - Estructura de Capas

```
lib/
├── core/                    # Capa de infraestructura y utilidades
│   ├── constants/          # Constantes de la aplicación
│   ├── di/                 # Inyección de dependencias (GetIt)
│   ├── exceptions/         # Excepciones personalizadas
│   ├── extensions/         # Extensiones de Dart
│   ├── i18n/              # Internacionalización
│   ├── interceptors/       # Interceptores HTTP
│   ├── providers/          # Providers de estado global
│   ├── routes/             # Configuración de rutas (AutoRoute)
│   ├── services/           # Servicios base (HTTP, Auth, Storage)
│   ├── theme/              # Configuración de temas
│   ├── utils/              # Utilidades generales
│   └── widgets/            # Widgets base reutilizables
├── features/               # Capa de características (módulos)
│   ├── auth/              # Módulo de autenticación
│   │   ├── data/          # Capa de datos
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   ├── domain/        # Capa de dominio
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/  # Capa de presentación
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── providers/
│   ├── dashboard/         # Módulo de dashboard
│   ├── projects/          # Módulo de proyectos
│   ├── users/             # Módulo de usuarios
│   └── notifications/     # Módulo de notificaciones
├── shared/                # Recursos compartidos
│   ├── models/            # Modelos de datos compartidos
│   └── widgets/           # Widgets compartidos
└── main.dart              # Punto de entrada
```

## 🎯 Principios de Diseño

### 1. Clean Architecture
- **Separación de responsabilidades**: Cada capa tiene una responsabilidad específica
- **Independencia de frameworks**: El dominio no depende de Flutter
- **Testabilidad**: Cada capa puede ser testeada independientemente
- **Independencia de UI**: La lógica de negocio no depende de la interfaz

### 2. SOLID Principles
- **Single Responsibility**: Cada clase tiene una única responsabilidad
- **Open/Closed**: Abierto para extensión, cerrado para modificación
- **Liskov Substitution**: Las subclases pueden sustituir a las clases base
- **Interface Segregation**: Interfaces específicas para cada cliente
- **Dependency Inversion**: Depender de abstracciones, no de implementaciones

### 3. DRY (Don't Repeat Yourself)
- Reutilizar código común
- Crear widgets base reutilizables
- Centralizar lógica de negocio

## 🔧 Stack Tecnológico

### Dependencias Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  
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
  flutter_localizations:
    sdk: flutter
  
  # Utilidades
  intl: ^0.18.1
  logger: ^2.0.2+1
  url_launcher: ^6.2.2
  image_picker: ^1.0.4
  file_picker: ^6.1.1

dev_dependencies:
  # Generación de código
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  auto_route_generator: ^7.3.2
  
  # Testing
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.7
```

## 📱 Patrones de Implementación

### 1. Patrón Repository
```dart
// Domain Layer - Repository Interface
abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> loginWithGoogle();
  Future<void> logout();
  Future<User> getCurrentUser();
}

// Data Layer - Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;
  
  AuthRepositoryImpl(this._authDataSource, this._userDataSource);
  
  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final authData = await _authDataSource.login(email, password);
      final user = await _userDataSource.getUser(authData.userId);
      return AuthResult.success(user, authData.token);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }
}
```

### 2. Patrón UseCase
```dart
// Domain Layer - UseCase
class LoginUseCase {
  final AuthRepository _authRepository;
  
  LoginUseCase(this._authRepository);
  
  Future<AuthResult> execute(String email, String password) {
    return _authRepository.login(email, password);
  }
}

// Presentation Layer - Provider
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  FutureOr<void> build() {}
  
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase.execute(email, password);
    
    result.when(
      success: (user, token) {
        // Manejar éxito
        state = const AsyncValue.data(null);
      },
      failure: (error) {
        // Manejar error
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }
}
```

### 3. Patrón State Management con Riverpod
```dart
// State Classes
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// Providers
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() {
    return _checkAuthStatus();
  }
  
  Future<AuthState> _checkAuthStatus() async {
    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      return AuthState.authenticated(user);
    } catch (e) {
      return const AuthState.unauthenticated();
    }
  }
  
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(loginUseCaseProvider).execute(email, password);
    
    state = result.when(
      success: (user, token) => AsyncValue.data(AuthState.authenticated(user)),
      failure: (error) => AsyncValue.data(AuthState.error(error)),
    );
  }
}
```

## 🎨 Patrones de UI

### 1. Widgets Base Reutilizables
```dart
// Core Widgets
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonStyle? style;
  
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.style,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(text),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
```

### 2. Layouts Responsivos
```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 650) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

## 🎨 Diseño UI/UX y Prototipado

### 1. Herramientas de Diseño y Prototipado

Para el diseño de la interfaz de usuario y la creación de prototipos interactivos, se definen las siguientes herramientas principales:

-   **Diseño de Interfaz (UI): Figma**. Es la herramienta seleccionada para el diseño visual de las interfaces, la creación de sistemas de diseño y la colaboración en tiempo real. Desde aquí se exportarán los assets y especificaciones de diseño.
-   **Prototipado Interactivo: Stitch de Google**. Es la herramienta principal para la creación de prototipos interactivos y la organización de bibliotecas de componentes de UI. Su función es crucial para probar los flujos de usuario y validar la experiencia antes de la implementación en código.
-   **Alternativas**: Adobe XD o Sketch pueden ser consideradas como alternativas para el diseño de UI si el equipo de diseño lo requiere.

### 2. Flujo de Trabajo Diseño-Desarrollo

1.  **Diseño en Figma**: Se crea una maqueta de alta fidelidad de las pantallas.
2.  **Prototipado en Stitch**: Los diseños de Figma se importan o recrean en Stitch para construir un prototipo interactivo que simule el flujo real de la aplicación.
3.  **Revisión y Feedback**: El equipo revisa el prototipo interactivo de Stitch.
4.  **Hand-off a Desarrollo**: Los desarrolladores utilizan el diseño final de Figma para las especificaciones visuales y el prototipo de Stitch como guía para la lógica de navegación y la interacción del usuario.

## 🔐 Autenticación y Autorización

### 1. Gestión de Tokens
```dart
class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  final SharedPreferences _prefs;
  
  TokenManager(this._prefs);
  
  Future<void> saveTokens(String token, String refreshToken) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }
  
  String? get token => _prefs.getString(_tokenKey);
  String? get refreshToken => _prefs.getString(_refreshTokenKey);
  
  Future<void> clearTokens() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
  }
}
```

### 2. Interceptor HTTP
```dart
class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  final AuthRepository _authRepository;
  
  AuthInterceptor(this._tokenManager, this._authRepository);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenManager.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expirado, intentar refresh
      try {
        final newToken = await _authRepository.refreshToken();
        // Reintentar request original
        final response = await _retryRequest(err.requestOptions, newToken);
        handler.resolve(response);
        return;
      } catch (e) {
        // Refresh falló, redirigir a login
        await _authRepository.logout();
      }
    }
    handler.next(err);
  }
}

### 3. Estrategias de Autenticación de Terceros

Para la autenticación con proveedores externos como Google, se evaluaron varias estrategias. La elección final impacta en la arquitectura tanto del frontend como del backend.

#### a) Google Identity Services (Integración Directa)

-   **Descripción**: Utilizar el SDK oficial de Google para Flutter (`google_sign_in`) para obtener un `id_token` en el cliente. Este token se envía al backend (NestJS), que lo verifica con los endpoints de Google y, si es válido, crea una sesión local (JWT propio) para el usuario.
-   **Plataformas soportadas**: Web (Flutter Web) y Android (Flutter Android)
-   **Configuración requerida**: 
    -   Cliente OAuth Web para Flutter Web
    -   Cliente OAuth Android para Flutter Android  
    -   Cliente OAuth Backend para validación (ya configurado)
-   **Pros**:
    -   **Control total**: El backend gestiona los usuarios y las sesiones.
    -   **Menor dependencia**: No se depende de un intermediario (BaaS).
    -   **Integración limpia**: Se acopla perfectamente con nuestro backend de NestJS existente.
    -   **Multiplataforma**: Funciona tanto en web como en móvil con el mismo backend.
-   **Contras**:
    -   **Más implementación**: El backend debe implementar la lógica de validación de tokens.
    -   **Configuración compleja**: Requiere múltiples clientes OAuth.
-   **Decisión**: ✅ **Estrategia seleccionada**. Es la que mejor se alinea con nuestra Clean Architecture y nos da más control sobre el flujo de usuarios en ambas plataformas.

#### b) Firebase Authentication

-   **Descripción**: Utilizar Firebase como un servicio de autenticación gestionado. El cliente se comunica con Firebase para el login, y Firebase emite su propio token. El backend puede verificar este token de Firebase.
-   **Pros**:
    -   **Rápido de implementar**: Abstrae gran parte de la complejidad.
    -   **Múltiples proveedores**: Facilita añadir login con Facebook, Apple, etc.
    -   **Seguridad gestionada**: Google gestiona la seguridad del flujo de autenticación.
-   **Contras**:
    -   **Dependencia de terceros**: Añade una dependencia fuerte de la plataforma Firebase.
    -   **Sincronización de usuarios**: Requiere sincronizar la base de datos de usuarios de Firebase con la nuestra (PostgreSQL).
-   **Decisión**: Descartado para mantener la independencia del backend.

#### c) Cloudflare Access / Zero Trust

-   **Descripción**: Proteger las rutas de la API a nivel de infraestructura. Cloudflare se encarga de mostrar la página de login (de Google u otro proveedor) antes de permitir que la petición llegue a nuestro backend.
-   **Pros**:
    -   **Seguridad a nivel de red**: Protege los endpoints antes de que toquen el código de la aplicación.
    -   **Configuración centralizada**: Gestionado desde el dashboard de Cloudflare.
-   **Contras**:
    -   **Poco flexible**: Es más una solución de "todo o nada" por ruta. No se integra bien con la lógica de la aplicación (e.g., "este usuario puede ver esto pero no aquello").
    -   **Orientado a sitios, no a APIs para apps**: Es más adecuado para proteger dashboards internos que una API pública consumida por una app móvil.
-   **Decisión**: Descartado por su rigidez y falta de integración con la lógica de la aplicación.

#### d) Backend-as-a-Service (BaaS) como MongoDB Realm

-   **Descripción**: Utilizar un servicio de BaaS como **MongoDB Realm** (conocido anteriormente como **MongoDB Stitch**). Estos servicios gestionan la autenticación de usuarios de forma externa.
-   **Pros**:
    -   **Bien integrado con su ecosistema**: Si usáramos MongoDB como base de datos principal, Realm sería una opción muy potente.
    -   **Funciones serverless**: Permite ejecutar lógica en la nube sin un backend propio.
-   **Contras**:
    -   **Complejidad añadida**: Introduce otro ecosistema completo (BaaS) cuando ya tenemos un backend de NestJS.
    -   **Redundancia**: Realizaría funciones que nuestro backend ya hace o hará.
-   **Decisión**: Descartado por redundancia con nuestro stack actual. **Aclaración**: Este servicio no debe confundirse con herramientas de diseño UI que puedan tener un nombre similar.

## 🌍 Internacionalización

### 1. Configuración i18n
```dart
// lib/core/i18n/app_localizations.dart
class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
  
  static const List<Locale> supportedLocales = [
    Locale('es', ''), // Español
    Locale('en', ''), // Inglés
  ];
  
  // Métodos de traducción
  String get loginTitle {
    switch (locale.languageCode) {
      case 'es':
        return 'Iniciar Sesión';
      case 'en':
        return 'Login';
      default:
        return 'Login';
    }
  }
}
```

### 2. Provider de Idioma
```dart
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    return const Locale('es', '');
  }
  
  void setLocale(Locale locale) {
    state = locale;
  }
  
  void setLocaleFromLanguageCode(String languageCode) {
    state = Locale(languageCode, '');
  }
}
```

## 🧪 Testing

### 1. Tests Unitarios
```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });
  
  group('LoginUseCase', () {
    const email = 'test@example.com';
    const password = 'password123';
    
    test('should return AuthResult.success when login is successful', () async {
      // Arrange
      final user = User(id: '1', email: email, name: 'Test User');
      final token = 'valid_token';
      final expectedResult = AuthResult.success(user, token);
      
      when(mockRepository.login(email, password))
          .thenAnswer((_) async => expectedResult);
      
      // Act
      final result = await useCase.execute(email, password);
      
      // Assert
      expect(result, equals(expectedResult));
      verify(mockRepository.login(email, password)).called(1);
    });
  });
}
```

### 2. Tests de Widgets
```dart
// test/features/auth/presentation/pages/login_page_test.dart
void main() {
  testWidgets('LoginPage should show login form', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const LoginPage(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    
    // Assert
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email y password
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
```

## 📊 Gestión de Estado

### 1. Providers Globales
```dart
// lib/core/providers/global_providers.dart
@riverpod
class GlobalNotifier extends _$GlobalNotifier {
  @override
  GlobalState build() {
    return const GlobalState();
  }
  
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
  
  void setError(String? error) {
    state = state.copyWith(error: error);
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

@freezed
class GlobalState with _$GlobalState {
  const factory GlobalState({
    @Default(false) bool isLoading,
    String? error,
    @Default('es') String currentLanguage,
  }) = _GlobalState;
}
```

### 2. Providers de Características
```dart
// lib/features/auth/presentation/providers/auth_providers.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() {
    return _checkAuthStatus();
  }
  
  Future<AuthState> _checkAuthStatus() async {
    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      return AuthState.authenticated(user);
    } catch (e) {
      return const AuthState.unauthenticated();
    }
  }
  
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(loginUseCaseProvider).execute(email, password);
    
    state = result.when(
      success: (user, token) => AsyncValue.data(AuthState.authenticated(user)),
      failure: (error) => AsyncValue.data(AuthState.error(error)),
    );
  }
  
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }
}
```

## 🚀 Navegación

### 1. Configuración de Rutas
```dart
// lib/core/routes/app_router.dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
        ),
        AutoRoute(
          path: '/register',
          page: RegisterRoute.page,
        ),
        AutoRoute(
          path: '/dashboard',
          page: DashboardRoute.page,
          children: [
            AutoRoute(
              path: 'projects',
              page: ProjectsRoute.page,
            ),
            AutoRoute(
              path: 'users',
              page: UsersRoute.page,
            ),
            AutoRoute(
              path: 'profile',
              page: ProfileRoute.page,
            ),
          ],
        ),
      ];
}
```

### 2. Guardias de Ruta
```dart
class AuthGuard extends AutoRouteGuard {
  final AuthRepository _authRepository;
  
  AuthGuard(this._authRepository);
  
  @override
  Future<bool> canNavigate(NavigationResolver resolver, StackRouter router) async {
    try {
      final user = await _authRepository.getCurrentUser();
      return user != null;
    } catch (e) {
      router.push(const LoginRoute());
      return false;
    }
  }
}
```

## 📱 Responsive Design

### 1. Breakpoints
```dart
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= desktop;
}
```

### 2. Layouts Adaptativos
```dart
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        if (AppBreakpoints.isDesktop(width)) {
          return desktop ?? tablet ?? mobile;
        } else if (AppBreakpoints.isTablet(width)) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

## 🔧 Configuración de Desarrollo

### 1. Inyección de Dependencias
```dart
// lib/core/di/injection_container.dart
final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  getIt.registerLazySingleton<Logger>(() => Logger());
  getIt.registerLazySingleton<TokenManager>(() => TokenManager(SharedPreferences.getInstance()));
  
  // Services
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    getIt<AuthDataSource>(),
    getIt<UserDataSource>(),
  ));
  
  // Use Cases
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt<AuthRepository>()));
}
```

### 2. Configuración de Temas
```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      // Configuración específica para tema oscuro
    );
  }
}
```

## 📋 Checklist de Implementación

### Para cada Feature:
- [ ] Crear estructura de carpetas (data, domain, presentation)
- [ ] Implementar entidades del dominio
- [ ] Definir interfaces de repositorio
- [ ] Implementar casos de uso
- [ ] Crear providers de estado
- [ ] Implementar páginas y widgets
- [ ] Configurar rutas
- [ ] Escribir tests unitarios
- [ ] Escribir tests de widgets
- [ ] Documentar la implementación

### Para cada Widget:
- [ ] Hacer el widget reutilizable
- [ ] Implementar responsive design
- [ ] Agregar soporte para i18n
- [ ] Manejar estados de loading y error
- [ ] Implementar accesibilidad
- [ ] Escribir tests

## 🎯 Mejores Prácticas

### 1. Código Limpio
- Nombres descriptivos y significativos
- Funciones pequeñas y con una sola responsabilidad
- Evitar código duplicado
- Comentarios explicativos cuando sea necesario

### 2. Performance
- Usar `const` constructors cuando sea posible
- Implementar lazy loading para listas grandes
- Optimizar rebuilds con `select` en Riverpod
- Usar `ListView.builder` para listas largas

### 3. Accesibilidad
- Agregar `semanticsLabel` a widgets importantes
- Usar colores con suficiente contraste
- Implementar navegación por teclado
- Proporcionar alternativas de texto para imágenes

### 4. Testing
- Tests unitarios para lógica de negocio
- Tests de widgets para componentes UI
- Tests de integración para flujos completos
- Mantener coverage de código alto

## 📚 Recursos Adicionales

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [AutoRoute Documentation](https://autoroute.dev/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)

---

**Última actualización**: 2025-07-28
**Versión**: 1.0.0 