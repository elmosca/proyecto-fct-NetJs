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

## Contribución

1. Crear una rama para la nueva característica:
   ```bash
   git checkout -b feature/nueva-caracteristica
   ```

2. Realizar cambios y hacer commit:
   ```bash
   git add .
   git commit -m "feat: añade nueva característica"
   ```

3. Subir cambios:
   ```bash
   git push origin feature/nueva-caracteristica
   ```

4. Crear Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](./LICENSE) para más detalles. 