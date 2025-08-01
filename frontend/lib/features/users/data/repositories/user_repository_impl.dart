import 'package:fct_frontend/core/services/http_service.dart';
import 'package:fct_frontend/features/users/data/models/user_model.dart';
import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._httpService);

  final HttpService _httpService;

  @override
  Future<List<UserEntity>> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
    String? role,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }
      if (isActive != null) {
        queryParams['isActive'] = isActive;
      }

      final response = await _httpService.get(
        '/users',
        queryParameters: queryParams,
      );

      final List<dynamic> usersJson = response.data['users'] ?? [];
      return usersJson
          .map((json) =>
              UserModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    try {
      final response = await _httpService.get('/users/$id');
      return UserModel.fromJson(response.data).toEntity();
    } catch (e) {
      if (e.toString().contains('404')) {
        return null;
      }
      throw Exception('Error al obtener usuario: $e');
    }
  }

  @override
  Future<UserEntity> createUser({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? password,
    String? avatar,
  }) async {
    try {
      final data = <String, dynamic>{
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      };

      if (password != null && password.isNotEmpty) {
        data['password'] = password;
      }
      if (avatar != null && avatar.isNotEmpty) {
        data['avatar'] = avatar;
      }

      final response = await _httpService.post('/users', data: data);
      return UserModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  @override
  Future<UserEntity> updateUser({
    required String id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? avatar,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (email != null) data['email'] = email;
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (role != null) data['role'] = role;
      if (avatar != null) data['avatar'] = avatar;
      if (isActive != null) data['isActive'] = isActive;

      final response = await _httpService.patch('/users/$id', data: data);
      return UserModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _httpService.delete('/users/$id');
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  @override
  Future<UserEntity> toggleUserStatus(String id) async {
    try {
      final response = await _httpService.patch('/users/$id/toggle-status');
      return UserModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw Exception('Error al cambiar estado del usuario: $e');
    }
  }

  @override
  Future<void> changeUserPassword({
    required String id,
    required String newPassword,
  }) async {
    try {
      await _httpService.patch(
        '/users/$id/password',
        data: {'password': newPassword},
      );
    } catch (e) {
      throw Exception('Error al cambiar contraseña: $e');
    }
  }
}
