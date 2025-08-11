import 'package:fct_frontend/core/config/app_config.dart';

class AppConstants {
  // API Configuration - Ahora usa AppConfig
  static String get baseUrl => AppConfig.current.apiBaseUrl;
  static String get apiVersion => AppConfig.current.apiVersion;
  static String get wsUrl => AppConfig.current.wsBaseUrl;
  
  // URL completa para la API
  static String get fullApiUrl => AppConfig.current.fullApiUrl;
  static String get fullWsUrl => AppConfig.current.fullWsUrl;

  // App Configuration
  static const String appName = 'FCT - Gestión de Proyectos';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String environmentKey = 'environment_config';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
  ];
  static const List<String> allowedDocumentTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ];

  // Método para obtener información de configuración
  static String get configurationInfo => AppConfig.environmentInfo;
  
  // Método para cambiar entorno dinámicamente
  static void setEnvironment(String environment) {
    AppConfig.setEnvironment(environment);
  }
  
  // Listar entornos disponibles
  static List<String> get availableEnvironments => AppConfig.availableEnvironments;
}
