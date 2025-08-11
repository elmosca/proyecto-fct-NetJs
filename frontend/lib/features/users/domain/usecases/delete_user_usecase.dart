import 'package:fct_frontend/features/users/domain/repositories/user_repository.dart';

class DeleteUserUseCase {
  const DeleteUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<void> call(String id) {
    return _userRepository.deleteUser(id);
  }
}
