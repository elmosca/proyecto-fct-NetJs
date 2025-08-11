# Dockerfile para el frontend Flutter
FROM ubuntu:22.04 AS build-env

# Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
  curl \
  git \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa \
  openjdk-11-jdk \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Instalar Flutter
ENV FLUTTER_HOME="/opt/flutter"
ENV FLUTTER_VERSION="3.19.6"
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME
WORKDIR $FLUTTER_HOME
RUN git fetch && git checkout $FLUTTER_VERSION

# Agregar Flutter al PATH
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Pre-descargar Flutter artifacts
RUN flutter precache

# Habilitar web
RUN flutter config --enable-web

# Verificar instalación
RUN flutter doctor

# Copiar el código fuente
WORKDIR /app
COPY . .

# Obtener dependencias
RUN flutter pub get

# Generar código
RUN flutter packages pub run build_runner build --delete-conflicting-outputs

# Construir para web
RUN flutter build web --release

# Etapa de producción con nginx
FROM nginx:alpine

# Copiar los archivos construidos
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copiar configuración de nginx personalizada
COPY nginx.conf /etc/nginx/nginx.conf

# Exponer puerto
EXPOSE 80

# Comando por defecto
CMD ["nginx", "-g", "daemon off;"]
