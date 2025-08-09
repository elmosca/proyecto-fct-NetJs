import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/di/injection_container.dart';
import 'package:fct_frontend/core/services/token_manager.dart';

/// Guardia de autenticación para proteger rutas que requieren usuario logueado
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final tokenManager = getIt<TokenManager>();
    final isLoggedIn = tokenManager.hasValidToken;

    if (isLoggedIn) {
      resolver.next();
    } else {
      router.replaceNamed('/login');
    }
  }
}
