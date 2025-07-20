# Guía de Contribución

¡Gracias por tu interés en contribuir al Sistema de Gestión de Proyectos FCT! 🎉

## 📋 Tabla de Contenidos
- [Código de Conducta](#código-de-conducta)
- [¿Cómo Puedo Contribuir?](#cómo-puedo-contribuir)
- [Configuración del Entorno](#configuración-del-entorno)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Guías de Estilo](#guías-de-estilo)
- [Proceso de Pull Request](#proceso-de-pull-request)

## Código de Conducta

Este proyecto y todos los participantes están regidos por nuestro Código de Conducta. Al participar, se espera que mantengas este código.

## ¿Cómo Puedo Contribuir?

### 🐛 Reportar Bugs
- Usa el template de bug report en GitHub Issues
- Incluye pasos para reproducir el problema
- Proporciona información del entorno

### ✨ Sugerir Funcionalidades
- Usa el template de feature request
- Explica claramente el problema que resuelve
- Incluye criterios de aceptación

### 💻 Contribuir con Código
- Busca issues etiquetados como `good first issue` para comenzar
- Comenta en el issue que planeas trabajar en él
- Sigue el proceso de desarrollo establecido

## Configuración del Entorno

### Requisitos Previos
- Node.js 18+
- Flutter 3.16+
- PostgreSQL 13+
- Docker & Docker Compose
- VS Code (recomendado)

### Setup Inicial
1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/proyecto-fct.git
   cd proyecto-fct
   ```

2. **Instalar extensiones de VS Code**
   - Abre el proyecto en VS Code
   - Instala las extensiones recomendadas (aparecerá un popup)

3. **Configurar Backend**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Edita .env con tus configuraciones
   docker-compose up -d  # Base de datos
   npm run migration:run
   npm run seed
   ```

4. **Configurar Frontend**
   ```bash
   cd frontend
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

5. **Verificar setup**
   ```bash
   # En VS Code: Ctrl+Shift+P > Tasks: Run Task > "Flujo completo"
   # O ejecutar los tests manualmente
   cd backend && npm test
   cd frontend && flutter test
   ```

## Proceso de Desarrollo

### 🌿 Branching Strategy
- `main`: Código de producción
- `develop`: Integración de nuevas features  
- `feature/nombre-feature`: Nuevas funcionalidades
- `bugfix/nombre-bug`: Corrección de bugs
- `hotfix/nombre-hotfix`: Fixes urgentes para producción

### 🚀 Workflow
1. **Crear rama**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/mi-nueva-feature
   ```

2. **Desarrollar**
   - Sigue las convenciones de código
   - Escribe tests para nuevas funcionalidades
   - Usa commits descriptivos

3. **Testing Local**
   ```bash
   # Backend
   cd backend
   npm run test
   npm run test:e2e
   npm run lint
   
   # Frontend  
   cd frontend
   flutter test --coverage
   flutter analyze
   dart format --set-exit-if-changed .
   ```

4. **Commit y Push**
   ```bash
   git add .
   git commit -m "feat: añadir nueva funcionalidad de autenticación"
   git push origin feature/mi-nueva-feature
   ```

5. **Crear Pull Request**
   - Usa el template de PR
   - Asigna reviewers apropiados
   - Linkea issues relacionados

## Guías de Estilo

### 📝 Nomenclatura (Obligatorio)
```dart
// ✅ Correcto
class UserRepository {}
String userName = '';
const int MAX_RETRY_COUNT = 3;
bool isAuthenticated = false;

// ❌ Incorrecto  
class userRepository {}
String user_name = '';
const int maxRetryCount = 3;
bool authenticated = false;
```

### 🏗️ Arquitectura Flutter
```
lib/
├── core/
│   ├── config/
│   ├── constants/
│   ├── extensions/
│   └── utils/
├── features/
│   └── auth/
│       ├── data/          # Repositories, DataSources
│       ├── domain/        # Entities, UseCases  
│       └── presentation/  # Widgets, Controllers
└── shared/
    ├── widgets/
    └── services/
```

### 💻 Convenciones de Código

**Dart/Flutter:**
- Usa `final` y `const` siempre que sea posible
- Prefiere functions arrow para funciones de < 3 líneas
- Usa early returns para evitar anidación
- Documenta clases y métodos públicos

**TypeScript/NestJS:**
- Usa interfaces para contratos
- Aplica principios SOLID
- Usa decoradores de NestJS apropiadamente
- Valida entrada con class-validator

### 🧪 Testing
```dart
// Patrón Arrange-Act-Assert
testWidgets('should_show_error_when_login_fails', (tester) async {
  // Arrange
  const String invalidEmail = 'invalid@email.com';
  const String expectedError = 'Credenciales inválidas';
  
  // Act
  await tester.pumpWidget(MyApp());
  await tester.enterText(find.byType(TextField), invalidEmail);
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // Assert
  expect(find.text(expectedError), findsOneWidget);
});
```

### 📦 Commits
Usa [Conventional Commits](https://www.conventionalcommits.org/):
```
feat: añadir autenticación con Google
fix: corregir error en validación de email  
docs: actualizar README con instrucciones
style: formatear código con dart format
refactor: extraer lógica común a utils
test: añadir tests para UserRepository
chore: actualizar dependencias
```

## Proceso de Pull Request

### ✅ Checklist Antes de Submit
- [ ] Tests pasan localmente
- [ ] Código sigue las convenciones  
- [ ] Documentación actualizada
- [ ] Sin warnings de análisis
- [ ] Performance considerada
- [ ] Seguridad evaluada

### 🔍 Proceso de Review
1. **Automated Checks**: CI debe pasar
2. **Code Review**: Al menos 1 aprobación requerida
3. **Testing**: QA manual si es necesario
4. **Merge**: Squash and merge hacia develop

### 🚀 Criterios de Aprobación
- Funcionalidad cumple los requisitos
- Tests cubren casos edge
- Código es mantenible y legible
- No introduce regresiones
- Documentación está actualizada

## 🆘 ¿Necesitas Ayuda?

- 📖 Lee la documentación en `/docs`
- 🤖 Revisa `.github/copilot-instructions.md` para patrones
- 💬 Abre un issue con la etiqueta `question`
- 📧 Contacta a los mantenedores

¡Gracias por contribuir! 🙏
