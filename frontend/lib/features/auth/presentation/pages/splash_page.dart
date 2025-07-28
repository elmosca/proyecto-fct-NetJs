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
              // Usuario autenticado, navegar al dashboard
              context.router.replaceNamed('/dashboard');
            },
            unauthenticated: () {
              // Usuario no autenticado, navegar al login
              context.router.replaceNamed('/');
            },
            error: (message) {
              // Error, navegar al login
              context.router.replaceNamed('/');
            },
          );
        },
        loading: () {
          // Estado de carga, no hacer nada
        },
        error: (error, stackTrace) {
          // Error, navegar al login
          context.router.replaceNamed('/');
        },
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o icono de la aplicación
            const Icon(
              Icons.school,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sistema FCT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cargando...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
