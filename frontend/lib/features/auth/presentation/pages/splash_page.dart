import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar cambios en el estado de autenticación
    ref.listen(authNotifierProvider, (previous, next) {
      next.when(
        data: (state) {
          state.when(
            initial: () {
              // Estado inicial, no hacer nada
            },
            loading: () {
              // Estado de carga, no hacer nada
            },
            authenticated: (user) {
              // Usuario autenticado, navegar al layout principal
              context.router.replaceNamed('/app/dashboard');
            },
            unauthenticated: () {
              // Usuario no autenticado, navegar al login
              context.router.replaceNamed('/login');
            },
            error: (message) {
              // Error, navegar al login
              context.router.replaceNamed('/login');
            },
          );
        },
        loading: () {
          // Estado de carga, no hacer nada
        },
        error: (error, stackTrace) {
          // Error, navegar al login
          context.router.replaceNamed('/login');
        },
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o icono de la aplicación
            Icon(
              Icons.school,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'Sistema FCT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
