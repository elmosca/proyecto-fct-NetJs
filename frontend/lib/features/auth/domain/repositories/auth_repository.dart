import 'package:fct_frontend/shared/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User> register(
      String email, String password, String firstName, String lastName);
}
