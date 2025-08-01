import 'package:fct_frontend/features/users/domain/entities/permission_enum.dart';
import 'package:fct_frontend/features/users/domain/entities/role_enum.dart';
import 'package:fct_frontend/shared/models/user.dart';

abstract class AuthorizationService {
  /// Verifica si el usuario tiene un rol específico
  bool hasRole(User user, RoleEnum role);

  /// Verifica si el usuario tiene al menos uno de los roles especificados
  bool hasAnyRole(User user, List<RoleEnum> roles);

  /// Verifica si el usuario tiene todos los roles especificados
  bool hasAllRoles(User user, List<RoleEnum> roles);

  /// Verifica si el usuario tiene un permiso específico
  bool hasPermission(User user, PermissionEnum permission);

  /// Verifica si el usuario tiene al menos uno de los permisos especificados
  bool hasAnyPermission(User user, List<PermissionEnum> permissions);

  /// Verifica si el usuario tiene todos los permisos especificados
  bool hasAllPermissions(User user, List<PermissionEnum> permissions);

  /// Obtiene todos los permisos disponibles para un rol
  List<PermissionEnum> getPermissionsForRole(RoleEnum role);

  /// Obtiene todos los roles que pueden realizar una acción específica
  List<RoleEnum> getRolesForPermission(PermissionEnum permission);

  /// Verifica si el usuario puede gestionar a otro usuario
  bool canManageUser(User currentUser, User targetUser);
}

class AuthorizationServiceImpl implements AuthorizationService {
  @override
  bool hasRole(User user, RoleEnum role) {
    final userRole = RoleEnum.fromString(user.role);
    return userRole == role;
  }

  @override
  bool hasAnyRole(User user, List<RoleEnum> roles) {
    final userRole = RoleEnum.fromString(user.role);
    return roles.contains(userRole);
  }

  @override
  bool hasAllRoles(User user, List<RoleEnum> roles) {
    final userRole = RoleEnum.fromString(user.role);
    return roles.every((role) => userRole == role);
  }

  @override
  bool hasPermission(User user, PermissionEnum permission) {
    final userRole = RoleEnum.fromString(user.role);
    final rolePermissions = getPermissionsForRole(userRole);
    return rolePermissions.contains(permission);
  }

  @override
  bool hasAnyPermission(User user, List<PermissionEnum> permissions) {
    final userRole = RoleEnum.fromString(user.role);
    final rolePermissions = getPermissionsForRole(userRole);
    return permissions
        .any((permission) => rolePermissions.contains(permission));
  }

  @override
  bool hasAllPermissions(User user, List<PermissionEnum> permissions) {
    final userRole = RoleEnum.fromString(user.role);
    final rolePermissions = getPermissionsForRole(userRole);
    return permissions
        .every((permission) => rolePermissions.contains(permission));
  }

  @override
  List<PermissionEnum> getPermissionsForRole(RoleEnum role) {
    switch (role) {
      case RoleEnum.admin:
        return PermissionEnum.allPermissions;

      case RoleEnum.tutor:
        return [
          // Usuarios
          PermissionEnum.usersView,
          PermissionEnum.usersEdit,

          // Proyectos
          PermissionEnum.projectsView,
          PermissionEnum.projectsCreate,
          PermissionEnum.projectsEdit,
          PermissionEnum.projectsAssign,

          // Anteproyectos
          PermissionEnum.anteprojectsView,
          PermissionEnum.anteprojectsCreate,
          PermissionEnum.anteprojectsEdit,
          PermissionEnum.anteprojectsEvaluate,

          // Tareas
          PermissionEnum.tasksView,
          PermissionEnum.tasksCreate,
          PermissionEnum.tasksEdit,
          PermissionEnum.tasksAssign,

          // Evaluaciones
          PermissionEnum.evaluationsView,
          PermissionEnum.evaluationsCreate,
          PermissionEnum.evaluationsEdit,

          // Reportes
          PermissionEnum.reportsView,
          PermissionEnum.reportsGenerate,

          // Configuración
          PermissionEnum.settingsView,
        ];

      case RoleEnum.student:
        return [
          // Proyectos (solo los propios)
          PermissionEnum.projectsView,

          // Anteproyectos (solo los propios)
          PermissionEnum.anteprojectsView,
          PermissionEnum.anteprojectsCreate,
          PermissionEnum.anteprojectsEdit,

          // Tareas (solo las propias)
          PermissionEnum.tasksView,
          PermissionEnum.tasksEdit,

          // Evaluaciones (solo las propias)
          PermissionEnum.evaluationsView,
        ];
    }
  }

  @override
  List<RoleEnum> getRolesForPermission(PermissionEnum permission) {
    final roles = <RoleEnum>[];

    for (final role in RoleEnum.allRoles) {
      final permissions = getPermissionsForRole(role);
      if (permissions.contains(permission)) {
        roles.add(role);
      }
    }

    return roles;
  }

  @override
  bool canManageUser(User currentUser, User targetUser) {
    final currentUserRole = RoleEnum.fromString(currentUser.role);
    final targetUserRole = RoleEnum.fromString(targetUser.role);

    // Un usuario no puede gestionarse a sí mismo
    if (currentUser.id == targetUser.id) {
      return false;
    }

    // Los administradores pueden gestionar a todos
    if (currentUserRole.isAdmin) {
      return true;
    }

    // Los tutores pueden gestionar a estudiantes
    if (currentUserRole.isTutor && targetUserRole.isStudent) {
      return true;
    }

    // Los estudiantes no pueden gestionar a nadie
    return false;
  }
}
