import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para solicitar restablecimiento de contraseña
class RequestPasswordResetUseCase {
  final AuthRepository _authRepository;

  RequestPasswordResetUseCase(this._authRepository);

  /// Solicita el restablecimiento de contraseña para un email
  Future<void> call(String email) async {
    await _authRepository.requestPasswordReset(email);
  }
}
