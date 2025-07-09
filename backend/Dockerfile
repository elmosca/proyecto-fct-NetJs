FROM node:18-alpine

WORKDIR /usr/src/app

# Instalar dependencias de producción primero
COPY package*.json ./
RUN npm ci --only=production

# Copiar el código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Exponer el puerto desde la variable de entorno
EXPOSE ${PORT:-3000}

# Usar un usuario no root
USER node

# Comando para iniciar la aplicación
CMD ["npm", "run", "start:prod"] 