import 'package:dio/dio.dart';
import 'package:fct_frontend/core/di/injection_container.dart';
import 'package:fct_frontend/core/services/auth_service.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

// Providers simplificados que usan GetIt
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  return getIt<Dio>();
}

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return getIt<AuthService>();
}

@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) {
  return getIt<StorageService>();
}

@Riverpod(keepAlive: true)
TokenManager tokenManager(TokenManagerRef ref) {
  return getIt<TokenManager>();
}
