// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AnteprojectDetailRouteArgs>(
        orElse: () => AnteprojectDetailRouteArgs(
          anteprojectId: pathParams.getString('id'),
        ),
      );
      return AnteprojectDetailPage(
        key: args.key,
        anteprojectId: args.anteprojectId,
      );
    },
  );
}

class AnteprojectDetailRouteArgs {
  const AnteprojectDetailRouteArgs({this.key, required this.anteprojectId});

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
    : super(AnteprojectsListRoute.name, initialChildren: children);

  static const String name = 'AnteprojectsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnteprojectsListPage();
    },
  );
}

/// generated route for
/// [AuditLogsPage]
class AuditLogsRoute extends PageRouteInfo<void> {
  const AuditLogsRoute({List<PageRouteInfo>? children})
    : super(AuditLogsRoute.name, initialChildren: children);

  static const String name = 'AuditLogsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuditLogsPage();
    },
  );
}

/// generated route for
/// [CreateEvaluationPage]
class CreateEvaluationRoute extends PageRouteInfo<void> {
  const CreateEvaluationRoute({List<PageRouteInfo>? children})
    : super(CreateEvaluationRoute.name, initialChildren: children);

  static const String name = 'CreateEvaluationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateEvaluationPage();
    },
  );
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardPage();
    },
  );
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
         args: DefenseDetailRouteArgs(key: key, defenseId: defenseId),
         rawPathParams: {'id': defenseId},
         initialChildren: children,
       );

  static const String name = 'DefenseDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<DefenseDetailRouteArgs>(
        orElse: () =>
            DefenseDetailRouteArgs(defenseId: pathParams.getString('id')),
      );
      return DefenseDetailPage(key: args.key, defenseId: args.defenseId);
    },
  );
}

class DefenseDetailRouteArgs {
  const DefenseDetailRouteArgs({this.key, required this.defenseId});

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
    : super(DefensesListRoute.name, initialChildren: children);

  static const String name = 'DefensesListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DefensesListPage();
    },
  );
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
         args: EvaluationDetailRouteArgs(key: key, evaluationId: evaluationId),
         rawPathParams: {'id': evaluationId},
         initialChildren: children,
       );

  static const String name = 'EvaluationDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EvaluationDetailRouteArgs>(
        orElse: () =>
            EvaluationDetailRouteArgs(evaluationId: pathParams.getString('id')),
      );
      return EvaluationDetailPage(
        key: args.key,
        evaluationId: args.evaluationId,
      );
    },
  );
}

class EvaluationDetailRouteArgs {
  const EvaluationDetailRouteArgs({this.key, required this.evaluationId});

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
    : super(EvaluationsListRoute.name, initialChildren: children);

  static const String name = 'EvaluationsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EvaluationsListPage();
    },
  );
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MainLayoutPage]
class MainLayoutRoute extends PageRouteInfo<void> {
  const MainLayoutRoute({List<PageRouteInfo>? children})
    : super(MainLayoutRoute.name, initialChildren: children);

  static const String name = 'MainLayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainLayoutPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProgressReportRouteArgs>(
        orElse: () => const ProgressReportRouteArgs(),
      );
      return ProgressReportPage(
        key: args.key,
        projectId: args.projectId,
        fromDate: args.fromDate,
        toDate: args.toDate,
      );
    },
  );
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
    : super(ProjectsListRoute.name, initialChildren: children);

  static const String name = 'ProjectsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProjectsListPage();
    },
  );
}

/// generated route for
/// [ProjectsPage]
class ProjectsRoute extends PageRouteInfo<void> {
  const ProjectsRoute({List<PageRouteInfo>? children})
    : super(ProjectsRoute.name, initialChildren: children);

  static const String name = 'ProjectsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProjectsPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ScheduleDefenseRouteArgs>(
        orElse: () => const ScheduleDefenseRouteArgs(),
      );
      return ScheduleDefensePage(
        key: args.key,
        anteprojectId: args.anteprojectId,
        studentId: args.studentId,
        tutorId: args.tutorId,
      );
    },
  );
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
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TaskReportsPage]
class TaskReportsRoute extends PageRouteInfo<void> {
  const TaskReportsRoute({List<PageRouteInfo>? children})
    : super(TaskReportsRoute.name, initialChildren: children);

  static const String name = 'TaskReportsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TaskReportsPage();
    },
  );
}

/// generated route for
/// [TasksPage]
class TasksRoute extends PageRouteInfo<void> {
  const TasksRoute({List<PageRouteInfo>? children})
    : super(TasksRoute.name, initialChildren: children);

  static const String name = 'TasksRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TasksPage();
    },
  );
}

/// generated route for
/// [UserProfilePage]
class UserProfileRoute extends PageRouteInfo<void> {
  const UserProfileRoute({List<PageRouteInfo>? children})
    : super(UserProfileRoute.name, initialChildren: children);

  static const String name = 'UserProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserProfilePage();
    },
  );
}

/// generated route for
/// [UsersPage]
class UsersRoute extends PageRouteInfo<void> {
  const UsersRoute({List<PageRouteInfo>? children})
    : super(UsersRoute.name, initialChildren: children);

  static const String name = 'UsersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UsersPage();
    },
  );
}
