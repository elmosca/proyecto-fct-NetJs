import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('SharedPreferences debe ser inicializado en main()');
}

@Riverpod(keepAlive: true)
TokenManager tokenManager(TokenManagerRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TokenManager(prefs);
} 
