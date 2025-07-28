import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  success,
}

class Logger {
  static const String _tag = 'FCT_APP';
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  static void debug(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag);
  }

  static void info(String message, [String? tag]) {
    _log(LogLevel.info, message, tag);
  }

  static void warning(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag);
  }

  static void error(String message,
      [dynamic error, StackTrace? stackTrace, String? tag]) {
    _log(LogLevel.error, message, tag, error, stackTrace);
  }

  static void success(String message, [String? tag]) {
    _log(LogLevel.success, message, tag);
  }

  static void _log(
    LogLevel level,
    String message, [
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (!kDebugMode) return;

    final timestamp = _dateFormat.format(DateTime.now());
    final logTag = tag ?? _tag;
    final emoji = _getEmoji(level);
    final levelName = level.name.toUpperCase();

    final logMessage = '$emoji [$timestamp] $levelName [$logTag]: $message';
    print(logMessage);

    if (error != null) {
      print('   Error details: $error');
    }

    if (stackTrace != null) {
      print('   Stack trace: $stackTrace');
    }
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.success:
        return '✅';
    }
  }

  /// Log para operaciones de red
  static void network(String message, [String? tag]) {
    _log(LogLevel.info, message, tag ?? 'NETWORK');
  }

  /// Log para operaciones de autenticación
  static void auth(String message, [String? tag]) {
    _log(LogLevel.info, message, tag ?? 'AUTH');
  }

  /// Log para operaciones de base de datos
  static void database(String message, [String? tag]) {
    _log(LogLevel.info, message, tag ?? 'DATABASE');
  }

  /// Log para operaciones de UI
  static void ui(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag ?? 'UI');
  }

  /// Log para operaciones de estado
  static void state(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag ?? 'STATE');
  }

  /// Log para operaciones de WebSocket
  static void websocket(String message, [String? tag]) {
    _log(LogLevel.info, message, tag ?? 'WEBSOCKET');
  }

  /// Log para operaciones de archivos
  static void file(String message, [String? tag]) {
    _log(LogLevel.info, message, tag ?? 'FILE');
  }

  /// Log para operaciones de cache
  static void cache(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag ?? 'CACHE');
  }

  /// Log para operaciones de API
  static void api(String message, [String? tag]) {
    _log(LogLevel.info, message, tag ?? 'API');
  }

  /// Log para operaciones de validación
  static void validation(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag ?? 'VALIDATION');
  }

  /// Log para operaciones de seguridad
  static void security(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag ?? 'SECURITY');
  }
}
