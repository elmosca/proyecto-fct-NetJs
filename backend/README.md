# Backend - Proyecto FCT

<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Logo de Nest" /></a>
</p>

## Descripción
Backend API REST para la gestión de proyectos, usuarios y tareas, pensado para integrarse con una app Flutter. Basado en NestJS, PostgreSQL y TypeORM, con autenticación JWT y Google, sistema de roles y notificaciones por email.

## Estructura del Proyecto
```
backend/
├── src/
│   ├── auth/                  # Autenticación local y Google
│   ├── users/                 # Gestión de usuarios y roles
│   ├── projects/              # Gestión de proyectos
│   ├── tasks/                 # Gestión de tareas
│   ├── comments/              # Comentarios en tareas/proyectos
│   ├── mailer/                # Servicio de envío de emails
│   ├── roles/                 # Definición de roles y permisos
│   ├── config/                # Configuración y validaciones
│   └── app.module.ts          # Módulo principal
├── docs/                      # Documentación técnica
├── .env.example               # Ejemplo de variables de entorno
├── docker-compose.yml         # Configuración Docker
└── Dockerfile                 # Imagen Docker del backend
```

## Sistema de Roles
El backend implementa un sistema jerárquico de roles (`RoleEnum`):
- **ALUMNO**: Acceso básico, gestión de sus datos y visualización de proyectos asignados.
- **TUTOR**: Supervisión de proyectos, gestión de alumnos y colaboradores.
- **COLABORADOR**: Participación en proyectos asignados.
- **ADMINISTRADOR**: Acceso completo, gestión de usuarios y roles.

## Autenticación
- **JWT**: Login y registro tradicionales con email y contraseña.
- **Google OAuth**: Login con cuenta de Google (requiere configuración previa).
- **Protección de rutas**: Guards y decoradores para autorización por rol.

## Sistema de Emails
- Envío de emails de bienvenida, recuperación de contraseña e invitaciones a proyectos.
- Plantillas personalizables en `src/mailer/templates/`.

## Integración con Flutter
- API pensada para ser consumida por apps móviles/web.
- CORS configurado para desarrollo local.
- Uso de JWT para autenticación en el frontend.

## Ejecución del Proyecto
### Desarrollo
```bash
cd backend
npm install
npm run start:dev
```

### Producción (Docker)
```bash
cd backend
docker-compose up --build
```

## Más información
- Consulta la documentación técnica en `backend/docs/TECHNICAL_DOCUMENTATION.md` para:
  - Variables de entorno necesarias
  - Listado de endpoints
  - Detalles de integración y arquitectura
  - Ejemplos de uso avanzados
