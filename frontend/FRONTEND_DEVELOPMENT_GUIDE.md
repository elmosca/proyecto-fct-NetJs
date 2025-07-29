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

- [ ] **3.1** Pantalla de login (email/password)
- [ ] **3.2** Integración con Google OAuth
- [ ] **3.3** Pantalla de registro
- [ ] **3.4** Recuperación de contraseña
- [ ] **3.5** Gestión de tokens JWT
- [ ] **3.6** Middleware de autenticación
- [ ] **3.7** Tests de autenticación

### **Fase 4: Dashboard y Navegación** ⏱️ 1 semana

- [ ] **4.1** Layout principal con navegación
- [ ] **4.2** Dashboard principal
- [ ] **4.3** Menú lateral (drawer)
- [ ] **4.4** Navegación por roles
- [ ] **4.5** Breadcrumbs y navegación

### **Fase 5: Gestión de Usuarios** ⏱️ 1-2 semanas

- [ ] **5.1** Lista de usuarios (con filtros y búsqueda)
- [ ] **5.2** Perfil de usuario
- [ ] **5.3** Edición de perfil
- [ ] **5.4** Gestión de roles y permisos
- [ ] **5.5** Creación de usuarios (admin)
- [ ] **5.6** Tests de usuarios

### **Fase 6: Gestión de Proyectos** ⏱️ 2-3 semanas

- [ ] **6.1** Lista de proyectos
- [ ] **6.2** Creación de proyectos
- [ ] **6.3** Detalle de proyecto
- [ ] **6.4** Edición de proyectos
- [ ] **6.5** Asignación de estudiantes
- [ ] **6.6** Gestión de tutores
- [ ] **6.7** Tests de proyectos

### **Fase 7: Sistema de Anteproyectos** ⏱️ 3-4 semanas

- [ ] **7.1** Lista de anteproyectos
- [ ] **7.2** Creación de anteproyectos
- [ ] **7.3** Detalle de anteproyecto
- [ ] **7.4** Ciclo de vida completo:
  - [ ] Submit para revisión
  - [ ] Revisión por tutores
  - [ ] Aprobación/rechazo
  - [ ] Programación de defensa
  - [ ] Completado
- [ ] **7.5** Sistema de archivos adjuntos
- [ ] **7.6** Tests de anteproyectos

### **Fase 8: Kanban de Tareas** ⏱️ 2-3 semanas

- [ ] **8.1** Vista Kanban con drag & drop
- [ ] **8.2** Creación de tareas
- [ ] **8.3** Edición de tareas
- [ ] **8.4** Asignación de usuarios
- [ ] **8.5** Cambio de estado (drag & drop)
- [ ] **8.6** Filtros y búsqueda
- [ ] **8.7** Tests de tareas

### **Fase 9: Sistema de Comentarios** ⏱️ 1-2 semanas

- [ ] **9.1** Comentarios en tareas
- [ ] **9.2** Comentarios en proyectos
- [ ] **9.3** Editor de comentarios (markdown)
- [ ] **9.4** Notificaciones de comentarios
- [ ] **9.5** Tests de comentarios

### **Fase 10: Notificaciones** ⏱️ 1-2 semanas

- [ ] **10.1** WebSocket connection
- [ ] **10.2** Notificaciones en tiempo real
- [ ] **10.3** Centro de notificaciones
- [ ] **10.4** Notificaciones push (mobile)
- [ ] **10.5** Configuración de notificaciones
- [ ] **10.6** Tests de notificaciones

### **Fase 11: Sistema de Evaluaciones** ⏱️ 2-3 semanas

- [ ] **11.1** Criterios de evaluación
- [ ] **11.2** Formularios de evaluación
- [ ] **11.3** Calificaciones
- [ ] **11.4** Reportes de evaluación
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

## 🔄 Workflow de Desarrollo

### Estrategia de Ramas por Fases

El proyecto utiliza una estrategia de desarrollo basada en **fases funcionales** con una rama por fase:

```
main (producción)
├── develop (integración)
├── feature/fase1-configuracion-base
├── feature/fase2-core-shared
├── feature/fase3-autenticacion
├── feature/fase4-dashboard
├── feature/fase5-gestion-usuarios ✅
├── feature/fase6-gestion-proyectos 🔄
├── feature/fase7-anteproyectos
└── feature/fase8-tareas-milestones
```

### Proceso de Desarrollo por Fase

1. **Crear rama de fase**: `feature/faseX-nombre-fase`
2. **Desarrollar tareas incrementales**: Cada tarea se desarrolla y commitea por separado
3. **Actualizar checklist**: Documentar progreso en `DEVELOPMENT_CHECKLIST.md`
4. **Merge a develop**: Al completar toda la fase
5. **Crear siguiente rama**: Para la nueva fase

### Estructura de Commits

```bash
# Formato de commit por tarea
git commit -m "feat(module): implementar funcionalidad específica - Tarea X.Y

- Descripción detallada de cambios
- Funcionalidades implementadas
- Archivos modificados/creados

Progreso Fase X: Y/Z tareas completadas (P%)"
```

### Problemas Identificados y Soluciones

#### ⚠️ Problema: Pérdida de Archivos de Seguimiento

**Descripción del Problema:**
- Los archivos `DEVELOPMENT_CHECKLIST.md` y `FRONTEND_DEVELOPMENT_GUIDE.md` se pierden al cambiar de ramas
- Causado por conflictos con archivos generados automáticamente por Flutter
- Error: `PathAccessException: Deletion failed` durante `build_runner`

**Archivos Afectados:**
```
frontend/.flutter-plugins-dependencies
frontend/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java
frontend/android/local.properties
```

**Solución Implementada:**
1. **Scripts de recuperación**: `frontend/scripts/restore_docs.ps1` y `restore_docs.sh`
2. **Commit de referencia**: `0af93a5` contiene versiones estables de los documentos
3. **Recuperación automática**: Scripts restauran documentos desde el commit de referencia

**Uso de los Scripts:**
```bash
# Windows (PowerShell)
cd frontend && .\scripts\restore_docs.ps1

# Linux/Mac (Bash)
cd frontend && ./scripts/restore_docs.sh
```

#### 🔧 Estrategia de Desarrollo Adaptada

**Problema con Merge a Develop:**
- Cambios de rama fallan debido a archivos generados por Flutter
- Merge manual complejo por conflictos de archivos automáticos

**Solución Adoptada:**
1. **Desarrollo continuo**: Mantener desarrollo en rama de fase actual
2. **Commits incrementales**: Cada tarea se commitea por separado
3. **Merge diferido**: Realizar merge a `develop` al final de la fase
4. **Documentación preservada**: Usar scripts de recuperación cuando sea necesario

**Ventajas de esta Estrategia:**
- ✅ **Desarrollo fluido**: Sin interrupciones por problemas de merge
- ✅ **Progreso visible**: Commits incrementales documentan avances
- ✅ **Rollback fácil**: Cada tarea es un commit independiente
- ✅ **Documentación preservada**: Scripts mantienen archivos de seguimiento

### Comandos de Desarrollo Frecuentes

```bash
# Recuperar documentos de seguimiento
cd frontend && .\scripts\restore_docs.ps1

# Crear nueva rama de fase
git checkout -b feature/faseX-nombre-fase

# Commit de tarea completada
git add .
git commit -m "feat(module): descripción - Tarea X.Y"

# Actualizar checklist
git add frontend/DEVELOPMENT_CHECKLIST.md
git commit -m "docs: actualizar progreso - Tarea X.Y completada"

# Push de cambios
git push origin feature/faseX-nombre-fase
```

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

- **Fase actual**: Fase 4 - Dashboard y Navegación (Completada)
- **Progreso total**: 26.1% (29/111 tareas)
- **Tareas completadas**: 29/111
- **Semanas transcurridas**: 4

### **Últimas Actualizaciones**

- **2025-07-28**: Completada Fase 4 - Dashboard y Navegación
- **2025-07-28**: Implementada búsqueda global y notificaciones push
- **Próxima actualización**: 2025-08-01

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

**Última actualización**: 2025-07-28
**Próxima revisión**: 2025-08-01
**Responsable**: Equipo de desarrollo frontend

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