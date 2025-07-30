/// Validadores reutilizables para formularios
class Validators {
  /// Valida que el campo no esté vacío
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es obligatorio';
    }
    return null;
  }

  /// Valida formato de email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es obligatorio';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }

    return null;
  }

  /// Valida longitud mínima
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $minLength caracteres';
    }
    return null;
  }

  /// Valida longitud máxima
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Este campo'} no puede tener más de $maxLength caracteres';
    }
    return null;
  }

  /// Valida contraseña
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    // Validar que contenga al menos una letra mayúscula, una minúscula y un número
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(value);

    if (!hasUpperCase || !hasLowerCase || !hasNumbers) {
      return 'La contraseña debe contener al menos una letra mayúscula, una minúscula y un número';
    }

    return null;
  }

  /// Valida confirmación de contraseña
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Valida nombre (solo letras y espacios)
  static String? name(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'El nombre'} es obligatorio';
    }

    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');

    if (!nameRegex.hasMatch(value)) {
      return '${fieldName ?? 'El nombre'} solo puede contener letras y espacios';
    }

    if (value.trim().length < 2) {
      return '${fieldName ?? 'El nombre'} debe tener al menos 2 caracteres';
    }

    return null;
  }

  /// Valida rol
  static String? role(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El rol es obligatorio';
    }

    final validRoles = ['student', 'tutor', 'admin'];

    if (!validRoles.contains(value.toLowerCase())) {
      return 'Rol no válido';
    }

    return null;
  }

  /// Valida URL (opcional)
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL es opcional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida';
    }

    return null;
  }

  /// Valida teléfono (opcional)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Teléfono es opcional
    }

    final phoneRegex = RegExp(r'^[\+]?[0-9\s\-\(\)]{9,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }

    return null;
  }

  /// Valida que el valor esté en un rango numérico
  static String? range(String? value, int min, int max, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es obligatorio';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Este campo'} debe ser un número';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'Este campo'} debe estar entre $min y $max';
    }

    return null;
  }

  /// Valida que el valor sea un número entero positivo
  static String? positiveInteger(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es obligatorio';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Este campo'} debe ser un número entero';
    }

    if (number <= 0) {
      return '${fieldName ?? 'Este campo'} debe ser mayor a 0';
    }

    return null;
  }

  /// Combina múltiples validadores
  static String? combine(
      List<String? Function(String?)> validators, String? value) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
