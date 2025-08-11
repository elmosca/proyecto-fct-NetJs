import 'package:fct_frontend/core/di/injection_container.dart';
import 'package:fct_frontend/core/providers/locale_provider.dart';
import 'package:fct_frontend/core/routes/app_router.dart';
import 'package:fct_frontend/core/theme/app_theme.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Solución recomendada por Flutter para pantalla gris
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await initializeDependencies();
    
    runApp(
      const ProviderScope(
        child: FCTApp(),
      ),
    );
  } catch (error, stackTrace) {
    // Error handling recomendado por Flutter
    debugPrint('Error during app initialization: $error');
    debugPrint('Stack trace: $stackTrace');
    
    // Mostrar error en lugar de pantalla gris
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error al inicializar la aplicación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: $error',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Recargar la aplicación
                    main();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FCTApp extends ConsumerWidget {
  const FCTApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'FCT - Gestión de Proyectos',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Spanish
        Locale('en'), // English
      ],
    );
  }
}
