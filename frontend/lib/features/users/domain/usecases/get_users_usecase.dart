import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/features/users/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._userRepository);

  final UserRepository _userRepository;

  Future<List<UserEntity>> call({
    int page = 1,
    int limit = 10,
    String? search,
    String? role,
    bool? isActive,
  }) {
    return _userRepository.getUsers(
      page: page,
      limit: limit,
      search: search,
      role: role,
      isActive: isActive,
    );
  }
}
