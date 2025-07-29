#!/usr/bin/env node

/**
 * Script de verificación de variables de entorno
 * Backend FCT - Proyecto de Microservicios
 * 
 * Uso: node scripts/verify-env.js
 */

const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// Colores para la consola
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m'
};

// Función para imprimir con colores
function print(color, message) {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

// Función para imprimir título
function printTitle(title) {
  console.log('\n' + '='.repeat(60));
  print('bright', `  ${title}`);
  console.log('='.repeat(60));
}

// Función para imprimir sección
function printSection(title) {
  console.log('\n' + '-'.repeat(40));
  print('cyan', `  ${title}`);
  console.log('-'.repeat(40));
}

// Función para validar formato de email
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// Función para validar URL
function isValidUrl(url) {
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
}

// Función para validar JWT secret
function isValidJwtSecret(secret) {
  return secret && secret.length >= 32 && secret !== 'your-super-secret-key';
}

// Función para validar contraseña de BD
function isValidDbPassword(password) {
  return password && password !== 'postgres' && password.length >= 8;
}

// Función para validar Google credentials
function isValidGoogleCredentials(clientId, clientSecret) {
  return clientId && 
         clientSecret && 
         clientId !== 'your-google-client-id' && 
         clientSecret !== 'your-google-client-secret' &&
         clientId.includes('.apps.googleusercontent.com');
}

// Función para validar Gmail credentials
function isValidGmailCredentials(user, pass) {
  return user && 
         pass && 
         user !== 'your-email@gmail.com' && 
         pass !== 'your-app-password' &&
         isValidEmail(user);
}

// Función principal de verificación
function verifyEnvironment() {
  printTitle('VERIFICACIÓN DE VARIABLES DE ENTORNO - BACKEND FCT');
  
  // Cargar variables de entorno
  const envPath = path.join(__dirname, '..', '.env');
  
  if (!fs.existsSync(envPath)) {
    print('red', '❌ ERROR: Archivo .env no encontrado');
    print('yellow', '💡 Solución: Copia .env.example a .env y configura las variables');
    console.log('\nComando:');
    print('blue', '   cp .env.example .env');
    process.exit(1);
  }
  
  // Cargar variables
  dotenv.config({ path: envPath });
  
  const requiredVars = {
    // Base de datos
    'DB_HOST': { required: true, validator: (val) => val === 'postgres' },
    'DB_PORT': { required: true, validator: (val) => val === '5432' },
    'DB_USERNAME': { required: true, validator: (val) => val === 'postgres' },
    'DB_PASSWORD': { required: true, validator: isValidDbPassword },
    'DB_DATABASE': { required: true, validator: (val) => val && val !== 'nestjs' },
    
    // JWT
    'JWT_SECRET': { required: true, validator: isValidJwtSecret },
    'JWT_EXPIRATION': { required: true, validator: (val) => val && val.includes('h') },
    
    // Google OAuth
    'GOOGLE_CLIENT_ID': { required: true, validator: (val) => isValidGoogleCredentials(val, process.env.GOOGLE_CLIENT_SECRET) },
    'GOOGLE_CLIENT_SECRET': { required: true, validator: (val) => isValidGoogleCredentials(process.env.GOOGLE_CLIENT_ID, val) },
    
    // Email
    'MAIL_HOST': { required: true, validator: (val) => val === 'smtp.gmail.com' },
    'MAIL_PORT': { required: true, validator: (val) => val === '587' },
    'MAIL_USER': { required: true, validator: (val) => isValidGmailCredentials(val, process.env.MAIL_PASS) },
    'MAIL_PASS': { required: true, validator: (val) => isValidGmailCredentials(process.env.MAIL_USER, val) },
    
    // Frontend
    'FRONTEND_URL': { required: true, validator: isValidUrl },
    
    // Entorno
    'NODE_ENV': { required: true, validator: (val) => ['development', 'production', 'test'].includes(val) },
    'PORT': { required: true, validator: (val) => val === '3000' }
  };
  
  let allValid = true;
  const results = {
    valid: [],
    invalid: [],
    missing: [],
    warnings: []
  };
  
  // Verificar cada variable
  for (const [varName, config] of Object.entries(requiredVars)) {
    const value = process.env[varName];
    
    if (!value) {
      results.missing.push(varName);
      allValid = false;
    } else if (!config.validator(value)) {
      results.invalid.push({ name: varName, value, issue: getValidationIssue(varName, value) });
      allValid = false;
    } else {
      results.valid.push(varName);
    }
  }
  
  // Mostrar resultados
  printSection('VARIABLES VÁLIDAS');
  if (results.valid.length > 0) {
    results.valid.forEach(varName => {
      print('green', `✅ ${varName}`);
    });
  } else {
    print('yellow', '⚠️  No hay variables válidas');
  }
  
  printSection('VARIABLES FALTANTES');
  if (results.missing.length > 0) {
    results.missing.forEach(varName => {
      print('red', `❌ ${varName} - NO DEFINIDA`);
    });
  } else {
    print('green', '✅ Todas las variables están definidas');
  }
  
  printSection('VARIABLES CON PROBLEMAS');
  if (results.invalid.length > 0) {
    results.invalid.forEach(({ name, value, issue }) => {
      print('red', `❌ ${name}`);
      print('yellow', `   Valor actual: ${value}`);
      print('yellow', `   Problema: ${issue}`);
    });
  } else {
    print('green', '✅ Todas las variables tienen valores válidos');
  }
  
  // Mostrar advertencias
  if (results.warnings.length > 0) {
    printSection('ADVERTENCIAS');
    results.warnings.forEach(warning => {
      print('yellow', `⚠️  ${warning}`);
    });
  }
  
  // Resumen final
  printSection('RESUMEN');
  if (allValid) {
    print('green', '🎉 ¡Todas las variables de entorno están correctamente configuradas!');
    print('green', '✅ El backend está listo para ser desplegado');
  } else {
    print('red', '❌ Hay problemas en la configuración de variables de entorno');
    print('yellow', '💡 Revisa los errores anteriores y corrige la configuración');
    process.exit(1);
  }
  
  // Mostrar información adicional
  printSection('INFORMACIÓN ADICIONAL');
  print('blue', '📖 Documentación completa: docs/ENVIRONMENT_SETUP.md');
  print('blue', '🐳 Para desplegar: docker-compose up --build');
  print('blue', '🔍 Para ver logs: docker-compose logs -f api');
}

// Función para obtener el problema de validación
function getValidationIssue(varName, value) {
  switch (varName) {
    case 'DB_PASSWORD':
      return value === 'postgres' ? 'Usar contraseña personalizada, no la por defecto' : 'Contraseña muy débil';
    case 'JWT_SECRET':
      return value === 'your-super-secret-key' ? 'Usar clave secreta personalizada' : 'Clave secreta muy corta (mínimo 32 caracteres)';
    case 'GOOGLE_CLIENT_ID':
      return value === 'your-google-client-id' ? 'Configurar Client ID real de Google' : 'Formato de Client ID inválido';
    case 'GOOGLE_CLIENT_SECRET':
      return value === 'your-google-client-secret' ? 'Configurar Client Secret real de Google' : 'Formato de Client Secret inválido';
    case 'MAIL_USER':
      return value === 'your-email@gmail.com' ? 'Configurar email real' : 'Formato de email inválido';
    case 'MAIL_PASS':
      return value === 'your-app-password' ? 'Configurar App Password de Gmail' : 'App Password inválida';
    case 'FRONTEND_URL':
      return 'URL del frontend inválida';
    default:
      return 'Valor inválido';
  }
}

// Ejecutar verificación
if (require.main === module) {
  try {
    verifyEnvironment();
  } catch (error) {
    print('red', `❌ Error durante la verificación: ${error.message}`);
    process.exit(1);
  }
}

module.exports = { verifyEnvironment }; 