import 'package:fct_frontend/features/auth/domain/entities/entities.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<AuthResult> call(
          String email, String password, String firstName, String lastName) =>
      _authRepository.register(email, password, firstName, lastName);
}
