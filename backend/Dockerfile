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