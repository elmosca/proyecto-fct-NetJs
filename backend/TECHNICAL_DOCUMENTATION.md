# Documentación Técnica del Proyecto

## 📋 Índice

1. [Arquitectura del Sistema](#arquitectura-del-sistema)
2. [Decisiones Técnicas](#decisiones-técnicas)
3. [Configuración del Entorno](#configuración-del-entorno)
4. [Estructura de la Base de Datos](#estructura-de-la-base-de-datos)
5. [API Endpoints](#api-endpoints)
6. [Autenticación y Seguridad](#autenticación-y-seguridad)
7. [Flujo de Datos](#flujo-de-datos)
8. [Consideraciones de Rendimiento](#consideraciones-de-rendimiento)
9. [Procedimientos de Despliegue](#procedimientos-de-despliegue)
10. [Solución de Problemas](#solución-de-problemas)

## 🏗️ Arquitectura del Sistema

### Tecnologías Principales

- **Backend**: NestJS (Node.js)
- **Base de Datos**: PostgreSQL
- **ORM**: TypeORM
- **Autenticación**: JWT + Google OAuth
- **Rate Limiting**: @nestjs/throttler
- **Gestión de Archivos**: Multer + sistema polimórfico
- **Contenedorización**: Docker

### Estructura de Directorios

```
backend/
├── src/
│   ├── auth/           # Módulo de autenticación (JWT + Google OAuth)
│   ├── users/          # Módulo de usuarios y roles
│   ├── projects/       # Módulo de proyectos
│   ├── tasks/          # Módulo de tareas
│   ├── comments/       # Módulo de comentarios
│   ├── anteprojects/   # Módulo de anteproyectos y evaluaciones
│   ├── files/          # Módulo de gestión de archivos
│   ├── notifications/  # Módulo de notificaciones
│   └── common/         # Utilidades comunes (rate limiting, logging)
├── test/              # Tests unitarios y E2E
├── docs/              # Documentación técnica
└── init-scripts/      # Scripts de inicialización de BD
```

## 🔧 Decisiones Técnicas

### 1. Elección de NestJS

- **Razón**: Framework robusto con soporte para TypeScript
- **Beneficios**:
  - Arquitectura modular
  - Inyección de dependencias
  - Soporte para decoradores
  - Documentación extensa

### 2. Base de Datos PostgreSQL

- **Razón**: Base de datos relacional robusta
- **Características**:
  - Soporte para JSON
  - Transacciones ACID
  - Escalabilidad

### 3. TypeORM

- **Razón**: ORM maduro con soporte para TypeScript
- **Ventajas**:
  - Migraciones automáticas
  - Relaciones complejas
  - Query builder

## ⚙️ Configuración del Entorno

### Variables de Entorno

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=project_management

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRATION=1d

# Google OAuth
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret

# Rate Limiting
RATE_LIMIT_TTL=60
RATE_LIMIT_MAX=100

# Server
PORT=3000
NODE_ENV=development
```

### Docker

````yaml
version: '3.8'
services:
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_DB: project_management
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data


### Docker
#### Dockerfile optimizado (multi-stage build)
```dockerfile
# Multi-stage build para optimizar el tamaño del contenedor
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar todas las dependencias (incluyendo dev dependencies para el build)
RUN npm ci

# Copiar el código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Stage de producción
FROM node:18-alpine AS production

WORKDIR /usr/src/app

# Crear usuario no root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production && npm cache clean --force

# Copiar la aplicación construida desde el stage anterior
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/storage ./storage

# Cambiar ownership de los archivos al usuario no root
RUN chown -R nestjs:nodejs /usr/src/app

# Cambiar al usuario no root
USER nestjs

# Exponer el puerto
EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1

# Comando para iniciar la aplicación
CMD ["npm", "run", "start:prod"]
````

#### docker-compose.yml ejemplo

```yaml
version: '3.8'
services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    ports:
      - '3000:3000'
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
      DB_USERNAME: postgres
      DB_PASSWORD: postgres
      DB_DATABASE: project_management
      JWT_SECRET: your-secret-key
      JWT_EXPIRATION: 1d
      NODE_ENV: production
      PORT: 3000
    env_file:
      - .env
    volumes:
      - uploads_data:/usr/src/app/storage/uploads
    restart: unless-stopped
    healthcheck:
      test:
        [
          'CMD',
          'wget',
          '--no-verbose',
          '--tries=1',
          '--spider',
          'http://localhost:3000/api/health',
        ]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    networks:
      - app-network

  postgres:
    image: postgres:13-alpine
    ports:
      - '5432:5432'
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: project_management
      POSTGRES_INITDB_ARGS: '--encoding=UTF8 --lc-collate=C --lc-ctype=C'
    env_file:
      - .env
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    restart: unless-stopped
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U postgres -d project_management']
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - app-network

volumes:
  postgres_data:
    driver: local
  uploads_data:
    driver: local

networks:
  app-network:
    driver: bridge
```

volumes:
postgres_data:

````

## 📊 Estructura de la Base de Datos

### Entidades Principales

#### Usuario (User)
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

  @Column()
  rol: string;

  @Column({ default: true })
  activo: boolean;
}
````

#### Proyecto (Project)

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
    default: ProjectStatus.PLANIFICACION,
  })
  estado: ProjectStatus;
}
```

## 🔐 Autenticación y Seguridad

### Flujo de Autenticación

1. Usuario envía credenciales
2. Servidor valida credenciales
3. Genera JWT token
4. Cliente almacena token
5. Token se envía en headers

### Middleware de Seguridad

- CORS configurado
- Rate limiting
- Validación de datos
- Sanitización de inputs

## 📈 Consideraciones de Rendimiento

### Optimizaciones

1. **Caché**:
   - Redis para datos frecuentes
   - Caché de consultas

2. **Consultas**:
   - Índices en campos frecuentes
   - Paginación en listados
   - Eager loading controlado

3. **API**:
   - Compresión de respuestas
   - Lazy loading de relaciones
   - Validación de datos

## 🚀 Procedimientos de Despliegue

### Desarrollo Local

```bash
# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env

# Iniciar base de datos
docker-compose up -d

# Ejecutar migraciones
npm run migration:run

# Iniciar servidor
npm run start:dev
```

### Desarrollo Local y Producción con Docker

```bash
# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env

# Construir y levantar el stack completo
docker compose build --no-cache
docker compose up -d

# Ejecutar migraciones (opcional)
docker compose exec api npm run migration:run
```

#### Notas de seguridad y buenas prácticas

- El contenedor corre como usuario no root (`nestjs`).
- Healthcheck verifica el endpoint `/api/health` para asegurar disponibilidad.
- Solo se copian los artefactos necesarios (`dist`, `storage`).

### Producción

```bash
# Construir aplicación
npm run build

# Ejecutar en producción
npm run start:prod
```

## 🔍 Solución de Problemas

### Problemas Comunes

1. **Error de Conexión a Base de Datos**
   - Verificar variables de entorno
   - Comprobar estado de Docker
   - Revisar logs de PostgreSQL

2. **Errores de Autenticación**
   - Validar formato de token
   - Comprobar expiración
   - Verificar secret key

3. **Problemas de Rendimiento**
   - Revisar índices
   - Analizar consultas lentas
   - Monitorear uso de recursos

## 📝 Registro de Cambios

### [Fecha] - Versión 1.0.0

- Implementación inicial
- Estructura base del proyecto
- Entidades principales
- Autenticación básica

### [Fecha] - Próxima Versión

- Sistema de Kanban
- Características tipo Notion
- Notificaciones en tiempo real
