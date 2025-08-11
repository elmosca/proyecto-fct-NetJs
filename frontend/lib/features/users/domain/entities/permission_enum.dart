enum PermissionEnum {
  // Permisos de usuarios
  usersView('users:view', 'Ver usuarios'),
  usersCreate('users:create', 'Crear usuarios'),
  usersEdit('users:edit', 'Editar usuarios'),
  usersDelete('users:delete', 'Eliminar usuarios'),
  usersManageRoles('users:manage_roles', 'Gestionar roles de usuarios'),

  // Permisos de proyectos
  projectsView('projects:view', 'Ver proyectos'),
  projectsCreate('projects:create', 'Crear proyectos'),
  projectsEdit('projects:edit', 'Editar proyectos'),
  projectsDelete('projects:delete', 'Eliminar proyectos'),
  projectsAssign('projects:assign', 'Asignar proyectos'),

  // Permisos de anteproyectos
  anteprojectsView('anteprojects:view', 'Ver anteproyectos'),
  anteprojectsCreate('anteprojects:create', 'Crear anteproyectos'),
  anteprojectsEdit('anteprojects:edit', 'Editar anteproyectos'),
  anteprojectsDelete('anteprojects:delete', 'Eliminar anteproyectos'),
  anteprojectsEvaluate('anteprojects:evaluate', 'Evaluar anteproyectos'),

  // Permisos de tareas
  tasksView('tasks:view', 'Ver tareas'),
  tasksCreate('tasks:create', 'Crear tareas'),
  tasksEdit('tasks:edit', 'Editar tareas'),
  tasksDelete('tasks:delete', 'Eliminar tareas'),
  tasksAssign('tasks:assign', 'Asignar tareas'),

  // Permisos de evaluaciones
  evaluationsView('evaluations:view', 'Ver evaluaciones'),
  evaluationsCreate('evaluations:create', 'Crear evaluaciones'),
  evaluationsEdit('evaluations:edit', 'Editar evaluaciones'),
  evaluationsDelete('evaluations:delete', 'Eliminar evaluaciones'),

  // Permisos de reportes
  reportsView('reports:view', 'Ver reportes'),
  reportsGenerate('reports:generate', 'Generar reportes'),
  reportsExport('reports:export', 'Exportar reportes'),

  // Permisos de configuración
  settingsView('settings:view', 'Ver configuración'),
  settingsEdit('settings:edit', 'Editar configuración'),

  // Permisos de auditoría
  auditView('audit:view', 'Ver auditoría'),
  auditExport('audit:export', 'Exportar auditoría');

  const PermissionEnum(this.value, this.displayName);

  final String value;
  final String displayName;

  static PermissionEnum fromString(String value) {
    return PermissionEnum.values.firstWhere(
      (permission) => permission.value == value,
      orElse: () => throw ArgumentError('Permiso no válido: $value'),
    );
  }

  static List<PermissionEnum> get allPermissions => PermissionEnum.values;

  @override
  String toString() => value;
}
