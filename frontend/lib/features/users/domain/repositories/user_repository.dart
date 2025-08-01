import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';

abstract class UserRepository {
  /// Obtiene la lista de usuarios con paginación y filtros
  Future<List<UserEntity>> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
    String? role,
    bool? isActive,
  });

  /// Obtiene un usuario por su ID
  Future<UserEntity?> getUserById(String id);

  /// Crea un nuevo usuario
  Future<UserEntity> createUser({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? password,
    String? avatar,
  });

  /// Actualiza un usuario existente
  Future<UserEntity> updateUser({
    required String id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? avatar,
    bool? isActive,
  });

  /// Elimina un usuario
  Future<void> deleteUser(String id);

  /// Activa/desactiva un usuario
  Future<UserEntity> toggleUserStatus(String id);

  /// Cambia la contraseña de un usuario
  Future<void> changeUserPassword({
    required String id,
    required String newPassword,
  });
}
