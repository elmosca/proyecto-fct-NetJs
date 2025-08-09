import 'package:fct_frontend/core/di/injection_container.dart';
import 'package:fct_frontend/core/providers/locale_provider.dart';
import 'package:fct_frontend/core/routes/app_router.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/core/theme/app_theme.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await StorageService.initialize();

  runApp(
    const ProviderScope(
      child: FCTApp(),
    ),
  );
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
