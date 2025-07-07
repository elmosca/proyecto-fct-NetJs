# Sistema de Gestión de Proyectos FCT

Sistema completo para la gestión de proyectos de FCT, desarrollado con NestJS (backend) y Flutter (frontend).

## Estructura del Proyecto

```
proyecto-fct/
├── backend/                   # Backend en NestJS
│   ├── src/                  # Código fuente del backend
│   ├── test/                 # Pruebas del backend
│   └── docs/                 # Documentación técnica
├── frontend/                 # Frontend en Flutter
│   ├── lib/                  # Código fuente de Flutter
│   └── test/                 # Pruebas de Flutter
└── docs/                     # Documentación general del proyecto
```

## Requisitos Previos

### Backend
- Node.js 18+
- PostgreSQL 13+
- Docker y Docker Compose

### Frontend
- Flutter 3.0+
- Android Studio / VS Code
- Android SDK / iOS SDK

## Configuración del Entorno de Desarrollo

### Backend

1. Navegar al directorio del backend:
   ```bash
   cd backend
   ```

2. Instalar dependencias:
   ```bash
   npm install
   ```

3. Configurar variables de entorno:
   ```bash
   cp .env.example .env
   ```

4. Iniciar la base de datos con Docker:
   ```bash
   docker-compose up -d
   ```

5. Ejecutar migraciones:
   ```bash
   npm run migration:run
   ```

6. Iniciar el servidor de desarrollo:
   ```bash
   npm run start:dev
   ```

### Frontend

1. Navegar al directorio del frontend:
   ```bash
   cd frontend
   ```

2. Instalar dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

## Documentación

- [Documentación Técnica del Backend](./backend/docs/TECHNICAL_DOCUMENTATION.md)
- [Estado del Proyecto](./backend/docs/PROJECT_STATUS.md)

## Scripts Disponibles

### Backend
```bash
# Desarrollo
npm run start:dev

# Producción
npm run build
npm run start:prod

# Pruebas
npm run test
npm run test:e2e
```

### Frontend
```bash
# Desarrollo
flutter run

# Construir APK
flutter build apk

# Ejecutar pruebas
flutter test
```

## Estrategia de Ramas y Contribución (Git Flow Simplificado)

Este proyecto utiliza una estrategia de ramas simplificada basada en Git Flow para mantener el código organizado y estable.

### Ramas Principales

-   `main`: Contiene el código de producción. Es una rama estable y solo se actualiza con versiones probadas desde `develop`. No se debe trabajar directamente en ella.
-   `develop`: Es la rama principal de integración. Todo el nuevo desarrollo se concentra aquí antes de pasar a producción.

### Flujo de Trabajo para Contribuir

1.  **Asegúrate de estar en la rama `develop` y tener la última versión:**
    ```bash
    git checkout develop
    # git pull origin develop  (Cuando el repositorio remoto esté configurado)
    ```

2.  **Crea una rama para la nueva funcionalidad (feature):**
    El nombre debe ser descriptivo, en minúsculas y separado por guiones.
    ```bash
    # Ejemplo: git checkout -b feature/login-con-google
    git checkout -b feature/nombre-de-la-funcionalidad
    ```

3.  **Realiza tus cambios y haz commits:**
    Sigue las [convenciones de commits](#convenciones-de-commits) definidas.
    ```bash
    git add .
    git commit -m "feat(auth): implementar nueva funcionalidad"
    ```

4.  **Sube tus cambios a tu rama remota:**
    ```bash
    # git push origin feature/nombre-de-la-funcionalidad
    ```

5.  **Crea una Pull Request (PR)** en la plataforma remota (GitHub, GitLab, etc.) desde tu rama `feature` hacia la rama `develop`. Esto permitirá revisar el código antes de integrarlo.

## Convenciones de Commits

Para mantener un historial de cambios limpio y legible, todos los commits deben seguir las siguientes reglas:

- **Idioma**: Todos los mensajes de commit deben estar escritos en **castellano**.
- **Formato**: Se debe seguir el estándar de [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

El formato general es:
```
<tipo>(<ámbito opcional>): <descripción>
```

**Tipos de commit permitidos:**
- `feat`: Una nueva funcionalidad (feature).
- `fix`: Una corrección de un error (bug fix).
- `docs`: Cambios en la documentación.
- `style`: Cambios que no afectan el significado del código (espacios, formato, etc.).
- `refactor`: Una refactorización de código que no arregla un bug ni añade una funcionalidad.
- `test`: Añadir o corregir tests.
- `chore`: Cambios en el proceso de build, dependencias o herramientas auxiliares.

**Ejemplo:**
```bash
git commit -m "feat(auth): implementar inicio de sesión con Google"
git commit -m "fix(api): corregir error en la paginación de usuarios"
```

## Licencia

Este proyecto está bajo la Licencia [Creative Commons Attribution-NonCommercial 4.0 International](https://creativecommons.org/licenses/by-nc/4.0/). 
Ver el archivo [LICENSE](./LICENSE) para más detalles. 