import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:fct_frontend/shared/models/user.dart';

class RegisterUseCase {
  RegisterUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<User> call(String email, String password, String firstName,
          String lastName) async =>
      await _authRepository.register(email, password, firstName, lastName);
}
