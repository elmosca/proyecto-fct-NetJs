import 'package:flutter/foundation.dart';

/// Configuración de la aplicación según el entorno
class AppConfig {
  // Configuraciones por entorno
  static const Map<String, EnvironmentConfig> _environments = {
    'development': EnvironmentConfig(
      apiBaseUrl: 'http://localhost:3000',
      wsBaseUrl: 'ws://localhost:3000',
      apiVersion: '/api', // Cambiado de /api/v1 a /api
    ),
    'wsl': EnvironmentConfig(
      apiBaseUrl: 'http://localhost:3000', // WSL expone puerto 3000 a Windows
      wsBaseUrl: 'ws://localhost:3000',
      apiVersion: '/api', // Cambiado de /api/v1 a /api
    ),
    'production': EnvironmentConfig(
      apiBaseUrl: 'https://api.tudominio.com',
      wsBaseUrl: 'wss://api.tudominio.com',
      apiVersion: '/api/v1',
    ),
    'staging': EnvironmentConfig(
      apiBaseUrl: 'https://staging-api.tudominio.com',
      wsBaseUrl: 'wss://staging-api.tudominio.com',
      apiVersion: '/api/v1',
    ),
    'remote': EnvironmentConfig(
      apiBaseUrl:
          'http://192.168.1.100:3000', // Ejemplo: backend en otro equipo
      wsBaseUrl: 'ws://192.168.1.100:3000',
      apiVersion: '/api', // Cambiado de /api/v1 a /api
    ),
  };

  // Obtener configuración del entorno actual
  static EnvironmentConfig get current {
    // Por defecto usa 'development', pero puedes cambiar esto
    const environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );

    return _environments[environment] ?? _environments['development']!;
  }

  // Método para cambiar configuración dinámicamente
  static void setEnvironment(String environment) {
    if (_environments.containsKey(environment)) {
      // En una implementación real, esto podría usar un provider o similar
      print('🔄 Environment changed to: $environment');
    } else {
      print('⚠️ Unknown environment: $environment');
    }
  }

  // Método para configurar URL personalizada
  static EnvironmentConfig createCustomConfig({
    required String apiBaseUrl,
    required String wsBaseUrl,
    String apiVersion = '/api',
  }) {
    return EnvironmentConfig(
      apiBaseUrl: apiBaseUrl,
      wsBaseUrl: wsBaseUrl,
      apiVersion: apiVersion,
    );
  }

  // Listar entornos disponibles
  static List<String> get availableEnvironments => _environments.keys.toList();

  // Verificar si estamos en modo debug
  static bool get isDebug => kDebugMode;

  // Obtener información del entorno actual
  static String get environmentInfo {
    final env = current;
    return '''
🌍 Environment Configuration:
   API Base URL: ${env.apiBaseUrl}
   WebSocket URL: ${env.wsBaseUrl}
   API Version: ${env.apiVersion}
   Debug Mode: $isDebug
''';
  }
}

/// Configuración específica de un entorno
class EnvironmentConfig {
  final String apiBaseUrl;
  final String wsBaseUrl;
  final String apiVersion;

  const EnvironmentConfig({
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.apiVersion,
  });

  // URL completa para la API
  String get fullApiUrl => '$apiBaseUrl$apiVersion';

  // URL completa para WebSocket
  String get fullWsUrl => '$wsBaseUrl$apiVersion';

  @override
  String toString() {
    return 'EnvironmentConfig(apiBaseUrl: $apiBaseUrl, wsBaseUrl: $wsBaseUrl, apiVersion: $apiVersion)';
  }
}
