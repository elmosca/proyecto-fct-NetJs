import 'package:fct_frontend/features/auth/presentation/providers/auth_providers.dart';
import 'package:fct_frontend/features/users/domain/entities/permission_enum.dart';
import 'package:fct_frontend/features/users/domain/entities/role_enum.dart';
import 'package:fct_frontend/features/users/domain/services/authorization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthorizedWidget extends ConsumerWidget {
  const AuthorizedWidget({
    super.key,
    required this.child,
    this.roles,
    this.permissions,
    this.fallback,
    this.requireAllRoles = false,
    this.requireAllPermissions = false,
  });

  final Widget child;
  final List<RoleEnum>? roles;
  final List<PermissionEnum>? permissions;
  final Widget? fallback;
  final bool requireAllRoles;
  final bool requireAllPermissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (authState) {
        final user = authState.maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

        if (user == null) {
          return fallback ?? const SizedBox.shrink();
        }

        final authService = AuthorizationServiceImpl();
        bool isAuthorized = true;

        // Verificar roles
        if (roles != null && roles!.isNotEmpty) {
          if (requireAllRoles) {
            isAuthorized = authService.hasAllRoles(user, roles!);
          } else {
            isAuthorized = authService.hasAnyRole(user, roles!);
          }
        }

        // Verificar permisos
        if (isAuthorized && permissions != null && permissions!.isNotEmpty) {
          if (requireAllPermissions) {
            isAuthorized = authService.hasAllPermissions(user, permissions!);
          } else {
            isAuthorized = authService.hasAnyPermission(user, permissions!);
          }
        }

        if (isAuthorized) {
          return child;
        } else {
          return fallback ?? const SizedBox.shrink();
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => fallback ?? const SizedBox.shrink(),
    );
  }
}

// Widgets de conveniencia para roles específicos
class AdminOnlyWidget extends StatelessWidget {
  const AdminOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return AuthorizedWidget(
      roles: [RoleEnum.admin],
      child: child,
      fallback: fallback,
    );
  }
}

class TutorOrAdminWidget extends StatelessWidget {
  const TutorOrAdminWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return AuthorizedWidget(
      roles: [RoleEnum.tutor, RoleEnum.admin],
      child: child,
      fallback: fallback,
    );
  }
}

class StudentOnlyWidget extends StatelessWidget {
  const StudentOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return AuthorizedWidget(
      roles: [RoleEnum.student],
      child: child,
      fallback: fallback,
    );
  }
}

// Widgets de conveniencia para permisos específicos
class PermissionWidget extends StatelessWidget {
  const PermissionWidget({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  final PermissionEnum permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return AuthorizedWidget(
      permissions: [permission],
      child: child,
      fallback: fallback,
    );
  }
}

class MultiplePermissionsWidget extends StatelessWidget {
  const MultiplePermissionsWidget({
    super.key,
    required this.permissions,
    required this.child,
    this.fallback,
    this.requireAll = false,
  });

  final List<PermissionEnum> permissions;
  final Widget child;
  final Widget? fallback;
  final bool requireAll;

  @override
  Widget build(BuildContext context) {
    return AuthorizedWidget(
      permissions: permissions,
      requireAllPermissions: requireAll,
      child: child,
      fallback: fallback,
    );
  }
}
