import 'package:auto_route/auto_route.dart';

/// Guardia de autenticación para proteger rutas que requieren usuario logueado
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // TODO: Implementar verificación real de autenticación con TokenManager
    // Por ahora, implementación básica que permite navegación
    
    // En una implementación completa, aquí verificaríamos:
    // 1. Token válido en TokenManager
    // 2. Estado de autenticación en AuthNotifier
    // 3. Redirección a login si no está autenticado
    
    // Por ahora permitimos todas las navegaciones
    resolver.next();
  }
} 