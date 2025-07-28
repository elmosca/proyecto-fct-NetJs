import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:fct_frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: LoginRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/dashboard',
          page: DashboardRoute.page,
        ),
      ];
}

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());
