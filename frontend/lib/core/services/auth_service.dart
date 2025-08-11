import 'package:fct_frontend/core/services/http_service.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:fct_frontend/core/utils/logger.dart';
import 'package:fct_frontend/core/utils/debug_logger.dart';
import 'package:fct_frontend/shared/models/user.dart';

class AuthService {
  AuthService({
    required HttpService httpService,
    required StorageService storageService,
    required TokenManager tokenManager,
  })  : _httpService = httpService,
        _storageService = storageService,
        _tokenManager = tokenManager;

  final HttpService _httpService;
  final StorageService _storageService;
  final TokenManager _tokenManager;

  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  /// Inicializar el servicio de autenticación
  Future<void> initialize() async {
    try {
      final token = await _storageService.getToken();
      if (token != null) {
        await _loadCurrentUser();
      }
    } catch (e) {
      Logger.error('Error initializing auth service: $e');
      await logout();
    }
  }

  /// Cargar información del usuario actual
  Future<void> _loadCurrentUser() async {
    try {
      // Por ahora, no cargamos el usuario desde el backend
      // ya que el endpoint /me no está disponible
      // En su lugar, usamos el token almacenado para verificar autenticación
      final token = await _storageService.getToken();
      if (token != null) {
        _isAuthenticated = true;
        Logger.success('👤 User authenticated via token');
      }
    } catch (e) {
      Logger.error('Error loading current user: $e');
      await logout();
    }
  }

  /// Login con email y contraseña
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      Logger.info('🔐 Attempting login for: $email');

      final response = await _httpService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        // Guardar token en ambos servicios para consistencia
        await _storageService.saveToken(token);
        await _tokenManager.saveTokens(token);

        // Crear usuario
        _currentUser = User.fromJson(userData);
        _isAuthenticated = true;

        Logger.success('✅ Login successful for: ${_currentUser?.email}');
        return _currentUser!;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e) {
      Logger.error('❌ Login failed: $e');
      rethrow;
    }
  }

  /// Login con Google OAuth
  Future<User> loginWithGoogle({required String idToken}) async {
    try {
      Logger.info('🔐 Attempting Google login');

      final response = await _httpService.post('/auth/google', data: {
        'idToken': idToken,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token']
            as String; // Cambiado de 'token' a 'access_token'
        final userData = data['user'] as Map<String, dynamic>;

        // Guardar token
        await _storageService.saveToken(token);

        // Crear usuario
        _currentUser = User.fromJson(userData);
        _isAuthenticated = true;

        Logger.success('✅ Google login successful for: ${_currentUser?.email}');
        return _currentUser!;
      } else {
        throw Exception('Google login failed: ${response.statusMessage}');
      }
    } catch (e) {
      Logger.error('❌ Google login failed: $e');
      rethrow;
    }
  }

  /// Registro de nuevo usuario
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? role,
  }) async {
    try {
      Logger.info('📝 Attempting registration for: $email');

      final response = await _httpService.post('/auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        if (role != null) 'role': role,
      });

      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['access_token']
            as String; // Cambiado de 'token' a 'access_token'
        final userData = data['user'] as Map<String, dynamic>;

        // Guardar token
        await _storageService.saveToken(token);

        // Crear usuario
        _currentUser = User.fromJson(userData);
        _isAuthenticated = true;

        Logger.success('✅ Registration successful for: ${_currentUser?.email}');
        return _currentUser!;
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } catch (e) {
      Logger.error('❌ Registration failed: $e');
      rethrow;
    }
  }

  /// Logout del usuario
  Future<void> logout() async {
    try {
      Logger.info('🚪 Logging out user: ${_currentUser?.email}');

      // Llamar al endpoint de logout si hay token
      final token = await _storageService.getToken();
      if (token != null) {
        try {
          await _httpService.post('/auth/logout');
        } catch (e) {
          Logger.warning('Warning: Could not call logout endpoint: $e');
        }
      }

      // Limpiar datos locales
      await _storageService.clearToken();
      _currentUser = null;
      _isAuthenticated = false;

      Logger.success('✅ Logout successful');
    } catch (e) {
      Logger.error('❌ Logout failed: $e');
      // Forzar limpieza local incluso si falla
      await _storageService.clearToken();
      _currentUser = null;
      _isAuthenticated = false;
    }
  }

  /// Recuperar contraseña
  Future<void> forgotPassword({required String email}) async {
    try {
      Logger.info('🔑 Requesting password reset for: $email');

      final response = await _httpService.post('/auth/forgot-password', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        Logger.success('✅ Password reset email sent to: $email');
      } else {
        throw Exception('Password reset failed: ${response.statusMessage}');
      }
    } catch (e) {
      Logger.error('❌ Password reset failed: $e');
      rethrow;
    }
  }

  /// Resetear contraseña con token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      Logger.info('🔑 Resetting password with token');

      final response = await _httpService.post('/auth/reset-password', data: {
        'token': token,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200) {
        Logger.success('✅ Password reset successful');
      } else {
        throw Exception('Password reset failed: ${response.statusMessage}');
      }
    } catch (e) {
      Logger.error('❌ Password reset failed: $e');
      rethrow;
    }
  }

  /// Refrescar token
  Future<void> refreshToken() async {
    try {
      Logger.info('🔄 Refreshing token');

      final response = await _httpService.post('/auth/refresh');
      if (response.statusCode == 200) {
        final token = response.data['token'] as String;
        await _storageService.saveToken(token);
        Logger.success('✅ Token refreshed successfully');
      } else {
        throw Exception('Token refresh failed: ${response.statusMessage}');
      }
    } catch (e) {
      Logger.error('❌ Token refresh failed: $e');
      await logout();
      rethrow;
    }
  }

  /// Verificar si el token es válido
  Future<bool> isTokenValid() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return false;

      final response = await _httpService.get('/auth/verify');
      return response.statusCode == 200;
    } catch (e) {
      Logger.warning('Token validation failed: $e');
      return false;
    }
  }
}
