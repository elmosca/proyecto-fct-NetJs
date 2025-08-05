import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/features/users/domain/repositories/user_repository.dart';

class CreateUserUseCase {
  const CreateUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<UserEntity> call({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? password,
    String? avatar,
  }) {
    return _userRepository.createUser(
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      password: password,
      avatar: avatar,
    );
  }
}
