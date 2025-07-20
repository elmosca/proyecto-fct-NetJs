/**
 * Script de prueba para verificar el funcionamiento del rate limiting
 * Ejecutar con: node test-rate-limiting.js
 */

const fetch = require('node-fetch');

const BASE_URL = 'http://localhost:3000';

// Colores para la consola
const colors = {
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m',
  bold: '\x1b[1m'
};

const log = {
  success: (msg) => console.log(`${colors.green}✅ ${msg}${colors.reset}`),
  error: (msg) => console.log(`${colors.red}❌ ${msg}${colors.reset}`),
  warning: (msg) => console.log(`${colors.yellow}⚠️  ${msg}${colors.reset}`),
  info: (msg) => console.log(`${colors.blue}ℹ️  ${msg}${colors.reset}`),
  title: (msg) => console.log(`${colors.bold}${colors.blue}\n🧪 ${msg}${colors.reset}`)
};

// Función para hacer requests con manejo de errores
async function makeRequest(endpoint, options = {}) {
  try {
    const response = await fetch(`${BASE_URL}${endpoint}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    });

    const data = await response.text();
    
    return {
      status: response.status,
      headers: response.headers,
      body: data,
      success: response.ok
    };
  } catch (error) {
    return {
      status: 500,
      error: error.message,
      success: false
    };
  }
}

// Función para esperar un tiempo determinado
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Test 1: Verificar que el servidor está funcionando
async function testServerRunning() {
  log.title('Test 1: Verificar que el servidor está funcionando');
  
  const response = await makeRequest('/');
  
  if (response.success) {
    log.success('Servidor está funcionando correctamente');
    return true;
  } else {
    log.error(`Servidor no responde. Status: ${response.status}`);
    return false;
  }
}

// Test 2: Verificar headers de rate limiting
async function testRateLimitHeaders() {
  log.title('Test 2: Verificar headers de rate limiting');
  
  const response = await makeRequest('/');
  
  const hasRateLimitPolicy = response.headers.get('x-ratelimit-policy');
  const hasRateLimitApplied = response.headers.get('x-ratelimit-applied');
  
  if (hasRateLimitPolicy) {
    log.success(`Header X-RateLimit-Policy: ${hasRateLimitPolicy}`);
  } else {
    log.warning('Header X-RateLimit-Policy no encontrado');
  }
  
  if (hasRateLimitApplied) {
    log.success(`Header X-RateLimit-Applied: ${hasRateLimitApplied}`);
  } else {
    log.warning('Header X-RateLimit-Applied no encontrado');
  }
  
  return hasRateLimitPolicy || hasRateLimitApplied;
}

// Test 3: Probar límites de autenticación (muy restrictivos)
async function testAuthRateLimit() {
  log.title('Test 3: Probar límites de autenticación (5 requests/min)');
  
  const endpoint = '/auth/login';
  const loginData = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: 'test@example.com',
      password: 'wrongpassword'
    })
  };
  
  log.info('Haciendo 6 requests de login para triggear rate limit...');
  
  let blockedCount = 0;
  
  for (let i = 1; i <= 6; i++) {
    const response = await makeRequest(endpoint, loginData);
    
    if (response.status === 429) {
      log.warning(`Request ${i}: BLOQUEADA (429 Too Many Requests)`);
      blockedCount++;
      
      const retryAfter = response.headers.get('retry-after');
      if (retryAfter) {
        log.info(`Retry-After header: ${retryAfter} segundos`);
      }
    } else {
      log.info(`Request ${i}: ${response.status} (${response.success ? 'OK' : 'ERROR'})`);
    }
    
    // Pequeña pausa entre requests
    await sleep(200);
  }
  
  if (blockedCount > 0) {
    log.success(`Rate limiting funcionando: ${blockedCount} requests bloqueadas`);
    return true;
  } else {
    log.error('Rate limiting NO está funcionando en /auth/login');
    return false;
  }
}

// Test 4: Probar límites de API general
async function testApiRateLimit() {
  log.title('Test 4: Probar límites de API general');
  
  const endpoint = '/';
  
  log.info('Haciendo múltiples requests para probar límite general...');
  
  let requestCount = 0;
  let blockedCount = 0;
  
  // Hacer muchas requests rápidas para triggear el límite
  for (let i = 1; i <= 20; i++) {
    const response = await makeRequest(endpoint);
    requestCount++;
    
    if (response.status === 429) {
      log.warning(`Request ${i}: BLOQUEADA (429)`);
      blockedCount++;
      break; // Salir al primer bloqueo
    } else {
      log.info(`Request ${i}: ${response.status}`);
    }
    
    // Sin pausa para triggear más rápido el límite
  }
  
  log.info(`Total requests: ${requestCount}, Bloqueadas: ${blockedCount}`);
  
  if (blockedCount > 0) {
    log.success('Rate limiting general funcionando');
    return true;
  } else {
    log.warning('Rate limiting general muy permisivo o no funcionando');
    return false;
  }
}

// Test 5: Verificar recovery tras rate limit
async function testRateLimitRecovery() {
  log.title('Test 5: Verificar recovery tras rate limit');
  
  log.info('Esperando 10 segundos para que expire el rate limit...');
  await sleep(10000);
  
  const response = await makeRequest('/');
  
  if (response.success) {
    log.success('Recovery exitoso: requests funcionan de nuevo tras espera');
    return true;
  } else {
    log.error('Recovery falló: requests siguen bloqueadas');
    return false;
  }
}

// Test 6: Verificar endpoints específicos con throttling
async function testSpecificEndpoints() {
  log.title('Test 6: Verificar endpoints específicos');
  
  const endpoints = [
    { path: '/auth/register', name: 'Register (AuthThrottle)' },
    { path: '/users', name: 'Users (Sin throttle específico)' },
  ];
  
  for (const endpoint of endpoints) {
    log.info(`Probando ${endpoint.name}: ${endpoint.path}`);
    
    const response = await makeRequest(endpoint.path, {
      method: 'POST',
      body: JSON.stringify({ test: 'data' })
    });
    
    const hasRateLimitHeaders = response.headers.get('x-ratelimit-policy');
    
    if (hasRateLimitHeaders) {
      log.success(`${endpoint.name}: Headers de rate limiting presentes`);
    } else {
      log.warning(`${endpoint.name}: Sin headers de rate limiting`);
    }
    
    log.info(`Status: ${response.status}`);
    await sleep(500);
  }
}

// Función principal
async function runTests() {
  console.log(`${colors.bold}${colors.blue}🚦 TEST DE RATE LIMITING${colors.reset}`);
  console.log('================================================\n');
  
  const results = [];
  
  try {
    // Ejecutar todos los tests
    results.push(await testServerRunning());
    results.push(await testRateLimitHeaders());
    results.push(await testAuthRateLimit());
    results.push(await testApiRateLimit());
    results.push(await testRateLimitRecovery());
    await testSpecificEndpoints();
    
    // Resumen final
    const passed = results.filter(Boolean).length;
    const total = results.length;
    
    console.log('\n================================================');
    log.title('RESUMEN DE TESTS');
    
    if (passed === total) {
      log.success(`Todos los tests pasaron: ${passed}/${total}`);
      log.success('✨ Rate limiting funcionando correctamente');
    } else {
      log.warning(`Tests pasados: ${passed}/${total}`);
      log.warning('Algunos tests fallaron, revisar configuración');
    }
    
  } catch (error) {
    log.error(`Error durante los tests: ${error.message}`);
  }
}

// Verificar si node-fetch está disponible
try {
  require('node-fetch');
  runTests();
} catch (error) {
  console.log(`${colors.red}❌ Error: node-fetch no está instalado${colors.reset}`);
  console.log(`${colors.yellow}💡 Instalar con: npm install node-fetch${colors.reset}`);
  console.log(`${colors.blue}ℹ️  O usar curl manualmente para probar los endpoints${colors.reset}`);
} 