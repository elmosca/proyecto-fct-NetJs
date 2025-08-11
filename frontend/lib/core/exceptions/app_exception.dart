/// Excepción base para errores de la aplicación
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Excepción para errores de red
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });

  factory NetworkException.fromDioError(dynamic error) {
    if (error is Exception) {
      return NetworkException(
        message: 'Error de conexión: ${error.toString()}',
        code: 'NETWORK_ERROR',
        details: {'originalError': error.toString()},
      );
    }
    return const NetworkException(
      message: 'Error de conexión desconocido',
      code: 'NETWORK_ERROR',
    );
  }
}

/// Excepción para errores de autenticación
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
  });

  factory AuthenticationException.unauthorized() =>
      const AuthenticationException(
        message: 'No autorizado. Por favor, inicia sesión.',
        code: 'UNAUTHORIZED',
      );

  factory AuthenticationException.invalidCredentials() =>
      const AuthenticationException(
        message: 'Credenciales inválidas',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthenticationException.tokenExpired() =>
      const AuthenticationException(
        message: 'Sesión expirada. Por favor, inicia sesión nuevamente.',
        code: 'TOKEN_EXPIRED',
      );
}

/// Excepción para errores de validación
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });

  factory ValidationException.fromErrors(Map<String, List<String>> errors) {
    final errorMessages = errors.entries
        .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
        .join('; ');

    return ValidationException(
      message: 'Error de validación: $errorMessages',
      code: 'VALIDATION_ERROR',
      details: {'errors': errors},
    );
  }
}

/// Excepción para errores del servidor
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
  });

  factory ServerException.fromStatusCode(int statusCode, String? message) {
    String defaultMessage;
    String code;

    switch (statusCode) {
      case 500:
        defaultMessage = 'Error interno del servidor';
        code = 'INTERNAL_SERVER_ERROR';
        break;
      case 502:
        defaultMessage = 'Error de comunicación con el servidor';
        code = 'BAD_GATEWAY';
        break;
      case 503:
        defaultMessage = 'Servicio no disponible';
        code = 'SERVICE_UNAVAILABLE';
        break;
      default:
        defaultMessage = 'Error del servidor';
        code = 'SERVER_ERROR';
    }

    return ServerException(
      message: message ?? defaultMessage,
      code: code,
      details: {'statusCode': statusCode},
    );
  }
}

/// Excepción para errores de permisos
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.details,
  });

  factory PermissionException.insufficientPermissions() =>
      const PermissionException(
        message: 'No tienes permisos suficientes para realizar esta acción',
        code: 'INSUFFICIENT_PERMISSIONS',
      );

  factory PermissionException.forbidden() => const PermissionException(
        message: 'Acceso denegado',
        code: 'FORBIDDEN',
      );
}

/// Excepción para errores de recursos no encontrados
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code,
    super.details,
  });

  factory NotFoundException.resourceNotFound(String resource) =>
      NotFoundException(
        message: '$resource no encontrado',
        code: 'RESOURCE_NOT_FOUND',
        details: {'resource': resource},
      );
}

/// Excepción para errores de rate limiting
class RateLimitException extends AppException {
  const RateLimitException({
    required super.message,
    super.code,
    super.details,
  });

  factory RateLimitException.fromResponse(Map<String, dynamic> data) {
    final retryAfter = data['retryAfter'] as int?;
    final message = retryAfter != null
        ? 'Demasiadas solicitudes. Intenta nuevamente en $retryAfter segundos.'
        : 'Demasiadas solicitudes. Intenta nuevamente más tarde.';

    return RateLimitException(
      message: message,
      code: 'RATE_LIMIT_EXCEEDED',
      details: data,
    );
  }
}
