# Implementación de las 5 Recomendaciones Fundamentales del Equipo Flutter

## 1. Separación de Concernidos (STRONGLY RECOMMEND)

### Estructura de Carpetas Recomendada
```
lib/
├── core/
│   ├── di/
│   ├── services/
│   └── utils/
├── features/
│   └── home/
│       ├── data/
│       │   ├── repositories/
│       │   └── datasources/
│       ├── domain/
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── viewmodels/
└── shared/
    └── ui/
        └── core/
```

### Ejemplo de Implementación

```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getUsers();
}

// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserApiService _apiService;
  
  UserRepositoryImpl(this._apiService);
  
  @override
  Future<User> getUser(String id) async {
    return await _apiService.fetchUser(id);
  }
}

// presentation/viewmodels/home_viewmodel.dart
class HomeViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  
  HomeViewModel(this._userRepository);
  
  Future<void> loadUsers() async {
    // Lógica de negocio aquí
    final users = await _userRepository.getUsers();
    // Actualizar UI
  }
}

// presentation/screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        // Solo lógica de presentación
        return Scaffold(
          body: ListView.builder(
            itemBuilder: (context, index) => UserCard(),
          ),
        );
      },
    );
  }
}
```

## 2. Inyección de Dependencias (STRONGLY RECOMMEND)

### Configuración con getIt

```dart
// core/di/injection_container.dart
final getIt = GetIt.instance;

Future<void> init() async {
  // Services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(),
  );
  
  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<ApiService>()),
  );
  
  // ViewModels
  getIt.registerFactory<HomeViewModel>(
    () => HomeViewModel(getIt<UserRepository>()),
  );
}

// main.dart
void main() async {
  await init();
  runApp(MyApp());
}
```

### Configuración con Riverpod

```dart
// core/providers/providers.dart
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(apiServiceProvider));
});

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel(ref.read(userRepositoryProvider));
});
```

## 3. Navegación con go_router (RECOMMEND)

### Configuración de Rutas

```dart
// core/routes/app_router.dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/users/:id',
      name: 'user-details',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserDetailsScreen(userId: userId);
      },
    ),
  ],
  redirect: (context, state) {
    // Guards de autenticación
    final isLoggedIn = getIt<AuthService>().isLoggedIn;
    if (!isLoggedIn && state.matchedLocation != '/login') {
      return '/login';
    }
    return null;
  },
);

// Uso en widgets
ElevatedButton(
  onPressed: () => context.goNamed('user-details', pathParameters: {'id': '123'}),
  child: Text('Ver Usuario'),
)
```

## 4. Convenciones de Nombres Estándar (RECOMMEND)

### Nomenclatura Correcta

```dart
// ✅ CORRECTO
class HomeViewModel extends ChangeNotifier { }
class UserRepository { }
class ClientApiService { }
class HomeScreen extends StatelessWidget { }
class UserCard extends StatelessWidget { }

// ❌ INCORRECTO
class HomeController { }  // Se confunde con Flutter
class UserService { }     // Muy genérico
class ApiClient { }       // No sigue convención
```

### Estructura de Carpetas

```dart
// ✅ CORRECTO
lib/
├── ui/
│   └── core/
│       ├── buttons/
│       ├── cards/
│       └── dialogs/
└── features/
    └── home/
        └── presentation/
            ├── screens/
            └── widgets/

// ❌ INCORRECTO
lib/
├── widgets/  // No usar widgets/ directamente
└── features/
    └── home/
        └── ui/  // No usar ui/ en features
```

## 5. Repositorios Abstractos (STRONGLY RECOMMEND)

### Implementación Completa

```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getUsers();
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
}

// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserApiService _apiService;
  final UserLocalDataSource _localDataSource;
  
  UserRepositoryImpl(this._apiService, this._localDataSource);
  
  @override
  Future<User> getUser(String id) async {
    try {
      // Intentar obtener de cache local primero
      final cachedUser = await _localDataSource.getUser(id);
      if (cachedUser != null) {
        return cachedUser;
      }
      
      // Si no está en cache, obtener de API
      final user = await _apiService.fetchUser(id);
      
      // Guardar en cache
      await _localDataSource.saveUser(user);
      
      return user;
    } catch (e) {
      // Fallback a cache si API falla
      final cachedUser = await _localDataSource.getUser(id);
      if (cachedUser != null) {
        return cachedUser;
      }
      rethrow;
    }
  }
  
  @override
  Future<List<User>> getUsers() async {
    // Implementar paginación y cache
    final users = await _apiService.fetchUsers();
    await _localDataSource.saveUsers(users);
    return users;
  }
}

// data/datasources/user_local_data_source.dart
abstract class UserLocalDataSource {
  Future<User?> getUser(String id);
  Future<void> saveUser(User user);
  Future<void> saveUsers(List<User> users);
}

// data/datasources/user_local_data_source_impl.dart
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Database _database;
  
  UserLocalDataSourceImpl(this._database);
  
  @override
  Future<User?> getUser(String id) async {
    // Implementación con SQLite/Hive/etc
  }
}
```

## Beneficios de Implementar Estas Recomendaciones

1. **Mantenibilidad**: Código más fácil de mantener y modificar
2. **Testabilidad**: Testing más sencillo con abstracciones
3. **Escalabilidad**: Fácil agregar nuevas features
4. **Reutilización**: Componentes reutilizables entre features
5. **Consistencia**: Patrones consistentes en toda la aplicación
6. **Performance**: Mejor gestión de memoria y recursos
7. **Debugging**: Más fácil identificar y resolver problemas

## Checklist de Implementación

- [ ] Separar lógica de negocio de UI
- [ ] Implementar inyección de dependencias
- [ ] Migrar a go_router para navegación
- [ ] Seguir convenciones de nombres estándar
- [ ] Crear repositories abstractos
- [ ] Configurar testing con mocks
- [ ] Implementar cache strategies
- [ ] Documentar arquitectura
- [ ] Configurar CI/CD con estas prácticas 