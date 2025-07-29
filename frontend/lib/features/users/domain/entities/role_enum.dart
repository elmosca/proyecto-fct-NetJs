enum RoleEnum {
  student('student', 'Alumno'),
  tutor('tutor', 'Tutor'),
  admin('admin', 'Administrador');

  const RoleEnum(this.value, this.displayName);

  final String value;
  final String displayName;

  static RoleEnum fromString(String value) {
    return RoleEnum.values.firstWhere(
      (role) => role.value == value,
      orElse: () => RoleEnum.student,
    );
  }

  static List<RoleEnum> get allRoles => RoleEnum.values;

  static List<RoleEnum> get adminRoles => [RoleEnum.admin];

  static List<RoleEnum> get tutorRoles => [RoleEnum.tutor, RoleEnum.admin];

  static List<RoleEnum> get studentRoles =>
      [RoleEnum.student, RoleEnum.tutor, RoleEnum.admin];

  bool get isAdmin => this == RoleEnum.admin;
  bool get isTutor => this == RoleEnum.tutor || this == RoleEnum.admin;
  bool get isStudent => this == RoleEnum.student;

  @override
  String toString() => value;
}
