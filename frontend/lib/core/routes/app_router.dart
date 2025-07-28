import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/routes/auth_guard.dart';
import 'package:fct_frontend/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:fct_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:fct_frontend/features/auth/presentation/pages/register_page.dart';
import 'package:fct_frontend/features/auth/presentation/pages/splash_page.dart';
import 'package:fct_frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
        ),
        AutoRoute(
          path: '/register',
          page: RegisterRoute.page,
        ),
        AutoRoute(
          path: '/forgot-password',
          page: ForgotPasswordRoute.page,
        ),
        AutoRoute(
          path: '/dashboard',
          page: DashboardRoute.page,
          guards: [AuthGuard()],
        ),
      ];
}

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());
