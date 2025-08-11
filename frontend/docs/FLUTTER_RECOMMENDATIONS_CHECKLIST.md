# ✅ Checklist de Verificación - 5 Recomendaciones Fundamentales Flutter

## 🎯 Propósito

Este documento sirve como checklist de verificación para asegurar que las **5 recomendaciones "Strongly recommend"** del equipo oficial de Flutter estén correctamente implementadas en el proyecto.

## 📋 Checklist de Verificación

### **1. Separación de Concernidos** (STRONGLY RECOMMEND)

#### ✅ Verificaciones Obligatorias
- [ ] **1.1** Los widgets solo contienen lógica de presentación
- [ ] **1.2** La lógica de negocio está en ViewModels/Providers
- [ ] **1.3** No hay llamadas directas a APIs desde widgets
- [ ] **1.4** Los widgets usan Consumer/Provider para acceder al estado
- [ ] **1.5** Las validaciones están en la capa de dominio

#### 🔍 Ejemplos de Verificación
```dart
// ✅ CORRECTO
class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserListViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: ListView.builder(
            itemBuilder: (context, index) => UserCard(
              user: viewModel.users[index],
            ),
          ),
        );
      },
    );
  }
}

// ❌ INCORRECTO
class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: ApiService().getUsers(), // ❌ Lógica de negocio en widget
        builder: (context, snapshot) {
          // ...
        },
      ),
    );
  }
}
```

---

### **2. Inyección de Dependencias** (STRONGLY RECOMMEND)

#### ✅ Verificaciones Obligatorias
- [ ] **2.1** No hay objetos globalmente accesibles
- [ ] **2.2** Todas las dependencias se inyectan a través de constructores
- [ ] **2.3** Se usan abstract classes para todas las dependencias
- [ ] **2.4** getIt está configurado correctamente
- [ ] **2.5** Riverpod se usa para estado global

#### 🔍 Ejemplos de Verificación
```dart
// ✅ CORRECTO
class UserService {
  final UserRepository _repository;
  final Logger _logger;
  
  UserService(this._repository, this._logger);
}

// ❌ INCORRECTO
class UserService {
  static final UserRepository _repository = UserRepository(); // ❌ Global
}
```

---

### **3. Navegación con go_router** (RECOMMEND)

#### ✅ Verificaciones Obligatorias
- [ ] **3.1** go_router está configurado como solución de navegación
- [ ] **3.2** Las rutas están nombradas y tipadas
- [ ] **3.3** Se implementan guards de autenticación
- [ ] **3.4** Deep linking está configurado
- [ ] **3.5** No se usa Navigator.push directamente

#### 🔍 Ejemplos de Verificación
```dart
// ✅ CORRECTO
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/users/:id',
      name: 'user-details',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserDetailsScreen(userId: userId);
      },
    ),
  ],
);

// Uso
ElevatedButton(
  onPressed: () => context.goNamed('user-details', 
    pathParameters: {'id': '123'}),
  child: Text('Ver Usuario'),
)

// ❌ INCORRECTO
ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserDetailsScreen(userId: '123')),
  ),
  child: Text('Ver Usuario'),
)
```

---

### **4. Convenciones de Nombres Estándar** (RECOMMEND)

#### ✅ Verificaciones Obligatorias
- [ ] **4.1** Las clases siguen la nomenclatura según componente arquitectónico
- [ ] **4.2** Se usa `ui/core/` en lugar de `/widgets/`
- [ ] **4.3** No hay nombres que se confundan con el SDK de Flutter
- [ ] **4.4** Los archivos usan snake_case
- [ ] **4.5** Las clases usan PascalCase

#### 🔍 Ejemplos de Verificación
```dart
// ✅ CORRECTO
class HomeViewModel extends ChangeNotifier { }
class UserRepository { }
class ClientApiService { }
class HomeScreen extends StatelessWidget { }
class UserCard extends StatelessWidget { }

// ❌ INCORRECTO
class HomeController { }  // ❌ Se confunde con Flutter
class UserService { }     // ❌ Muy genérico
class ApiClient { }       // ❌ No sigue convención
```

#### 📁 Estructura de Carpetas Correcta
```
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
```

---

### **5. Repositorios Abstractos** (STRONGLY RECOMMEND)

#### ✅ Verificaciones Obligatorias
- [ ] **5.1** Todas las entidades tienen abstract repository classes
- [ ] **5.2** Los repositories son la fuente de verdad para los datos
- [ ] **5.3** Se implementan cache strategies
- [ ] **5.4** Hay fallbacks para operaciones de red
- [ ] **5.5** Los repositories manejan errores apropiadamente

#### 🔍 Ejemplos de Verificación
```dart
// ✅ CORRECTO
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getUsers();
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  final UserApiService _apiService;
  final UserLocalDataSource _localDataSource;
  
  UserRepositoryImpl(this._apiService, this._localDataSource);
  
  @override
  Future<User> getUser(String id) async {
    try {
      // Intentar cache primero
      final cachedUser = await _localDataSource.getUser(id);
      if (cachedUser != null) {
        return cachedUser;
      }
      
      // Obtener de API
      final user = await _apiService.fetchUser(id);
      await _localDataSource.saveUser(user);
      return user;
    } catch (e) {
      // Fallback a cache
      final cachedUser = await _localDataSource.getUser(id);
      if (cachedUser != null) {
        return cachedUser;
      }
      rethrow;
    }
  }
}

// ❌ INCORRECTO
class UserRepository {
  Future<User> getUser(String id) async {
    return await ApiService().fetchUser(id); // ❌ Sin abstracción, sin cache
  }
}
```

---

## 🚀 Comandos de Verificación

### Verificar Estructura del Proyecto
```bash
# Verificar estructura de carpetas
find lib -type d -name "widgets" | grep -v "ui/core"
find lib -type d -name "ui" | grep -v "ui/core"

# Verificar convenciones de nombres
find lib -name "*.dart" -exec grep -l "class.*Controller" {} \;
find lib -name "*.dart" -exec grep -l "class.*Service[^A-Z]" {} \;
```

### Verificar Dependencias
```bash
# Verificar que go_router esté instalado
flutter pub deps | grep go_router

# Verificar que auto_route NO esté instalado
flutter pub deps | grep auto_route
```

### Verificar Código
```bash
# Analizar código
flutter analyze

# Verificar imports
find lib -name "*.dart" -exec grep -l "import.*static" {} \;
```

---

## 📊 Reporte de Verificación

### Estado General
- **Recomendaciones Implementadas**: 5/5 ✅
- **Verificaciones Pasadas**: ___/25
- **Problemas Encontrados**: ___
- **Fecha de Verificación**: ___

### Detalle por Recomendación
1. **Separación de Concernidos**: ___/5 ✅
2. **Inyección de Dependencias**: ___/5 ✅
3. **Navegación con go_router**: ___/5 ✅
4. **Convenciones de Nombres**: ___/5 ✅
5. **Repositorios Abstractos**: ___/5 ✅

### Acciones Requeridas
- [ ] **Acción 1**: Descripción del problema
- [ ] **Acción 2**: Descripción del problema
- [ ] **Acción 3**: Descripción del problema

---

## 🔄 Frecuencia de Verificación

- **Verificación Diaria**: Durante desarrollo activo
- **Verificación Semanal**: Revisión completa del proyecto
- **Verificación Mensual**: Auditoría completa con equipo
- **Verificación Pre-Release**: Antes de cada release

---

**Última actualización**: 2025-01-29  
**Próxima verificación**: 2025-02-01  
**Responsable**: Equipo de desarrollo frontend 