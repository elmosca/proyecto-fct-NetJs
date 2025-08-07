import 'package:flutter/foundation.dart';

/// Configuración de OAuth para diferentes plataformas
class OAuthConfig {
  // Cliente OAuth para Flutter Web
  // Este CLIENT_ID se obtiene del cliente OAuth Web en Google Cloud Console
  static const String webClientId = 'TU_WEB_CLIENT_ID.apps.googleusercontent.com';
  
  // Para Android, las credenciales se configuran automáticamente
  // desde el archivo google-services.json (no necesitas CLIENT_ID en código)
  
  /// Obtiene la configuración de GoogleSignIn según la plataforma
  static Map<String, String>? getGoogleSignInConfig() {
    if (kIsWeb) {
      return {
        'clientId': webClientId,
      };
    }
    // Para Android, retorna null para usar la configuración automática
    return null;
  }
  
  /// Verifica si la configuración OAuth está completa
  static bool isConfigured() {
    if (kIsWeb) {
      return webClientId != 'TU_WEB_CLIENT_ID.apps.googleusercontent.com';
    }
    // Para Android, asumimos que está configurado si llegamos aquí
    return true;
  }
} 
