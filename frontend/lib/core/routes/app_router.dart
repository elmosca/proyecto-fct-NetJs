import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/routes/auth_guard.dart';
import 'package:fct_frontend/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:fct_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:fct_frontend/features/auth/presentation/pages/register_page.dart';
import 'package:fct_frontend/features/auth/presentation/pages/splash_page.dart';
import 'package:fct_frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fct_frontend/features/dashboard/presentation/pages/main_layout_page.dart';
import 'package:fct_frontend/features/profile/presentation/pages/profile_page.dart';
import 'package:fct_frontend/features/projects/presentation/pages/projects_page.dart';
import 'package:fct_frontend/features/settings/presentation/pages/settings_page.dart';
import 'package:fct_frontend/features/tasks/presentation/pages/milestones_page.dart';
import 'package:fct_frontend/features/tasks/presentation/pages/progress_report_page.dart';
import 'package:fct_frontend/features/tasks/presentation/pages/task_exports_page.dart';
import 'package:fct_frontend/features/tasks/presentation/pages/task_reports_page.dart';
import 'package:fct_frontend/features/tasks/presentation/pages/tasks_page.dart';
import 'package:fct_frontend/features/users/presentation/pages/users_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // Rutas de autenticación
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

        // Layout principal con navegación (protegido por AuthGuard)
        AutoRoute(
          path: '/app',
          page: MainLayoutRoute.page,
          guards: [AuthGuard()],
          children: [
            AutoRoute(
              path: 'dashboard',
              page: DashboardRoute.page,
            ),
            AutoRoute(
              path: 'projects',
              page: ProjectsRoute.page,
            ),
            AutoRoute(
              path: 'tasks',
              page: TasksRoute.page,
            ),
            AutoRoute(
              path: 'milestones',
              page: MilestonesRoute.page,
            ),
            AutoRoute(
              path: 'task-reports',
              page: TaskReportsRoute.page,
            ),
            AutoRoute(
              path: 'task-exports',
              page: TaskExportsRoute.page,
            ),
            AutoRoute(
              path: 'progress-report',
              page: ProgressReportRoute.page,
            ),
            AutoRoute(
              path: 'users',
              page: UsersRoute.page,
            ),
            AutoRoute(
              path: 'profile',
              page: ProfileRoute.page,
            ),
            AutoRoute(
              path: 'settings',
              page: SettingsRoute.page,
            ),
          ],
        ),

        // Ruta legacy para compatibilidad
        AutoRoute(
          path: '/dashboard',
          page: DashboardRoute.page,
          guards: [AuthGuard()],
        ),
      ];
}

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());
