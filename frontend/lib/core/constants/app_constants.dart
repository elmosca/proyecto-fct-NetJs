class AppConstants {
  // API Configuration
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxEmailLength = 254;
  static const int maxNameLength = 100;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 4.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentFormats = ['pdf', 'doc', 'docx', 'txt'];
}
