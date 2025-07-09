# Documentación Técnica - Sistema de Gestión de Proyectos

## 1. Arquitectura del Sistema

### 1.1 Tecnologías Principales
- **Backend**: NestJS (Node.js)
- **Frontend**: Flutter (Dart)
- **Base de Datos**: PostgreSQL
- **ORM**: TypeORM
- **Autenticación**: JWT (JSON Web Tokens)

### 1.2 Estructura del Repositorio
```
proyecto-fct/
├── .github/                    # Configuración de GitHub Actions
│   └── workflows/             # Flujos de trabajo de CI/CD
├── backend/                   # Backend en NestJS
│   ├── src/
│   │   ├── auth/             # Módulo de autenticación
│   │   ├── users/            # Módulo de usuarios
│   │   ├── projects/         # Módulo de proyectos
│   │   ├── tasks/            # Módulo de tareas
│   │   ├── comments/         # Módulo de comentarios
│   │   └── app.module.ts     # Módulo principal
│   ├── test/                 # Pruebas unitarias y e2e
│   ├── docs/                 # Documentación técnica
│   ├── docker-compose.yml    # Configuración de Docker
│   └── Dockerfile           # Configuración de Docker para el backend
├── frontend/                 # Frontend en Flutter
│   ├── lib/
│   │   ├── core/            # Funcionalidades core
│   │   ├── features/        # Características de la aplicación
│   │   ├── shared/          # Componentes compartidos
│   │   └── main.dart        # Punto de entrada
│   ├── test/                # Pruebas unitarias y de widget
│   └── pubspec.yaml         # Dependencias de Flutter
├── .gitignore               # Archivos ignorados por Git
├── README.md               # Documentación principal
└── LICENSE                 # Licencia del proyecto
```

### 1.3 Configuración de Git
```gitignore
# Dependencias
node_modules/
.pub-cache/
.pub/

# Archivos de compilación
dist/
build/
*.dart.js

# Archivos de entorno
.env
.env.*
!.env.example

# Archivos de IDE
.idea/
.vscode/
*.swp
*.swo

# Logs
*.log
npm-debug.log*

# Archivos del sistema
.DS_Store
Thumbs.db

# Archivos de Docker
.docker/
```

### 1.4 Flujo de Trabajo con Git
1. **Ramas Principales**:
   - `main`: Código en producción
   - `develop`: Rama de desarrollo principal
   - `feature/*`: Nuevas características
   - `bugfix/*`: Correcciones de errores
   - `release/*`: Preparación de releases

2. **Convenciones de Commits**:
   ```
   tipo(alcance): descripción

   [cuerpo opcional]

   [pie opcional]
   ```
   Tipos:
   - `feat`: Nueva característica
   - `fix`: Corrección de error
   - `docs`: Documentación
   - `style`: Formato
   - `refactor`: Refactorización
   - `test`: Pruebas
   - `chore`: Tareas de mantenimiento

3. **Proceso de Desarrollo**:
   ```bash
   # Crear nueva rama de feature
   git checkout -b feature/nueva-caracteristica

   # Desarrollar cambios
   git add .
   git commit -m "feat(api): implementa autenticación JWT"

   # Actualizar con develop
   git checkout develop
   git pull origin develop
   git checkout feature/nueva-caracteristica
   git rebase develop

   # Crear Pull Request
   git push origin feature/nueva-caracteristica
   ```

## 2. Autenticación y Autorización

### 2.1 Sistema de Autenticación
- Implementación de JWT para autenticación
- Tokens con expiración de 1 hora
- Refresh tokens para renovación automática
- Almacenamiento seguro de contraseñas con bcrypt

### 2.2 Sistema de Roles
El sistema implementa un sistema jerárquico de roles:

1. **ALUMNO**
   - Acceso básico al sistema
   - Gestión de sus propios datos
   - Visualización de proyectos asignados

2. **TUTOR**
   - Supervisión de proyectos
   - Gestión de alumnos y colaboradores
   - No puede crear otros tutores
   - No puede modificar roles

3. **COLABORADOR**
   - Acceso similar al alumno
   - Puede ser creado por tutores o administradores
   - Participación en proyectos asignados

4. **ADMINISTRADOR**
   - Acceso completo al sistema
   - Gestión de todos los usuarios
   - Asignación de roles
   - Creación de tutores y otros administradores

### 2.3 Implementación de Autorización
- Guards personalizados para verificación de roles
- Decoradores para especificar roles requeridos
- Validaciones a nivel de servicio
- Manejo de excepciones de autorización

## 3. Modelos de Datos

### 3.1 Usuario (User)
```typescript
@Entity()
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column()
  nombre: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.ALUMNO
  })
  rol: UserRole;

  @Column({ default: true })
  activo: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

### 3.2 Proyecto (Project)
```typescript
@Entity()
export class Project {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  titulo: string;

  @Column('text')
  descripcion: string;

  @Column({
    type: 'enum',
    enum: ProjectStatus,
    default: ProjectStatus.PENDIENTE
  })
  estado: ProjectStatus;

  @ManyToOne(() => User)
  @JoinColumn()
  alumno: User;

  @ManyToOne(() => User)
  @JoinColumn()
  tutor: User;

  @OneToMany(() => Task, task => task.proyecto)
  tareas: Task[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

### 3.3 Tarea (Task)
```typescript
@Entity()
export class Task {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  titulo: string;

  @Column('text')
  descripcion: string;

  @Column({
    type: 'enum',
    enum: TaskStatus,
    default: TaskStatus.PENDIENTE
  })
  estado: TaskStatus;

  @ManyToOne(() => Project, project => project.tareas)
  @JoinColumn()
  proyecto: Project;

  @ManyToOne(() => User)
  @JoinColumn()
  asignado: User;

  @OneToMany(() => Comment, comment => comment.tarea)
  comentarios: Comment[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

### 3.4 Comentario (Comment)
```typescript
@Entity()
export class Comment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('text')
  contenido: string;

  @ManyToOne(() => Task, task => task.comentarios)
  @JoinColumn()
  tarea: Task;

  @ManyToOne(() => User)
  @JoinColumn()
  autor: User;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

## 4. Endpoints de la API

### 4.1 Autenticación
- `POST /auth/register` - Registro de usuarios
- `POST /auth/login` - Inicio de sesión
- `POST /auth/refresh` - Renovación de token
- `POST /auth/logout` - Cierre de sesión

### 4.2 Usuarios
- `GET /users` - Listar usuarios (Admin)
- `GET /users/:id` - Obtener usuario
- `POST /users` - Crear usuario
- `PATCH /users/:id` - Actualizar usuario
- `DELETE /users/:id` - Eliminar usuario
- `GET /users/role/:rol` - Listar usuarios por rol
- `GET /users/alumnos` - Listar alumnos
- `GET /users/tutores` - Listar tutores
- `GET /users/colaboradores` - Listar colaboradores
- `GET /users/administradores` - Listar administradores

### 4.3 Proyectos
- `GET /projects` - Listar proyectos
- `GET /projects/:id` - Obtener proyecto
- `POST /projects` - Crear proyecto
- `PATCH /projects/:id` - Actualizar proyecto
- `DELETE /projects/:id` - Eliminar proyecto

### 4.4 Tareas
- `GET /tasks` - Listar tareas
- `GET /tasks/:id` - Obtener tarea
- `POST /tasks` - Crear tarea
- `PATCH /tasks/:id` - Actualizar tarea
- `DELETE /tasks/:id` - Eliminar tarea

### 4.5 Comentarios
- `GET /comments` - Listar comentarios
- `GET /comments/:id` - Obtener comentario
- `POST /comments` - Crear comentario
- `PATCH /comments/:id` - Actualizar comentario
- `DELETE /comments/:id` - Eliminar comentario

## 5. Seguridad

### 5.1 Autenticación
- Tokens JWT con expiración
- Refresh tokens para renovación
- Almacenamiento seguro de contraseñas
- Validación de tokens en cada petición

### 5.2 Autorización
- Sistema de roles jerárquico
- Validación de permisos por ruta
- Validación de permisos por operación
- Registro de acciones de usuarios

### 5.3 Protección de Datos
- Encriptación de contraseñas
- Validación de datos de entrada
- Sanitización de datos
- Prevención de inyección SQL

## 6. Pruebas

### 6.1 Pruebas Unitarias
- Pruebas de servicios
- Pruebas de controladores
- Pruebas de guards
- Pruebas de decoradores

### 6.2 Pruebas E2E
- Pruebas de flujos completos
- Pruebas de autenticación
- Pruebas de autorización
- Pruebas de operaciones CRUD

## 7. Despliegue

### 7.1 Requisitos
- Node.js 18+
- PostgreSQL 14+
- Flutter 3.0+

### 7.2 Configuración y Variables de Entorno

#### 7.2.1 Estructura de Archivos de Configuración
```
backend/
├── .env                    # Variables de entorno (no versionado)
├── .env.example           # Ejemplo de variables de entorno
├── docker-compose.yml     # Configuración de Docker
├── src/
│   ├── config/           # Configuración de la aplicación
│   │   ├── database.config.ts
│   │   ├── jwt.config.ts
│   │   └── app.config.ts
│   └── ...
```

#### 7.2.2 Configuración de Docker y docker-compose
```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${PORT:-3000}:${PORT:-3000}"
    depends_on:
      - postgres
    environment:
      DB_HOST: postgres
      DB_PORT: ${DB_PORT:-5432}
      DB_USERNAME: ${DB_USERNAME:-postgres}
      DB_PASSWORD: ${DB_PASSWORD:-postgres}
      DB_DATABASE: ${DB_DATABASE:-nestjs}
      JWT_SECRET: ${JWT_SECRET}
      JWT_EXPIRATION: ${JWT_EXPIRATION:-1h}
      NODE_ENV: ${NODE_ENV:-development}
    env_file:
      - .env
    volumes:
      - .:/usr/src/app
      - /usr/src/app/node_modules

  postgres:
    image: postgres:13
    ports:
      - "${DB_PORT:-5432}:5432"
    environment:
      POSTGRES_USER: ${DB_USERNAME:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
      POSTGRES_DB: ${DB_DATABASE:-nestjs}
    env_file:
      - .env
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Esta configuración utiliza variables de entorno reales definidas en el archivo `.env`:

```env
# .env ejemplo
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=nestjs

JWT_SECRET=your-super-secret-key-change-this-in-production
JWT_EXPIRATION=1h

PORT=3000
NODE_ENV=development
```

- El servicio `api` (backend) se conecta a la base de datos `postgres` usando las variables de entorno.
- El servicio `postgres` expone el puerto y persiste los datos en un volumen Docker.
- Ambos servicios usan el archivo `.env` para cargar la configuración.

#### 7.2.3 Variables de Entorno Requeridas
```env
# Configuración de la Base de Datos (Docker)
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=project_management

# Configuración de JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRATION=1h
JWT_REFRESH_EXPIRATION=7d

# Configuración del Servidor
PORT=3000
NODE_ENV=development
API_PREFIX=api
API_VERSION=v1

# Configuración de CORS
CORS_ORIGIN=http://localhost:3000
CORS_METHODS=GET,HEAD,PUT,PATCH,POST,DELETE
CORS_CREDENTIALS=true

# Configuración de Rate Limiting
RATE_LIMIT_TTL=60
RATE_LIMIT_MAX=100

# Configuración de Logging
LOG_LEVEL=debug
LOG_FORMAT=dev
```

#### 7.2.4 Comandos Docker
```bash
# Iniciar los contenedores
docker-compose up -d

# Detener los contenedores
docker-compose down

# Ver logs
docker-compose logs -f

# Reiniciar un servicio específico
docker-compose restart postgres

# Eliminar volúmenes (¡cuidado, esto eliminará los datos!)
docker-compose down -v
```

#### 7.2.5 Configuración de la Aplicación con Docker
```typescript
// src/config/database.config.ts
import { registerAs } from '@nestjs/config';

export default registerAs('database', () => ({
  host: process.env.DATABASE_HOST || 'localhost',
  port: parseInt(process.env.DATABASE_PORT, 10) || 5432,
  username: process.env.DATABASE_USER || 'postgres',
  password: process.env.DATABASE_PASSWORD || 'postgres',
  database: process.env.DATABASE_NAME || 'project_management',
  // Configuración adicional para TypeORM
  type: 'postgres',
  synchronize: process.env.NODE_ENV !== 'production',
  logging: process.env.NODE_ENV === 'development',
}));
```

#### 7.2.6 Scripts de Configuración
```json
// package.json
{
  "scripts": {
    "start:dev": "cross-env NODE_ENV=development nest start --watch",
    "start:prod": "cross-env NODE_ENV=production node dist/main",
    "start:debug": "cross-env NODE_ENV=development nest start --debug --watch",
    "start:test": "cross-env NODE_ENV=test jest --watch"
  }
}
```

### 7.3 Despliegue con Docker

#### 7.3.1 Requisitos
- Docker Engine 20.10+
- Docker Compose 2.0+
- Node.js 18+ (para desarrollo local)

#### 7.3.2 Pasos de Despliegue
1. **Preparación del Entorno**:
   ```bash
   # Clonar el repositorio
   git clone <repository-url>
   cd backend

   # Copiar el archivo de variables de entorno
   cp .env.example .env
   ```

2. **Iniciar la Base de Datos**:
   ```bash
   # Iniciar PostgreSQL
   docker-compose up -d postgres
   ```

3. **Instalar Dependencias**:
   ```bash
   npm install
   ```

4. **Ejecutar Migraciones**:
   ```bash
   npm run migration:run
   ```

5. **Iniciar la Aplicación**:
   ```bash
   # Desarrollo
   npm run start:dev

   # Producción
   npm run build
   npm run start:prod
   ```

#### 7.3.3 Verificación del Despliegue
```bash
# Verificar que los contenedores están corriendo
docker-compose ps

# Verificar logs de PostgreSQL
docker-compose logs postgres

# Verificar la conexión a la base de datos
psql -h localhost -U postgres -d project_management
```

## 8. Mantenimiento

### 8.1 Logs
- Logs de autenticación
- Logs de autorización
- Logs de operaciones CRUD
- Logs de errores

### 8.2 Monitoreo
- Monitoreo de rendimiento
- Monitoreo de errores
- Monitoreo de uso de recursos
- Alertas automáticas

### 8.3 Backup
- Backup automático de base de datos
- Backup de configuración
- Backup de logs
- Plan de recuperación

## 9. Consideraciones Adicionales

### 9.1 Escalabilidad
- Arquitectura modular
- Caché de consultas frecuentes
- Optimización de consultas
- Balanceo de carga

### 9.2 Mantenibilidad
- Código documentado
- Patrones de diseño
- Convenciones de código
- Revisión de código

### 9.3 Seguridad
- Actualizaciones de seguridad
- Escaneo de vulnerabilidades
- Auditoría de código
- Cumplimiento de estándares