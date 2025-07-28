import 'package:fct_frontend/features/auth/domain/entities/entities.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<void> logout();
  Future<AuthResult> register(
      String email, String password, String firstName, String lastName);
  Future<void> requestPasswordReset(String email);
  // Future<AuthResult> loginWithGoogle(); // Postponed para v2.0
}
