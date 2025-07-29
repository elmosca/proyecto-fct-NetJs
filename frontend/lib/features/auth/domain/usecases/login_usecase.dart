import 'package:fct_frontend/features/auth/domain/entities/entities.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<AuthResult> call(String email, String password) async =>
      await _authRepository.login(email, password);
}
