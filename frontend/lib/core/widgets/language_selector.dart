import 'package:fct_frontend/core/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeProvider.notifier);
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String languageCode) {
        localeNotifier.setLocaleFromLanguageCode(languageCode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'es',
          child: Row(
            children: [
              Text(
                '🇪🇸 Español',
                style: TextStyle(
                  fontWeight: currentLocale.languageCode == 'es'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (currentLocale.languageCode == 'es')
                const Icon(Icons.check, size: 16),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Text(
                '🇺🇸 English',
                style: TextStyle(
                  fontWeight: currentLocale.languageCode == 'en'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (currentLocale.languageCode == 'en')
                const Icon(Icons.check, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
