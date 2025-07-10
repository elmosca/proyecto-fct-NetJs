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

### Funcionalidades Clave
- [x] Implementar el sistema de subida de archivos para la entidad `File` y asociarlo a los Anteproyectos de forma polimórfica y con relación directa.

### Funcionalidades Específicas
- [x] Implementar sistema de Kanban para tareas.
- [x] Sistema de notificaciones en tiempo real (WebSocket).

## 🚧 En Progreso

- **Lógica de Negocio y Endpoints (CRUDs)**:
  - [x] Módulo `Users`: Lógica de servicio y permisos refinados (soft-delete, actualización de perfil propio). Tests unitarios añadidos.
  - [x] Módulo `Projects`: Lógica de servicio y permisos implementada (por rol). Tests unitarios añadidos.
  - [x] Módulo `Tasks`: Lógica de servicio y permisos implementada. Tests unitarios añadidos.
  - [x] Módulo `Comments`: Lógica de servicio y permisos implementada. Tests unitarios añadidos.
  - [x] Módulo `Anteprojects`: CRUD básico implementado con permisos. Tests unitarios añadidos.
  - [x] Módulo `Anteprojects`: Implementado el ciclo de vida completo (submit, review, approve, reject, schedule defense, complete). Tests unitarios añadidos.
  - [x] Desarrollar los endpoints para gestionar las relaciones (ej: añadir un estudiante a un proyecto, asignar una tarea).
  - [x] Implementar el sistema de evaluación para los Anteproyectos.
- **Configuración**:
  - [ ] Configurar CORS de forma granular para el entorno de producción.

## 📝 Pendiente

### Seguridad Avanzada
- [ ] Implementar manejo de errores global y logging de errores.
- [ ] Implementar `rate limiting` para proteger la API.
- [ ] Configurar HTTPS para producción.
- [ ] Configurar CORS de forma granular (se habilitará al comenzar el desarrollo del frontend).

### Documentación
- [ ] Documentación de API con Swagger/OpenAPI.
- [ ] Completar la documentación técnica del proyecto (`TECHNICAL_DOCUMENTATION.md`).

### Mejoras Potenciales y Consideraciones Futuras
- [ ] **Integración con Google Drive**: Investigar y desarrollar la capacidad de vincular archivos directamente desde Google Drive en lugar de (o además de) subirlos localmente. Esto aprovecharía el ecosistema de Google Workspace ya utilizado por alumnos y tutores, facilitando la colaboración y reduciendo los costes de almacenamiento del servidor.

### Optimización y Despliegue
- [ ] Implementar caché (Redis/memcached).
- [ ] Optimizar consultas a base de datos.
- [ ] Configurar un pipeline de CI/CD (ej: GitHub Actions).
- [ ] Preparar el entorno de producción.

## 📋 Próximos Pasos Inmediatos

1.  **Sistema de Notificaciones**: Implementar notificaciones en tiempo real (WebSocket).

## 📅 Estimación de Tiempos
*(La estimación se reajustará tras completar los próximos pasos)*

## 🔄 Actualizaciones

- **Inicio del proyecto**: 2024-07-01
- **Última actualización**: 2024-07-10
- **Estado actual**: CRUDs, ciclos de vida y sistema de evaluación implementados y probados.
- **Próxima revisión**: 2024-07-17 