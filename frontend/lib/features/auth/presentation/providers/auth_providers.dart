import 'package:fct_frontend/core/providers/core_providers.dart';
import 'package:fct_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:fct_frontend/features/auth/domain/usecases/usecases.dart';
import 'package:fct_frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:fct_frontend/shared/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return AuthRepositoryImpl(tokenManager);
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
      final tokenManager = ref.read(tokenManagerProvider);

      // Verificar si hay un token válido almacenado
      if (tokenManager.hasValidToken) {
        // TODO: Validar token con el backend
        // Por ahora asumimos que el token es válido
        // En producción, aquí haríamos una llamada al backend para verificar

        // Simular usuario autenticado
        final user = User(
          id: tokenManager.userId ?? 'unknown',
          email: 'user@example.com', // TODO: Obtener del token o backend
          firstName: 'Usuario',
          lastName: 'Autenticado',
          role: 'student',
        );

        return AuthState.authenticated(user);
      } else {
        return const AuthState.unauthenticated();
      }
    } catch (e) {
      // Si hay error, limpiar tokens y marcar como no autenticado
      final tokenManager = ref.read(tokenManagerProvider);
      await tokenManager.clearAll();
      return const AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
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
