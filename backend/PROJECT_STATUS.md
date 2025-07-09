# Estado del Proyecto - Backend

## ✅ Completado

### Estructura y Configuración Base
- [x] Configuración inicial del proyecto NestJS.
- [x] Estructura de carpetas y módulos definida.
- [x] Configuración de Docker y `docker-compose` para el entorno de desarrollo.
- [x] Configuración de variables de entorno (`.env`).
- [x] Implementación de sistema de migraciones con TypeORM.
- [x] Generación y ejecución de la migración inicial de la base de datos.

### Modelo de Datos y Entidades
- [x] Implementación de todas las entidades basadas en `Modelo_Datos.md`.
- [x] Entidad `User` (con roles y estado).
- [x] Entidad `Project` (con fechas, estado y relaciones).
- [x] Entidad `Anteproject` (con todos sus campos y relaciones).
- [x] Entidad `Task` (con prioridad, estado y relaciones).
- [x] Entidad `Comment` (con relación a Tarea y Autor).
- [x] Entidad `Milestone` (Hitos del proyecto).
- [x] Entidad `File` (para adjuntos polimórficos).
- [x] Entidad `Notification`.
- [x] Entidad `ActivityLog`.
- [x] Entidades para `Evaluations` (`AnteprojectEvaluationCriteria`, `AnteprojectEvaluations`).
- [x] Entidad `SystemSettings`.
- [x] Implementación de todas las relaciones (`@OneToMany`, `@ManyToOne`, `@ManyToMany`).
- [x] Implementación de Enums para estados, roles y prioridades.

### Módulos y Servicios Base
- [x] Creación de todos los módulos (`Users`, `Projects`, `Tasks`, `Comments`, `Anteprojects`, etc.).
- [x] Implementación y refactorización de los servicios base (`UsersService`, `ProjectsService`, `TasksService`, `CommentsService`, `AuthService`).
- [x] Implementación y refactorización de los controladores base, DTOs y `ParseIntPipe` para la validación y transformación de datos de entrada.

### Autenticación y Autorización
- [x] Implementación de `AuthModule` con Passport.
- [x] Estrategia de autenticación con JWT (`JwtStrategy`).
- [x] Sistema de registro (`/auth/register`) y login (`/auth/login`).
- [x] Sistema de autorización basado en roles (`RolesGuard`, `@Roles` decorator).
- [x] Guards para proteger rutas (`JwtAuthGuard`).
- [x] Integración de `auth-google` con la lógica de creación de usuarios.

### Seguridad Base
- [x] Implementación de DTOs con `class-validator` para toda la entrada de datos.
- [x] Hasheo de contraseñas con `bcrypt`.

### Datos Iniciales (Seeders)
- [x] Creación de sistema de seeders con `ts-node` y `tsconfig-paths`.
- [x] Seeder para los Criterios de Evaluación de Anteproyectos.
- [x] Seeder para crear el usuario Administrador por defecto.

### Testing Base
- [x] Corrección de la configuración de tests E2E con Supertest.

## 🚧 En Progreso

- **Lógica de Negocio y Endpoints (CRUDs)**:
  - [x] Módulo `Users`: Lógica de servicio y permisos refinados (soft-delete, actualización de perfil propio). Tests unitarios añadidos.
  - [x] Módulo `Projects`: Lógica de servicio y permisos implementada (por rol). Tests unitarios añadidos.
  - [x] Módulo `Tasks`: Lógica de servicio y permisos implementada. Tests unitarios añadidos.
  - [x] Módulo `Comments`: Lógica de servicio y permisos implementada. Tests unitarios añadidos.
  - [x] Módulo `Anteprojects`: CRUD básico implementado con permisos. Tests unitarios añadidos.
  - [x] Módulo `Anteprojects`: Implementado el ciclo de vida completo (submit, review, approve, reject, schedule defense, complete). Tests unitarios añadidos.
- **Configuración**:
  - [ ] Configurar CORS de forma granular para el entorno de producción.

## 📝 Pendiente

### Lógica de Negocio y Endpoints
- [x] Desarrollar los endpoints para gestionar las relaciones (ej: añadir un estudiante a un proyecto, asignar una tarea).
- [x] Implementar el sistema de evaluación para los Anteproyectos.
- [ ] Implementar el sistema de subida de archivos para la entidad `File` y asociarlo a los Anteproyectos.

### Funcionalidades Específicas
- [ ] Implementar sistema de Kanban para tareas.
- [ ] Sistema de notificaciones en tiempo real (WebSocket).

### Seguridad Avanzada
- [ ] Implementar manejo de errores global y logging de errores.
- [ ] Implementar `rate limiting` para proteger la API.
- [ ] Configurar HTTPS para producción.
- [ ] Configurar CORS de forma granular (se habilitará al comenzar el desarrollo del frontend).

### Documentación
- [ ] Documentación de API con Swagger/OpenAPI.
- [ ] Completar la documentación técnica del proyecto (`TECHNICAL_DOCUMENTATION.md`).

### Optimización y Despliegue
- [ ] Implementar caché (Redis/memcached).
- [ ] Optimizar consultas a base de datos.
- [ ] Configurar un pipeline de CI/CD (ej: GitHub Actions).
- [ ] Preparar el entorno de producción.

## 📋 Próximos Pasos Inmediatos

1.  **Sistema de Archivos**: Implementar la subida de ficheros y asociarla a las entidades correspondientes.
2.  **Sistema de Kanban**: Implementar la lógica para el tablero Kanban de tareas.

## 📅 Estimación de Tiempos
*(La estimación se reajustará tras completar los próximos pasos)*

## 🔄 Actualizaciones

- **Última actualización**: 2024-07-09
- **Estado actual**: CRUDs, ciclos de vida y sistema de evaluación implementados y probados.
- **Próxima revisión**: [Fecha] 