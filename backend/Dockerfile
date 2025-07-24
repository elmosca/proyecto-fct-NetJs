# Multi-stage build para optimizar el tamaño del contenedor
FROM node:20-alpine AS builder

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
FROM node:20-alpine AS production

WORKDIR /usr/src/app

# Crear usuario no root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar solo dependencias de producción y netcat para healthcheck
RUN npm ci --only=production && npm cache clean --force && \
    apk add --no-cache netcat-openbsd

# Copiar la aplicación construida desde el stage anterior
COPY --from=builder /usr/src/app/dist ./dist

# Cambiar ownership de los archivos al usuario no root
RUN chown -R nestjs:nodejs /usr/src/app

# Cambiar al usuario no root
USER nestjs

# Exponer el puerto
EXPOSE 3000

# Healthcheck - Verificar que el puerto esté disponible usando IPv4
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD nc -z 127.0.0.1 3000 || exit 1

# Comando para iniciar la aplicación
CMD ["npm", "run", "start:prod"] 