import 'package:fct_frontend/features/auth/domain/entities/entities.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  LoginWithGoogleUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<AuthResult> call() => _authRepository.loginWithGoogle();
}
