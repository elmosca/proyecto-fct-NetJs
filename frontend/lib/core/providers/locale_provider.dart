import 'package:fct_frontend/core/di/injection_container.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _localeKey = 'app_locale';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storageService) : super(const Locale('es')) {
    _loadSavedLocale();
  }
  final StorageService _storageService;

  Future<void> _loadSavedLocale() async {
    final savedLocale = _storageService.getString(_localeKey);
    if (savedLocale != null) {
      state = Locale(savedLocale);
    }
  }

  Future<void> setLocale(Locale locale) async {
    await _storageService.saveString(_localeKey, locale.languageCode);
    state = locale;
  }

  Future<void> setLocaleFromLanguageCode(String languageCode) async {
    await setLocale(Locale(languageCode));
  }

  bool get isSpanish => state.languageCode == 'es';
  bool get isEnglish => state.languageCode == 'en';
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return LocaleNotifier(storageService);
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return getIt<StorageService>();
});
