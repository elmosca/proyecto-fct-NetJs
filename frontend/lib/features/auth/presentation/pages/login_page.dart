import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/widgets.dart';
import 'package:fct_frontend/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        data: (state) {
          state.whenOrNull(
            authenticated: (user) {
              // Navegar al layout principal después del login exitoso
              context.router.replaceNamed('/app/dashboard');
            },
          );
        },
      );
    });

    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce tu email';
                    }
                    if (!value.contains('@')) {
                      return 'Introduce un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Contraseña',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce tu contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Iniciar Sesión',
                  isLoading: authState.isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(authNotifierProvider.notifier).login(
                            _emailController.text,
                            _passwordController.text,
                          );
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Google OAuth será añadido en v2.0
                // AppButton(
                //   text: 'Iniciar Sesión con Google',
                //   onPressed: () => // TODO: Google OAuth
                // ),
                // const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.router.pushNamed('/register');
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.router.pushNamed('/forgot-password');
                  },
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
                const SizedBox(height: 16),
                // Para testing: botón de navegación al dashboard
                TextButton(
                  onPressed: () {
                    context.router.pushNamed('/dashboard');
                  },
                  child:
                      const Text('🧪 Test Dashboard (debe activar AuthGuard)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
