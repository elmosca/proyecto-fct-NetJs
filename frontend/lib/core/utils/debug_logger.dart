import 'package:flutter/foundation.dart';

class DebugLogger {
  static const String _tag = '🔍 DEBUG';

  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag ?? _tag;
      print('[$timestamp] $logTag: $message');
    }
  }

  static void logAuth(String message) {
    log(message, tag: '🔐 AUTH');
  }

  static void logNetwork(String message) {
    log(message, tag: '🌐 NETWORK');
  }

  static void logState(String message) {
    log(message, tag: '📊 STATE');
  }

  static void logError(String message,
      [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('[$timestamp] ❌ ERROR: $message');
      if (error != null) {
        print('[$timestamp] ❌ ERROR DETAILS: $error');
      }
      if (stackTrace != null) {
        print('[$timestamp] ❌ STACK TRACE: $stackTrace');
      }
    }
  }

  static void logSuccess(String message) {
    log(message, tag: '✅ SUCCESS');
  }

  static void logWarning(String message) {
    log(message, tag: '⚠️ WARNING');
  }
}
