# Configuración VS Code para Proyecto Flutter

Esta documentación describe la configuración específica de Visual Studio Code para el proyecto Flutter, basada en las reglas definidas en `flutter.mdc`.

## 📁 Archivos de Configuración

### `.vscode/settings.json`
Configuración principal del workspace que incluye:

- **Formateo automático**: Se aplica al guardar y al escribir
- **Análisis de código**: Configurado para Dart/Flutter
- **Anidamiento de archivos**: Agrupa archivos generados (.g.dart, .freezed.dart)
- **Configuración específica de Dart**: Espaciado, tabulación, autocompletado

### `.vscode/tasks.json`
Tareas predefinidas para desarrollo:

- `Flutter: Análisis completo` - Ejecuta `flutter analyze`
- `Flutter: Formatear código` - Formatea archivos Dart
- `Flutter: Limpiar proyecto` - Ejecuta `flutter clean`
- `Flutter: Obtener dependencias` - Ejecuta `flutter pub get`
- `Flutter: Ejecutar tests` - Ejecuta tests unitarios
- `Flutter: Tests con cobertura` - Tests con reporte de cobertura
- `Flutter: Generar código (build_runner)` - Genera código con build_runner
- `Flutter: Watch build_runner` - Observa cambios para generar código
- `Flujo completo` - Ejecuta limpieza, dependencias, generación y análisis

### `.vscode/launch.json`
Configuraciones de depuración:

- **Flutter Debug**: Depuración estándar de la app Flutter
- **Flutter Profile/Release**: Modos de rendimiento
- **Flutter Tests**: Depuración de tests
- **Backend Debug**: Depuración del backend NestJS
- **Full Stack Debug**: Depura frontend y backend simultáneamente

### `.vscode/extensions.json`
Extensiones recomendadas:

#### Esenciales
- `dart-code.dart-code` - Soporte para Dart
- `dart-code.flutter` - Soporte para Flutter

#### Desarrollo
- `usernamehw.errorlens` - Muestra errores inline
- `streetsidesoftware.code-spell-checker` - Corrector ortográfico
- `ms-vscode.vscode-json` - Mejor soporte JSON

#### Git
- `mhutchie.git-graph` - Visualización del historial Git
- `eamodio.gitlens` - Funcionalidades avanzadas Git

### `.vscode/flutter.code-snippets`
Snippets personalizados basados en las reglas:

## 🚀 Snippets Disponibles

| Prefijo | Descripción |
|---------|-------------|
| `flsw` | StatelessWidget con convenciones |
| `flstw` | StatefulWidget con convenciones |
| `flrepo` | Interface Repository |
| `flrepoimpl` | Implementación Repository |
| `flservice` | Clase Service con inyección |
| `flcontroller` | Controller con Riverpod |
| `fltest` | Test Arrange-Act-Assert |
| `flgwt` | Test Given-When-Then |
| `flfreezed` | Clase Freezed |
| `flgetit` | Registro GetIt |
| `flearlyreturn` | Patrón early return |

## ⚙️ Configuraciones Aplicadas

### Principios de las Reglas Flutter.mdc

1. **Nomenclatura**:
   - Archivos y carpetas: `underscore_case`
   - Clases: `PascalCase`  
   - Variables/métodos: `camelCase`
   - Constantes: `UPPER_SNAKE_CASE`

2. **Formateo**:
   - Línea máxima: 80 caracteres
   - Tabulación: 2 espacios
   - Formateo automático al guardar

3. **Análisis**:
   - Análisis continuo de código
   - Organización automática de imports
   - Aplicación automática de fixes

4. **Testing**:
   - Patrón Arrange-Act-Assert
   - Nombres descriptivos (`input`, `expected`, `actual`)
   - Soporte para Given-When-Then

5. **Arquitectura**:
   - Clean Architecture
   - Riverpod para estado
   - GetIt para inyección de dependencias
   - Freezed para modelos de datos

## 🎯 Comandos Útiles

### Paleta de Comandos (Ctrl+Shift+P)

- `Flutter: New Project` - Crear nuevo proyecto Flutter
- `Flutter: Get Packages` - Obtener dependencias
- `Flutter: Clean` - Limpiar proyecto
- `Dart: Use Recommended Settings` - Aplicar configuraciones recomendadas

### Atajos de Teclado

- `Ctrl+Shift+P` - Paleta de comandos
- `Ctrl+Shift+F` - Buscar en archivos
- `F5` - Iniciar depuración
- `Ctrl+F5` - Ejecutar sin depurar
- `Ctrl+Shift+` ` - Terminal integrado

### Tasks (Ctrl+Shift+P > Tasks: Run Task)

- Ejecutar cualquiera de las tareas definidas en `tasks.json`
- Usar `Flujo completo` para setup completo del proyecto

## 📋 Checklist de Setup Inicial

- [ ] Instalar extensiones recomendadas
- [ ] Verificar configuración de Dart SDK
- [ ] Ejecutar `Flutter: Get Packages`
- [ ] Ejecutar `Flutter: Generar código (build_runner)`
- [ ] Verificar que no hay errores en `Flutter: Análisis completo`
- [ ] Probar depuración con `F5`

## 🔧 Troubleshooting

### Extensiones de Dart/Flutter no funcionan
1. Verificar que Dart SDK está instalado
2. Comando: `Flutter: Change SDK`
3. Reiniciar VS Code

### Errores de análisis
1. Ejecutar `Flutter: Clean`
2. Ejecutar `Flutter: Get Packages`
3. Verificar `pubspec.yaml`

### Build runner no genera archivos
1. Verificar dependencias en `pubspec.yaml`
2. Ejecutar `Flutter: Generar código (build_runner)`
3. Verificar permisos de archivos

---

## 💡 Consejos

- Usa `Ctrl+.` para acciones rápidas (quick fixes)
- Los errores se muestran inline con ErrorLens
- Los snippets se activan automáticamente al escribir el prefijo
- Utiliza el explorador de archivos anidado para mejor organización
- Aprovecha las tareas predefinidas para workflows comunes
