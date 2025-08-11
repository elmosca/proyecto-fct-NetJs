import 'package:shared_preferences/shared_preferences.dart';
import 'package:fct_frontend/core/constants/app_constants.dart';
import 'package:fct_frontend/core/utils/logger.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Token management
  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
    Logger.success('💾 Token saved');
  }

  Future<String?> getToken() async => _prefs.getString(AppConstants.tokenKey);

  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.tokenKey);
    Logger.info('🗑️ Token cleared');
  }

  // User data management
  Future<void> saveUser(Map<String, dynamic> userData) async {
    // Convert to string for storage
    final userString = userData.toString();
    await _prefs.setString(AppConstants.userKey, userString);
    Logger.success('💾 User data saved');
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userString = _prefs.getString(AppConstants.userKey);
    if (userString != null) {
      // Parse string back to map (simplified)
      // In production, use proper serialization
      return {'userData': userString};
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove(AppConstants.userKey);
    Logger.info('🗑️ User data cleared');
  }

  // Theme management
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(AppConstants.themeKey, themeMode);
  }

  String? getThemeMode() => _prefs.getString(AppConstants.themeKey);

  // Generic storage methods
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) => _prefs.getString(key);

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) => _prefs.getInt(key);

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
    Logger.info('🗑️ All storage cleared');
  }
}
