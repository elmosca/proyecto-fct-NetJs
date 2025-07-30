import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para solicitar restablecimiento de contraseña
class RequestPasswordResetUseCase {
  final AuthRepository _authRepository;

  RequestPasswordResetUseCase(this._authRepository);

  /// Solicita el restablecimiento de contraseña para un email
  Future<void> call(String email) async {
    // TODO: Implementar llamada real al backend
    // Por ahora simulamos el envío de email
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulación: siempre "envía" el email
    // En producción, esto llamaría al endpoint del backend
    // await _authRepository.requestPasswordReset(email);
  }
} 