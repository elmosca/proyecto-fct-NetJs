import 'package:fct_frontend/core/services/auth_service.dart';
import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:fct_frontend/features/auth/domain/entities/entities.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._authService, this._tokenManager);

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final user = await _authService.login(email: email, password: password);
      final token = await _tokenManager.getToken();
      return AuthResult.success(user, token!);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _authService.logout();
  }

  @override
  Future<AuthResult> register(
      String email, String password, String firstName, String lastName) async {
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      final token = await _tokenManager.getToken();
      return AuthResult.success(user, token!);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _authService.forgotPassword(email: email);
  }
}
