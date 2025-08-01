import 'package:dio/dio.dart';
import 'package:fct_frontend/core/exceptions/app_exception.dart';
import 'package:fct_frontend/core/utils/logger.dart';

class ErrorService {
  ErrorService._();
  static ErrorService? _instance;
  static ErrorService get instance => _instance ??= ErrorService._();

  /// Convertir errores de Dio a AppException
  AppException handleDioError(dynamic error) {
    Logger.error('🚨 Handling Dio error: $error');

    if (error is DioException) {
      return _handleDioException(error);
    }

    return NetworkException.fromDioError(error);
  }

  AppException _handleDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Tiempo de espera agotado. Verifica tu conexión.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Sin conexión a internet. Verifica tu red.',
          code: 'NO_CONNECTION',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Error de certificado SSL.',
          code: 'SSL_ERROR',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(statusCode, data);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Solicitud cancelada',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.unknown:
        return const NetworkException(
          message: 'Error de conexión desconocido',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  AppException _handleBadResponse(int? statusCode, dynamic data) {
    if (statusCode == null) {
      return const NetworkException(
        message: 'Error de respuesta sin código de estado',
        code: 'NO_STATUS_CODE',
      );
    }

    // Extraer mensaje del servidor si está disponible
    String? serverMessage;
    if (data is Map<String, dynamic>) {
      serverMessage = data['message'] as String? ?? data['error'] as String?;
    }

    switch (statusCode) {
      case 400:
        if (data is Map<String, dynamic> && data['errors'] != null) {
          return ValidationException.fromErrors(
            Map<String, List<String>>.from(data['errors']),
          );
        }
        return ValidationException(
          message: serverMessage ?? 'Solicitud inválida',
          code: 'BAD_REQUEST',
        );

      case 401:
        return AuthenticationException.unauthorized();

      case 403:
        return PermissionException.forbidden();

      case 404:
        return NotFoundException(
          message: serverMessage ?? 'Recurso no encontrado',
          code: 'NOT_FOUND',
        );

      case 422:
        if (data is Map<String, dynamic> && data['errors'] != null) {
          return ValidationException.fromErrors(
            Map<String, List<String>>.from(data['errors']),
          );
        }
        return ValidationException(
          message: serverMessage ?? 'Datos de validación inválidos',
          code: 'VALIDATION_ERROR',
        );

      case 429:
        if (data is Map<String, dynamic>) {
          return RateLimitException.fromResponse(data);
        }
        return const RateLimitException(
          message: 'Demasiadas solicitudes. Intenta nuevamente más tarde.',
          code: 'RATE_LIMIT',
        );

      case 500:
      case 502:
      case 503:
        return ServerException.fromStatusCode(statusCode, serverMessage);

      default:
        return ServerException(
          message: serverMessage ?? 'Error del servidor',
          code: 'SERVER_ERROR',
          details: {'statusCode': statusCode},
        );
    }
  }

  /// Manejar errores generales de la aplicación
  AppException handleGeneralError(dynamic error) {
    Logger.error('🚨 Handling general error: $error');

    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return handleDioError(error);
    }

    if (error is Exception) {
      return NetworkException(
        message: error.toString(),
        code: 'GENERAL_ERROR',
        details: {'originalError': error.toString()},
      );
    }

    return NetworkException(
      message: 'Error inesperado: $error',
      code: 'UNEXPECTED_ERROR',
      details: {'originalError': error.toString()},
    );
  }

  /// Obtener mensaje de error amigable para el usuario
  String getUserFriendlyMessage(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException _:
        return 'Problema de conexión. Verifica tu internet.';

      case AuthenticationException _:
        return exception.message;

      case ValidationException _:
        return exception.message;

      case ServerException _:
        return 'Error del servidor. Intenta nuevamente más tarde.';

      case PermissionException _:
        return 'No tienes permisos para realizar esta acción.';

      case NotFoundException _:
        return 'El recurso solicitado no existe.';

      case RateLimitException _:
        return exception.message;

      default:
        return 'Ha ocurrido un error inesperado.';
    }
  }

  /// Verificar si el error es recuperable
  bool isRecoverable(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException _:
      case RateLimitException _:
        return true;

      case AuthenticationException _:
        return exception.code == 'TOKEN_EXPIRED';

      case ValidationException _:
        return true;

      case ServerException _:
        return exception.code == 'SERVICE_UNAVAILABLE';

      default:
        return false;
    }
  }

  /// Obtener acción recomendada para el error
  String getRecommendedAction(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException _:
        return 'Verifica tu conexión a internet y vuelve a intentar.';

      case AuthenticationException _:
        return 'Inicia sesión nuevamente.';

      case ValidationException _:
        return 'Revisa los datos ingresados y vuelve a intentar.';

      case ServerException _:
        return 'Intenta nuevamente en unos minutos.';

      case PermissionException _:
        return 'Contacta al administrador si crees que esto es un error.';

      case RateLimitException _:
        return 'Espera un momento antes de volver a intentar.';

      default:
        return 'Intenta nuevamente o contacta soporte si el problema persiste.';
    }
  }
}
