import 'package:fct_frontend/core/di/injection_container.dart';
import 'package:fct_frontend/core/providers/core_providers.dart';
import 'package:fct_frontend/core/routes/app_router.dart';
import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:fct_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:fct_frontend/features/dashboard/presentation/pages/main_layout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeTokenManager extends TokenManager {
  final bool _hasValidToken;
  _FakeTokenManager(this._hasValidToken, SharedPreferences prefs)
      : super(prefs);

  @override
  bool get hasValidToken => _hasValidToken;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
  });

  Future<AppRouter> pumpWithRouter(
    WidgetTester tester, {
    required bool loggedIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenManager = _FakeTokenManager(loggedIn, prefs);

    // Registrar en GetIt para AuthGuard
    getIt.registerLazySingleton<TokenManager>(() => tokenManager);

    final appRouter = AppRouter();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenManagerProvider.overrideWithValue(tokenManager),
        ],
        child: MaterialApp.router(
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
          routeInformationProvider: PlatformRouteInformationProvider(
            initialRouteInformation: const RouteInformation(location: '/app'),
          ),
        ),
      ),
    );
    // Bombear algunos frames
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    return appRouter;
  }

  testWidgets('AuthGuard redirige a /login cuando no hay token',
      (tester) async {
    await pumpWithRouter(tester, loggedIn: false);

    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('AuthGuard permite acceso a /app cuando hay token válido',
      (tester) async {
    await pumpWithRouter(tester, loggedIn: true);

    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.byType(MainLayoutPage), findsOneWidget);
  });
}
