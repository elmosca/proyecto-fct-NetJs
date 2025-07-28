import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:fct_frontend/features/auth/domain/entities/entities.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:fct_frontend/shared/models/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._tokenManager);

  @override
  Future<AuthResult> login(String email, String password) async {
    // Simulación de llamada a la API
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == 'password') {
      final user = User(
        id: '1',
        email: email,
        firstName: 'Test',
        lastName: 'User',
        role: 'student',
      );
      const token = 'fake-jwt-token';

      // Guardar token y user ID
      await _tokenManager.saveTokens(token);
      await _tokenManager.saveUserId(user.id);

      return AuthResult.success(user, token);
    } else {
      return const AuthResult.failure('Credenciales incorrectas');
    }
  }

  @override
  Future<void> logout() async {
    // Limpiar todos los tokens almacenados
    await _tokenManager.clearAll();
    // TODO: Llamar al endpoint de logout del backend si es necesario
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<AuthResult> register(
      String email, String password, String firstName, String lastName) async {
    // TODO: Implementar registro con llamada a la API
    await Future.delayed(const Duration(seconds: 1));
    if (email.contains('@')) {
      final user = User(
        id: '2',
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: 'student',
      );
      const token = 'fake-jwt-token-for-register';

      // Guardar token y user ID tras registro exitoso
      await _tokenManager.saveTokens(token);
      await _tokenManager.saveUserId(user.id);

      return AuthResult.success(user, token);
    } else {
      return const AuthResult.failure('Email no válido.');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    // TODO: Implementar llamada real al backend
    // Por ahora simulamos el envío de email
    await Future.delayed(const Duration(seconds: 2));

    // Simulación: siempre "envía" el email
    // En producción, esto llamaría al endpoint del backend
    // await _httpService.post('/auth/request-password-reset', {'email': email});
  }

  // Google OAuth será implementado en v2.0
  // @override
  // Future<AuthResult> loginWithGoogle() async { ... }
}
