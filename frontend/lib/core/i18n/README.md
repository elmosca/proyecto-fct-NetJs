# 🌍 Internacionalización (i18n)

## Descripción

Este módulo maneja la internacionalización de la aplicación, proporcionando soporte completo para castellano e inglés.

## Estructura

```
lib/core/i18n/
├── README.md                    # Esta documentación
└── (archivos generados automáticamente)

assets/i18n/
├── app_es.arb                   # Traducciones en castellano
└── app_en.arb                   # Traducciones en inglés
```

## Configuración

### 1. Archivos de Traducción (.arb)

Los archivos `.arb` contienen las traducciones en formato JSON:

```json
{
  "@@locale": "es",
  "appTitle": "FCT - Gestión de Proyectos",
  "@appTitle": {
    "description": "Título de la aplicación"
  }
}
```

### 2. Provider de Idioma

El `LocaleProvider` gestiona el estado del idioma:

```dart
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return LocaleNotifier(storageService);
});
```

### 3. Configuración en MaterialApp

```dart
MaterialApp.router(
  locale: locale,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('es'), // Spanish
    Locale('en'), // English
  ],
)
```

## Uso

### En Widgets

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.appTitle);
  }
}
```

### Cambio de Idioma

```dart
// En un ConsumerWidget
final localeNotifier = ref.read(localeProvider.notifier);
localeNotifier.setLocaleFromLanguageCode('en');
```

### Widget de Selección

```dart
LanguageSelector() // Widget incluido en core/widgets/
```

## Comandos Útiles

```bash
# Generar archivos de localización
flutter gen-l10n

# Ejecutar tests de internacionalización
flutter test test/core/i18n/

# Verificar traducciones
flutter analyze lib/core/i18n/
```

## Agregar Nuevas Traducciones

1. Añadir la clave en `app_es.arb`:
```json
{
  "newKey": "Nuevo texto en castellano",
  "@newKey": {
    "description": "Descripción de la traducción"
  }
}
```

2. Añadir la clave en `app_en.arb`:
```json
{
  "newKey": "New text in English",
  "@newKey": {
    "description": "Description of the translation"
  }
}
```

3. Regenerar archivos:
```bash
flutter gen-l10n
```

4. Usar en el código:
```dart
Text(AppLocalizations.of(context)!.newKey)
```

## Consideraciones

- **Persistencia**: El idioma seleccionado se guarda automáticamente
- **Fallback**: Si falta una traducción, se usa el idioma por defecto
- **Performance**: Las traducciones se cargan de forma eficiente
- **Testing**: Incluir tests para ambos idiomas

## Troubleshooting

### Error: "AppLocalizations not found"
- Verificar que `generate: true` esté en `pubspec.yaml`
- Ejecutar `flutter gen-l10n`
- Verificar imports en `main.dart`

### Traducciones no se actualizan
- Limpiar cache: `flutter clean`
- Regenerar: `flutter gen-l10n`
- Rebuild: `flutter pub get` 