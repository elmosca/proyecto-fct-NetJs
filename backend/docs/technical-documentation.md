# Documentación Técnica del Backend

## Índice
1. [Arquitectura General](#arquitectura-general)
2. [Base de Datos](#base-de-datos)
3. [Autenticación y Autorización](#autenticación-y-autorización)
4. [API Endpoints](#api-endpoints)
5. [Configuración](#configuración)

## Arquitectura General
El backend está construido utilizando NestJS, un framework progresivo de Node.js que proporciona una arquitectura escalable y modular.

### Estructura de Directorios
```
backend/
├── src/
│   ├── auth/           # Módulo de autenticación
│   ├── users/          # Gestión de usuarios
│   ├── projects/       # Gestión de proyectos
│   ├── tasks/          # Gestión de tareas
│   ├── comments/       # Sistema de comentarios
│   └── app.module.ts   # Módulo principal
├── test/              # Pruebas
└── docs/              # Documentación
```

## Base de Datos
Utilizamos PostgreSQL como base de datos principal, con TypeORM como ORM.

### Entidades Principales
- User
- Project
- Task
- Comment

## Autenticación y Autorización
El sistema implementa autenticación JWT con roles de usuario. Para más detalles, consulta la [documentación específica de autenticación](./autenticacion.md).

### Roles de Usuario
- ALUMNO
- TUTOR
- COLABORADOR
- ADMINISTRADOR

### Flujo de Autenticación
1. Registro de usuario
2. Login con JWT
3. Autorización basada en roles

## API Endpoints

### Autenticación
```
POST /auth/register - Registro de usuario
POST /auth/login    - Login de usuario
```

### Usuarios
```
GET    /users              - Listar usuarios
GET    /users/:id          - Obtener usuario
PATCH  /users/:id          - Actualizar usuario
DELETE /users/:id          - Eliminar usuario
GET    /users/role/:rol    - Listar usuarios por rol
```

### Proyectos
```
GET    /projects           - Listar proyectos
POST   /projects           - Crear proyecto
GET    /projects/:id       - Obtener proyecto
PATCH  /projects/:id       - Actualizar proyecto
DELETE /projects/:id       - Eliminar proyecto
```

### Tareas
```
GET    /tasks             - Listar tareas
POST   /tasks             - Crear tarea
GET    /tasks/:id         - Obtener tarea
PATCH  /tasks/:id         - Actualizar tarea
DELETE /tasks/:id         - Eliminar tarea
```

### Comentarios
```
GET    /comments          - Listar comentarios
POST   /comments          - Crear comentario
DELETE /comments/:id      - Eliminar comentario
```

## Configuración

### Variables de Entorno
```env
# Base de datos
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# JWT
JWT_SECRET=your-secret-key

# Servidor
PORT=3000
NODE_ENV=development
```

### Configuración de TypeORM
```typescript
{
  type: 'postgres',
  url: process.env.DATABASE_URL,
  entities: [User, Project, Task, Comment],
  synchronize: process.env.NODE_ENV !== 'production',
}
```

## Seguridad

### Medidas Implementadas
1. Autenticación JWT
2. Encriptación de contraseñas con bcrypt
3. Validación de datos
4. Protección CORS
5. Rate limiting

### Buenas Prácticas
1. Uso de HTTPS
2. Headers de seguridad
3. Validación de entrada
4. Manejo de errores
5. Logging

## Despliegue

### Requisitos
- Node.js >= 14
- PostgreSQL >= 12
- PM2 (opcional)

### Pasos de Despliegue
1. Instalar dependencias
2. Configurar variables de entorno
3. Ejecutar migraciones
4. Iniciar servidor

## Mantenimiento

### Monitoreo
- Logs de aplicación
- Métricas de rendimiento
- Alertas de seguridad

### Actualizaciones
- Revisión de dependencias
- Actualización de claves
- Mejoras de seguridad 