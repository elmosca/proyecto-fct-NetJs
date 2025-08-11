import 'package:fct_frontend/core/providers/core_providers.dart';
import 'package:fct_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:fct_frontend/features/auth/domain/usecases/usecases.dart';
import 'package:fct_frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final authService = ref.watch(authServiceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return AuthRepositoryImpl(authService, tokenManager);
}

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RegisterUseCase registerUseCase(RegisterUseCaseRef ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RequestPasswordResetUseCase requestPasswordResetUseCase(
    RequestPasswordResetUseCaseRef ref) {
  return RequestPasswordResetUseCase(ref.watch(authRepositoryProvider));
}

// Google OAuth postponed para v2.0
// @riverpod
// LoginWithGoogleUseCase loginWithGoogleUseCase(LoginWithGoogleUseCaseRef ref) {
//   return LoginWithGoogleUseCase(ref.watch(authRepositoryProvider));
// }

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() {
    return _checkAuthStatus();
  }

  /// Verifica el estado de autenticación al iniciar la app
  Future<AuthState> _checkAuthStatus() async {
    try {
      // Por ahora, siempre retornamos no autenticado al inicio
      // para evitar problemas con la inicialización de dependencias
      return const AuthState.unauthenticated();
    } catch (e) {
      return const AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final result = await loginUseCase(email, password);

      result.when(
        success: (user, token) {
          state = AsyncValue.data(AuthState.authenticated(user));
        },
        failure: (message) {
          state = AsyncValue.error(message, StackTrace.current);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> register(
      String email, String password, String firstName, String lastName) async {
    state = const AsyncValue.loading();
    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(email, password, firstName, lastName);
    result.when(
      success: (user, token) {
        state = AsyncValue.data(AuthState.authenticated(user));
      },
      failure: (message) {
        state = AsyncValue.error(message, StackTrace.current);
      },
    );
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    try {
      // Limpiar tokens almacenados
      final tokenManager = ref.read(tokenManagerProvider);
      await tokenManager.clearAll();

      // Actualizar estado
      state = const AsyncValue.data(AuthState.unauthenticated());
    } catch (e) {
      // Si hay error, forzar estado no autenticado
      state = const AsyncValue.data(AuthState.unauthenticated());
    }
  }

  // Google OAuth será implementado en v2.0
  // Future<void> loginWithGoogle() async { ... }
}
