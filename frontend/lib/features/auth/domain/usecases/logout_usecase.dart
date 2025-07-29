import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<void> call() async {
    await _authRepository.logout();
  }
}
