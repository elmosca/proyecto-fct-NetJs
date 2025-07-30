import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fct_frontend/shared/models/user.dart';

part 'auth_result.freezed.dart';

@freezed
abstract class AuthResult with _$AuthResult {
  const factory AuthResult.success(User user, String token) = _Success;
  const factory AuthResult.failure(String message) = _Failure;
} 