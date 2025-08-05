// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AnteprojectDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AnteprojectDetailRouteArgs>(
          orElse: () => AnteprojectDetailRouteArgs(
              anteprojectId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AnteprojectDetailPage(
          key: args.key,
          anteprojectId: args.anteprojectId,
        ),
      );
    },
    AnteprojectsListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AnteprojectsListPage(),
      );
    },
    AuditLogsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuditLogsPage(),
      );
    },
    CreateEvaluationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateEvaluationPage(),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    DefenseDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DefenseDetailRouteArgs>(
          orElse: () =>
              DefenseDetailRouteArgs(defenseId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DefenseDetailPage(
          key: args.key,
          defenseId: args.defenseId,
        ),
      );
    },
    DefensesListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DefensesListPage(),
      );
    },
    EvaluationDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EvaluationDetailRouteArgs>(
          orElse: () => EvaluationDetailRouteArgs(
              evaluationId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EvaluationDetailPage(
          key: args.key,
          evaluationId: args.evaluationId,
        ),
      );
    },
    EvaluationsListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EvaluationsListPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainLayoutRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainLayoutPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    ProgressReportRoute.name: (routeData) {
      final args = routeData.argsAs<ProgressReportRouteArgs>(
          orElse: () => const ProgressReportRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProgressReportPage(
          key: args.key,
          projectId: args.projectId,
          fromDate: args.fromDate,
          toDate: args.toDate,
        ),
      );
    },
    ProjectsListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectsListPage(),
      );
    },
    ProjectsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectsPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    ScheduleDefenseRoute.name: (routeData) {
      final args = routeData.argsAs<ScheduleDefenseRouteArgs>(
          orElse: () => const ScheduleDefenseRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ScheduleDefensePage(
          key: args.key,
          anteprojectId: args.anteprojectId,
          studentId: args.studentId,
          tutorId: args.tutorId,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    TaskReportsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TaskReportsPage(),
      );
    },
    TasksRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TasksPage(),
      );
    },
    UserProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserProfilePage(),
      );
    },
    UsersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UsersPage(),
      );
    },
  };
}

/// generated route for
/// [AnteprojectDetailPage]
class AnteprojectDetailRoute extends PageRouteInfo<AnteprojectDetailRouteArgs> {
  AnteprojectDetailRoute({
    Key? key,
    required String anteprojectId,
    List<PageRouteInfo>? children,
  }) : super(
          AnteprojectDetailRoute.name,
          args: AnteprojectDetailRouteArgs(
            key: key,
            anteprojectId: anteprojectId,
          ),
          rawPathParams: {'id': anteprojectId},
          initialChildren: children,
        );

  static const String name = 'AnteprojectDetailRoute';

  static const PageInfo<AnteprojectDetailRouteArgs> page =
      PageInfo<AnteprojectDetailRouteArgs>(name);
}

class AnteprojectDetailRouteArgs {
  const AnteprojectDetailRouteArgs({
    this.key,
    required this.anteprojectId,
  });

  final Key? key;

  final String anteprojectId;

  @override
  String toString() {
    return 'AnteprojectDetailRouteArgs{key: $key, anteprojectId: $anteprojectId}';
  }
}

/// generated route for
/// [AnteprojectsListPage]
class AnteprojectsListRoute extends PageRouteInfo<void> {
  const AnteprojectsListRoute({List<PageRouteInfo>? children})
      : super(
          AnteprojectsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'AnteprojectsListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuditLogsPage]
class AuditLogsRoute extends PageRouteInfo<void> {
  const AuditLogsRoute({List<PageRouteInfo>? children})
      : super(
          AuditLogsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuditLogsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreateEvaluationPage]
class CreateEvaluationRoute extends PageRouteInfo<void> {
  const CreateEvaluationRoute({List<PageRouteInfo>? children})
      : super(
          CreateEvaluationRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateEvaluationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DefenseDetailPage]
class DefenseDetailRoute extends PageRouteInfo<DefenseDetailRouteArgs> {
  DefenseDetailRoute({
    Key? key,
    required String defenseId,
    List<PageRouteInfo>? children,
  }) : super(
          DefenseDetailRoute.name,
          args: DefenseDetailRouteArgs(
            key: key,
            defenseId: defenseId,
          ),
          rawPathParams: {'id': defenseId},
          initialChildren: children,
        );

  static const String name = 'DefenseDetailRoute';

  static const PageInfo<DefenseDetailRouteArgs> page =
      PageInfo<DefenseDetailRouteArgs>(name);
}

class DefenseDetailRouteArgs {
  const DefenseDetailRouteArgs({
    this.key,
    required this.defenseId,
  });

  final Key? key;

  final String defenseId;

  @override
  String toString() {
    return 'DefenseDetailRouteArgs{key: $key, defenseId: $defenseId}';
  }
}

/// generated route for
/// [DefensesListPage]
class DefensesListRoute extends PageRouteInfo<void> {
  const DefensesListRoute({List<PageRouteInfo>? children})
      : super(
          DefensesListRoute.name,
          initialChildren: children,
        );

  static const String name = 'DefensesListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EvaluationDetailPage]
class EvaluationDetailRoute extends PageRouteInfo<EvaluationDetailRouteArgs> {
  EvaluationDetailRoute({
    Key? key,
    required String evaluationId,
    List<PageRouteInfo>? children,
  }) : super(
          EvaluationDetailRoute.name,
          args: EvaluationDetailRouteArgs(
            key: key,
            evaluationId: evaluationId,
          ),
          rawPathParams: {'id': evaluationId},
          initialChildren: children,
        );

  static const String name = 'EvaluationDetailRoute';

  static const PageInfo<EvaluationDetailRouteArgs> page =
      PageInfo<EvaluationDetailRouteArgs>(name);
}

class EvaluationDetailRouteArgs {
  const EvaluationDetailRouteArgs({
    this.key,
    required this.evaluationId,
  });

  final Key? key;

  final String evaluationId;

  @override
  String toString() {
    return 'EvaluationDetailRouteArgs{key: $key, evaluationId: $evaluationId}';
  }
}

/// generated route for
/// [EvaluationsListPage]
class EvaluationsListRoute extends PageRouteInfo<void> {
  const EvaluationsListRoute({List<PageRouteInfo>? children})
      : super(
          EvaluationsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'EvaluationsListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainLayoutPage]
class MainLayoutRoute extends PageRouteInfo<void> {
  const MainLayoutRoute({List<PageRouteInfo>? children})
      : super(
          MainLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainLayoutRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProgressReportPage]
class ProgressReportRoute extends PageRouteInfo<ProgressReportRouteArgs> {
  ProgressReportRoute({
    Key? key,
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
    List<PageRouteInfo>? children,
  }) : super(
          ProgressReportRoute.name,
          args: ProgressReportRouteArgs(
            key: key,
            projectId: projectId,
            fromDate: fromDate,
            toDate: toDate,
          ),
          initialChildren: children,
        );

  static const String name = 'ProgressReportRoute';

  static const PageInfo<ProgressReportRouteArgs> page =
      PageInfo<ProgressReportRouteArgs>(name);
}

class ProgressReportRouteArgs {
  const ProgressReportRouteArgs({
    this.key,
    this.projectId,
    this.fromDate,
    this.toDate,
  });

  final Key? key;

  final String? projectId;

  final DateTime? fromDate;

  final DateTime? toDate;

  @override
  String toString() {
    return 'ProgressReportRouteArgs{key: $key, projectId: $projectId, fromDate: $fromDate, toDate: $toDate}';
  }
}

/// generated route for
/// [ProjectsListPage]
class ProjectsListRoute extends PageRouteInfo<void> {
  const ProjectsListRoute({List<PageRouteInfo>? children})
      : super(
          ProjectsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectsPage]
class ProjectsRoute extends PageRouteInfo<void> {
  const ProjectsRoute({List<PageRouteInfo>? children})
      : super(
          ProjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ScheduleDefensePage]
class ScheduleDefenseRoute extends PageRouteInfo<ScheduleDefenseRouteArgs> {
  ScheduleDefenseRoute({
    Key? key,
    String? anteprojectId,
    String? studentId,
    String? tutorId,
    List<PageRouteInfo>? children,
  }) : super(
          ScheduleDefenseRoute.name,
          args: ScheduleDefenseRouteArgs(
            key: key,
            anteprojectId: anteprojectId,
            studentId: studentId,
            tutorId: tutorId,
          ),
          initialChildren: children,
        );

  static const String name = 'ScheduleDefenseRoute';

  static const PageInfo<ScheduleDefenseRouteArgs> page =
      PageInfo<ScheduleDefenseRouteArgs>(name);
}

class ScheduleDefenseRouteArgs {
  const ScheduleDefenseRouteArgs({
    this.key,
    this.anteprojectId,
    this.studentId,
    this.tutorId,
  });

  final Key? key;

  final String? anteprojectId;

  final String? studentId;

  final String? tutorId;

  @override
  String toString() {
    return 'ScheduleDefenseRouteArgs{key: $key, anteprojectId: $anteprojectId, studentId: $studentId, tutorId: $tutorId}';
  }
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TaskReportsPage]
class TaskReportsRoute extends PageRouteInfo<void> {
  const TaskReportsRoute({List<PageRouteInfo>? children})
      : super(
          TaskReportsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskReportsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TasksPage]
class TasksRoute extends PageRouteInfo<void> {
  const TasksRoute({List<PageRouteInfo>? children})
      : super(
          TasksRoute.name,
          initialChildren: children,
        );

  static const String name = 'TasksRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserProfilePage]
class UserProfileRoute extends PageRouteInfo<void> {
  const UserProfileRoute({List<PageRouteInfo>? children})
      : super(
          UserProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UsersPage]
class UsersRoute extends PageRouteInfo<void> {
  const UsersRoute({List<PageRouteInfo>? children})
      : super(
          UsersRoute.name,
          initialChildren: children,
        );

  static const String name = 'UsersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
