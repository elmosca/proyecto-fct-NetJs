import 'package:shared_preferences/shared_preferences.dart';

/// Gestor de tokens JWT para almacenamiento persistente
class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  final SharedPreferences _prefs;

  TokenManager(this._prefs);

  /// Guarda los tokens de autenticación
  Future<void> saveTokens(String token, [String? refreshToken]) async {
    await _prefs.setString(_tokenKey, token);
    if (refreshToken != null) {
      await _prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  /// Guarda el ID del usuario autenticado
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  /// Obtiene el token de autenticación
  String? get token => _prefs.getString(_tokenKey);

  /// Obtiene el token de autenticación (método async para compatibilidad)
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  /// Obtiene el refresh token
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  /// Obtiene el ID del usuario
  String? get userId => _prefs.getString(_userIdKey);

  /// Verifica si hay un token válido almacenado
  bool get hasValidToken => token != null && token!.isNotEmpty;

  /// Limpia todos los tokens almacenados
  Future<void> clearTokens() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
  }

  /// Limpia completamente todos los datos de autenticación
  Future<void> clearAll() async {
    await clearTokens();
    // Aquí se pueden añadir otros datos relacionados con la sesión
  }
} 
