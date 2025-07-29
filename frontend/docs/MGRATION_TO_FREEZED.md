# 🔄 Migración a Freezed - Plan de Implementación

## �� Estado Actual

### **Modelos Implementados sin Freezed**
- ✅ `User` - Implementado como clase manual
- 🔄 Otros modelos - Por implementar

### **Ventajas de la Implementación Actual**
- ✅ Funciona sin conflictos de dependencias
- ✅ Código limpio y funcional
- ✅ Fácil de mantener temporalmente

## 🎯 Plan de Migración

### **Fase 1: Preparación (Fase 2 del proyecto)**

#### **1.1 Resolver Conflictos de Dependencias**
```bash
# Actualizar dependencias de freezed
flutter pub add freezed_annotation:^3.1.0
flutter pub add json_annotation:^4.8.1
flutter pub add --dev freezed:^3.2.0
flutter pub add --dev json_serializable:^6.10.0
flutter pub add --dev build_runner:^2.6.0
```

#### **1.2 Verificar Compatibilidad**
```bash
# Verificar que no hay conflictos
flutter pub deps
flutter analyze
dart run build_runner build --delete-conflicting-outputs
```

### **Fase 2: Migración de Modelos**

#### **2.1 Migrar User Model**

**Antes (implementación actual):**
```dart
class User {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    role: json['role'] as String,
    avatar: json['avatar'] as String?,
    createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'] as String) 
        : null,
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
  );

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'role': role,
    'avatar': avatar,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
```

**Después (con freezed):**
```dart
import 'package:freezed_annotation/freezed.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

#### **2.2 Beneficios de la Migración**

**Ventajas de Freezed:**
- ✅ **Inmutabilidad garantizada**
- ✅ **copyWith automático**
- ✅ **toString, ==, hashCode automáticos**
- ✅ **Serialización JSON automática**
- ✅ **Union types (sealed classes)**
- ✅ **Pattern matching**

**Ejemplo de uso con freezed:**
```dart
// Crear usuario
final user = User(
  id: '1',
  email: 'user@example.com',
  firstName: 'John',
  lastName: 'Doe',
  role: 'student',
);

// copyWith (solo con freezed)
final updatedUser = user.copyWith(
  firstName: 'Jane',
  avatar: 'https://example.com/avatar.jpg',
);

// toString automático
print(user); // User(id: 1, email: user@example.com, ...)

// Comparación automática
final user2 = User(...);
print(user == user2); // true/false automático
```

### **Fase 3: Implementación Gradual**

#### **3.1 Orden de Migración**
1. **User** (ya preparado)
2. **Project** (cuando se implemente)
3. **Task** (cuando se implemente)
4. **Comment** (cuando se implemente)
5. **Notification** (cuando se implemente)

#### **3.2 Estrategia de Migración**
```bash
# Para cada modelo:
# 1. Crear rama de feature
git checkout -b feature/migrate-user-to-freezed

# 2. Migrar el modelo
# - Reemplazar implementación manual con freezed
# - Actualizar imports en otros archivos
# - Ejecutar build runner

# 3. Actualizar tests
# - Adaptar tests para nueva implementación
# - Añadir tests para copyWith, toString, etc.

# 4. Verificar que todo funciona
flutter test
flutter analyze
flutter run

# 5. Commit y merge
git commit -m "feat: migrate User model to freezed"
git push origin feature/migrate-user-to-freezed
```

### **Fase 4: Configuración Avanzada**

#### **4.1 Union Types (Sealed Classes)**
```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}

// Uso con pattern matching
authState.when(
  initial: () => showLoginScreen(),
  loading: () => showLoadingIndicator(),
  authenticated: (user) => showDashboard(user),
  error: (message) => showErrorDialog(message),
);
```

#### **4.2 Custom JSON Serialization**
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? avatar,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## 🚨 Troubleshooting

### **Problemas Comunes**

#### **1. Error de Anotación @freezed**
```bash
# Solución: Actualizar dependencias
flutter pub upgrade
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### **2. Conflictos de Versiones**
```yaml
# pubspec.yaml - Versiones compatibles
dependencies:
  freezed_annotation: ^3.1.0
  json_annotation: ^4.8.1

dev_dependencies:
  freezed: ^3.2.0
  json_serializable: ^6.10.0
  build_runner: ^2.6.0
```

#### **3. Errores de Build Runner**
```bash
# Limpiar y regenerar
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## 📅 Cronograma de Migración

### **Fase 2 (Próxima)**
- [ ] Resolver conflictos de dependencias
- [ ] Migrar User model
- [ ] Actualizar tests

### **Fase 3-6 (Durante desarrollo)**
- [ ] Migrar Project model
- [ ] Migrar Task model
- [ ] Migrar Comment model
- [ ] Migrar Notification model

### **Fase 7+ (Optimización)**
- [ ] Implementar union types
- [ ] Optimizar serialización
- [ ] Añadir validaciones avanzadas

## ✅ Checklist de Migración

### **Antes de Migrar**
- [ ] Verificar que no hay errores críticos
- [ ] Tener tests pasando
- [ ] Hacer backup del código actual
- [ ] Crear rama de feature

### **Durante la Migración**
- [ ] Migrar un modelo a la vez
- [ ] Ejecutar build runner después de cada cambio
- [ ] Actualizar imports en otros archivos
- [ ] Verificar que la funcionalidad no se rompe

### **Después de la Migración**
- [ ] Ejecutar todos los tests
- [ ] Verificar análisis de código
- [ ] Probar la aplicación
- [ ] Documentar cambios

---

**Última actualización**: 2025-07-28
**Próxima revisión**: Cuando se inicie Fase 2
**Responsable**: Equipo de desarrollo frontend