class AppConfig {
  static const String appName = 'Sistema FCT';
  static const String baseUrl = 'http://localhost:3000/api';
  
  // API Endpoints según backend NestJS
  static const String authPath = '/auth';
  static const String usersPath = '/users';
  static const String projectsPath = '/projects';
  static const String anteprojectsPath = '/anteprojects';
  static const String tasksPath = '/tasks';
  static const String milestonesPath = '/milestones';
  static const String evaluationsPath = '/evaluations';
  static const String commentsPath = '/comments';
  static const String notificationsPath = '/notifications';
  static const String filesPath = '/files';
  
  // Storage Keys para JWT
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  
  // Google OAuth
  static const String googleClientId = 'google_client_id'; // TODO: Configurar en environment
}
