# Backend - Proyecto FCT

<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Logo de Nest" /></a>
</p>

## Descripción

Backend API REST para la gestión de proyectos, usuarios y tareas, pensado para integrarse con una app Flutter. Basado en NestJS, PostgreSQL y TypeORM, con autenticación JWT y Google OAuth, sistema de roles, rate limiting, gestión de archivos y sistema de evaluaciones completo.

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

## Sistema de Rate Limiting

- Protección contra abusos y ataques DoS.
- Límites específicos por tipo de endpoint (autenticación, uploads, operaciones sensibles).
- Headers informativos y logging automático.
- Documentación completa en `docs/rate-limiting.md`.

## Sistema de Evaluaciones

- Gestión completa del ciclo de vida de anteproyectos.
- Sistema de criterios de evaluación personalizables.
- Workflow de aprobación/rechazo con estados controlados.
- Gestión de archivos adjuntos polimórfica.

## Integración con Flutter

- API pensada para ser consumida por apps móviles/web.
- CORS configurado para desarrollo local.
- Uso de JWT para autenticación en el frontend.

## 🚀 Configuración y Ejecución

### 📋 Requisitos Previos

- **Node.js**: Versión 20.11.0 o superior (recomendado: 20.19.4)
- **npm**: Versión 10.8.2 o superior
- **PostgreSQL**: Versión 13 o superior
- **Docker & Docker Compose**: Para despliegue con contenedores

#### Instalación de Node.js (si no lo tienes):

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs -y
node --version  # Debe mostrar v20.x.x
```

## 🎯 Opciones de Despliegue

### **1. 🏠 Desarrollo Local (Básico)**

```bash
cd backend
npm install
npm run start:dev
```

- **Uso**: Desarrollo y pruebas locales
- **Acceso**: Solo desde tu máquina
- **Coste**: Cero
- **Complejidad**: Mínima

### **2. 🎓 Centro Educativo (Recomendado para presentación)**

```bash
# Desde el directorio raíz del proyecto
./deploy-centro-educativo.sh
```

- **Uso**: Presentación, centro educativo, red local
- **Acceso**: Cualquier dispositivo en la red local
- **Coste**: Cero
- **Complejidad**: Baja
- **URL**: `http://[IP-SERVIDOR]/api`

### **3. 🌐 Cloudflare Tunnels (Exposición pública temporal)**

```bash
# Desde el directorio raíz del proyecto
./deploy-local-cloudflare.sh
```

- **Uso**: Demostración pública, acceso desde internet
- **Acceso**: Cualquier dispositivo con internet
- **Coste**: Cero (con tu dominio)
- **Complejidad**: Media
- **URL**: `https://[subdominio].trycloudflare.com`

### **4. 🖥️ VPS IONOS (Producción profesional)**

```bash
# Desde el directorio raíz del proyecto
./deploy-vps.sh
```

- **Uso**: Producción, centro educativo con recursos
- **Acceso**: Público con dominio propio
- **Coste**: 1€/mes (VPS)
- **Complejidad**: Media-Alta
- **URL**: `https://tu-dominio.com/api`

### **Matriz de Decisión**

| Escenario                 | Opción Recomendada | Comando                        | Ventajas                |
| ------------------------- | ------------------ | ------------------------------ | ----------------------- |
| **Desarrollo**            | Local básico       | `npm run start:dev`            | Rápido, simple          |
| **Presentación TFG**      | Centro educativo   | `./deploy-centro-educativo.sh` | Profesional, sin costes |
| **Demo pública**          | Cloudflare Tunnels | `./deploy-local-cloudflare.sh` | Acceso global, temporal |
| **Centro educativo real** | VPS IONOS          | `./deploy-vps.sh`              | Producción, estable     |

### ⚡ Configuración Rápida (Recomendado)

```bash
cd backend
./scripts/setup-env.sh          # Configuración guiada de variables
node scripts/verify-env.js      # Verificar configuración
```

### 🔧 Configuración Manual

```bash
cd backend
cp .env.example .env            # Crear archivo de variables
nano .env                       # Editar variables críticas
```

📖 **Documentación de configuración:**

- [Configuración Rápida](README_ENV.md) - Guía paso a paso
- [Documentación Completa](docs/ENVIRONMENT_SETUP.md) - Variables detalladas
- [Changelog](CHANGELOG.md) - Historial de cambios

### 🏃‍♂️ Ejecución del Proyecto

#### Desarrollo

```bash
cd backend
npm install                     # Instalar dependencias
npm run start:dev              # Ejecutar en modo desarrollo
```

#### Producción (Docker)

```bash
cd backend
docker-compose up --build
```

## 📚 Documentación

- **Configuración:** [README_ENV.md](README_ENV.md) - Configuración rápida de variables
- **Variables de Entorno:** [docs/ENVIRONMENT_SETUP.md](docs/ENVIRONMENT_SETUP.md) - Documentación completa
- **Técnica:** [docs/TECHNICAL_DOCUMENTATION.md](docs/TECHNICAL_DOCUMENTATION.md) - Detalles técnicos
  - Listado de endpoints
  - Detalles de integración y arquitectura
  - Ejemplos de uso avanzados
- **Rate Limiting:** [docs/rate-limiting.md](docs/rate-limiting.md) - Sistema de protección contra abusos
- **Google OAuth:** [docs/GOOGLE_OAUTH_SETUP.md](docs/GOOGLE_OAUTH_SETUP.md) - Configuración de autenticación Google
- **Estado del Proyecto:** [PROJECT_STATUS.md](PROJECT_STATUS.md) - Estado actual y próximos pasos
