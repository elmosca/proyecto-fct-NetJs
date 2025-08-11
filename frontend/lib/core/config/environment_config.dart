// Configuración generada automáticamente
// Entorno: development
// Fecha: 2025-08-10 02:32:03

class EnvironmentConfig {
  static const String environment = 'development';
  static const String apiBaseUrl = 'http://localhost:3000';
  static const String wsBaseUrl = 'ws://localhost:3000';
  static const String apiVersion = '/api';

  static String get fullApiUrl => apiBaseUrl + apiVersion;
  static String get fullWsUrl => wsBaseUrl + apiVersion;
}
