import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/features/users/domain/repositories/user_repository.dart';

class UpdateUserUseCase {
  const UpdateUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<UserEntity> call({
    required String id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? avatar,
    bool? isActive,
  }) {
    return _userRepository.updateUser(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      avatar: avatar,
      isActive: isActive,
    );
  }
}
