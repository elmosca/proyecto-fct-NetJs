import 'package:fct_frontend/core/services/http_service.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:fct_frontend/shared/models/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required HttpService httpService,
    required StorageService storageService,
  })  : _httpService = httpService,
        _storageService = storageService;
  final HttpService _httpService;
  final StorageService _storageService;

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _httpService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final userData = data['user'] as Map<String, dynamic>;

      // Save token and user data
      await _storageService.saveToken(token);
      await _storageService.saveUser(userData);

      return User.fromJson(userData);
    } catch (e) {
      throw Exception('Error en el login: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _httpService.post('/auth/logout');
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await _storageService.clearToken();
      await _storageService.clearUser();
    }
  }

  @override
  Future<User> register(
      String email, String password, String firstName, String lastName) async {
    try {
      final response = await _httpService.post('/auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final userData = data['user'] as Map<String, dynamic>;

      // Save token and user data
      await _storageService.saveToken(token);
      await _storageService.saveUser(userData);

      return User.fromJson(userData);
    } catch (e) {
      throw Exception('Error en el registro: $e');
    }
  }
}
