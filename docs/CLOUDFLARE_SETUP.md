# Configuración de Cloudflare DNS para VPS IONOS

## 🌐 Descripción

Esta guía explica cómo configurar Cloudflare DNS para trabajar con el VPS IONOS donde está desplegado el backend del proyecto FCT.

## 📋 Prerrequisitos

- ✅ Cuenta de Cloudflare activa
- ✅ Dominio configurado en Cloudflare
- ✅ VPS IONOS configurado y funcionando
- ✅ IP pública del VPS

## 🔧 Configuración Paso a Paso

### 1. Acceder a Cloudflare Dashboard

1. Ve a [cloudflare.com](https://cloudflare.com)
2. Inicia sesión en tu cuenta
3. Selecciona tu dominio

### 2. Configurar Registros DNS

#### A. Registro A para API

```
Tipo: A
Nombre: api
Contenido: [IP-DEL-VPS]
Proxy: Activado (nube naranja)
TTL: Auto
```

#### B. Registro A para Frontend (opcional)

```
Tipo: A
Nombre: www
Contenido: [IP-DEL-VPS]
Proxy: Activado (nube naranja)
TTL: Auto
```

#### C. Registro CNAME para subdominio (alternativa)

```
Tipo: CNAME
Nombre: api
Contenido: [tu-dominio.com]
Proxy: Activado (nube naranja)
TTL: Auto
```

### 3. Configurar SSL/TLS

1. Ve a **SSL/TLS** en el menú lateral
2. Configura **SSL/TLS encryption mode**:
   - **Full (strict)** - Recomendado para VPS con certificado válido
   - **Full** - Si tienes certificado autofirmado
   - **Flexible** - Solo si no tienes SSL en el VPS

### 4. Configurar Reglas de Firewall

#### A. Regla para API

```
Nombre: API Access
Expresión: (http.request.uri.path contains "/api/")
Acción: Allow
```

#### B. Regla para Rate Limiting

```
Nombre: API Rate Limit
Expresión: (http.request.uri.path contains "/api/")
Acción: Challenge (Captcha)
Rate: 100 requests per 10 minutes
```

### 5. Configurar Page Rules (Opcional)

#### A. Cache API Responses

```
URL: api.tu-dominio.com/api/*
Configuración:
- Cache Level: Cache Everything
- Edge Cache TTL: 4 hours
- Browser Cache TTL: 4 hours
```

#### B. Bypass Cache for Dynamic Content

```
URL: api.tu-dominio.com/api/auth/*
Configuración:
- Cache Level: Bypass
```

## 🔒 Configuración de Seguridad

### 1. Configurar WAF (Web Application Firewall)

1. Ve a **Security** > **WAF**
2. Activa **Managed Rules**
3. Configura **Rate Limiting Rules**:
   - **API Rate Limiting**: 100 requests per minute
   - **Auth Rate Limiting**: 10 requests per minute

### 2. Configurar Access Control

1. Ve a **Access** > **Applications**
2. Crea una nueva aplicación:
   - **Name**: FCT API
   - **Domain**: api.tu-dominio.com
   - **Session Duration**: 24 hours

### 3. Configurar Bot Management

1. Ve a **Security** > **Bot Management**
2. Activa **Bot Fight Mode**
3. Configura **JavaScript Detections**

## 📊 Monitoreo y Analytics

### 1. Configurar Analytics

1. Ve a **Analytics** > **Traffic**
2. Activa **Web Analytics**
3. Configura alertas para:
   - Alto tráfico anormal
   - Errores 4xx/5xx
   - Tiempo de respuesta lento

### 2. Configurar Logs

1. Ve a **Logs** > **Logpush**
2. Activa logs para:
   - HTTP requests
   - Firewall events
   - Rate limiting events

## 🚀 Configuración Avanzada

### 1. Configurar Workers (Opcional)

```javascript
// worker.js - Rate Limiting Personalizado
addEventListener("fetch", (event) => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  const url = new URL(request.url);

  // Rate limiting personalizado para endpoints críticos
  if (url.pathname.startsWith("/api/auth/")) {
    const clientIP = request.headers.get("CF-Connecting-IP");
    const key = `auth_limit:${clientIP}`;

    // Verificar límites (implementar con KV store)
    // ...
  }

  return fetch(request);
}
```

### 2. Configurar Load Balancing

Si tienes múltiples VPS:

1. Ve a **Traffic** > **Load Balancing**
2. Crea un **Pool** con tus VPS
3. Configura **Health Checks**
4. Configura **Geographic Routing**

## 🔍 Verificación de Configuración

### 1. Verificar DNS

```bash
# Verificar resolución DNS
nslookup api.tu-dominio.com
dig api.tu-dominio.com

# Verificar que apunta a tu VPS
curl -I https://api.tu-dominio.com/health
```

### 2. Verificar SSL

```bash
# Verificar certificado SSL
openssl s_client -connect api.tu-dominio.com:443 -servername api.tu-dominio.com
```

### 3. Verificar Rate Limiting

```bash
# Test de rate limiting
for i in {1..15}; do
  curl -I https://api.tu-dominio.com/api/health
  sleep 1
done
```

## 📝 Configuración en el Frontend

### Flutter Web

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.tu-dominio.com/api',
  );
}
```

### Flutter Móvil

```dart
// Para desarrollo
static const String baseUrl = 'http://192.168.1.100:3000/api';

// Para producción
static const String baseUrl = 'https://api.tu-dominio.com/api';
```

## 🛠️ Troubleshooting

### Problema: DNS no resuelve

**Solución:**

1. Verificar que el registro A está configurado correctamente
2. Esperar propagación DNS (hasta 24 horas)
3. Verificar que la IP del VPS es correcta

### Problema: SSL no funciona

**Solución:**

1. Verificar configuración SSL/TLS en Cloudflare
2. Verificar certificado en el VPS
3. Configurar modo SSL apropiado

### Problema: Rate limiting muy agresivo

**Solución:**

1. Ajustar reglas de rate limiting en Cloudflare
2. Configurar whitelist para IPs confiables
3. Revisar logs de Cloudflare

## 📚 Recursos Adicionales

- [Cloudflare DNS Documentation](https://developers.cloudflare.com/dns/)
- [Cloudflare SSL/TLS](https://developers.cloudflare.com/ssl/)
- [Cloudflare WAF](https://developers.cloudflare.com/waf/)
- [Cloudflare Workers](https://developers.cloudflare.com/workers/)

---

**Nota**: Esta configuración proporciona una capa adicional de seguridad y rendimiento para tu aplicación, especialmente importante para un entorno de centro de enseñanza.
