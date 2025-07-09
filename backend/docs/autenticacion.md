# Documentación de Autenticación

## Descripción General
El sistema de autenticación está implementado utilizando JWT (JSON Web Tokens) y sigue las mejores prácticas de seguridad. La autenticación se maneja a través del módulo `AuthModule` y utiliza Passport.js para la gestión de estrategias de autenticación.

## Componentes Principales

### 1. JwtStrategy (`auth/strategies/jwt.strategy.ts`)
- **Propósito**: Implementa la estrategia de autenticación JWT
- **Funcionalidades**:
  - Extrae el token del header de autorización
  - Verifica la validez del token
  - Valida el usuario y su estado
  - Maneja la expiración del token
  - Verifica que el usuario esté activo

### 2. AuthService (`auth/auth.service.ts`)
- **Propósito**: Gestiona la lógica de autenticación
- **Métodos Principales**:
  ```typescript
  // Validación de credenciales
  async validateUser(email: string, password: string): Promise<any>
  
  // Generación de token y login
  async login(user: User): Promise<{ 
    access_token: string, 
    user: {
      id: string,
      email: string,
      nombre: string,
      rol: UserRole
    } 
  }>
  
  // Validación de token
  async validateToken(token: string): Promise<User>

  // Registro de usuario
  async register(
    email: string, 
    password: string, 
    nombre: string, 
    rol?: UserRole
  ): Promise<{ access_token: string, user: any }>
  ```

### 3. AuthController (`auth/auth.controller.ts`)
- **Endpoints**:
  ```typescript
  // Login de usuario
  POST /auth/login
  Body: { 
    email: string, 
    password: string 
  }
  Response: {
    access_token: string,
    user: {
      id: string,
      email: string,
      nombre: string,
      rol: UserRole
    }
  }
  
  // Registro de usuario
  POST /auth/register
  Body: { 
    email: string, 
    password: string, 
    nombre: string,
    rol?: UserRole 
  }
  Response: {
    access_token: string,
    user: {
      id: string,
      email: string,
      nombre: string,
      rol: UserRole
    }
  }
  ```

## Sistema de Roles y Autorización

### Roles de Usuario
El sistema implementa un sistema jerárquico de roles con las siguientes restricciones:

- `ALUMNO`: Usuario básico del sistema
  - Acceso limitado a sus propios datos
  - No puede crear o modificar otros usuarios
  - No puede asignar roles

- `TUTOR`: Supervisor de proyectos
  - Puede ver listados de alumnos y colaboradores
  - No puede crear otros tutores
  - No puede modificar roles de usuarios
  - Solo puede ser creado por administradores

- `COLABORADOR`: Usuario con permisos limitados
  - Acceso similar al alumno
  - Puede ser creado por tutores o administradores

- `ADMINISTRADOR`: Acceso completo al sistema
  - Puede crear y gestionar todos los tipos de usuarios
  - Puede asignar cualquier rol
  - Puede eliminar cualquier usuario
  - Solo puede ser creado por otros administradores

### Restricciones de Roles
1. **Creación de Usuarios**:
   - Solo administradores pueden crear tutores
   - Solo administradores pueden crear otros administradores
   - Cualquier usuario puede crear alumnos o colaboradores

2. **Modificación de Roles**:
   - Solo administradores pueden asignar el rol de tutor
   - Solo administradores pueden asignar el rol de administrador
   - Los tutores no pueden modificar roles

3. **Eliminación de Usuarios**:
   - Solo administradores pueden eliminar tutores
   - Solo administradores pueden eliminar otros administradores
   - Los tutores pueden eliminar alumnos y colaboradores

### Implementación Técnica

#### Guards
```typescript
// JwtAuthGuard: Verifica la autenticación
@UseGuards(JwtAuthGuard)

// RolesGuard: Verifica los roles
@UseGuards(RolesGuard)
@Roles(UserRole.ADMINISTRADOR)
```

#### Decoradores
```typescript
// Decorador para especificar roles requeridos
@Roles(UserRole.ADMINISTRADOR, UserRole.TUTOR)
```

#### Ejemplo de Uso
```typescript
@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  @Post()
  @Roles(UserRole.ADMINISTRADOR)
  create(@Body() createUserDto: CreateUserDto, @Request() req) {
    return this.usersService.create(createUserDto, req.user);
  }
}
```

### Flujo de Autorización
1. **Verificación de Token**:
   - El `JwtAuthGuard` verifica la validez del token
   - Extrae la información del usuario del token

2. **Verificación de Roles**:
   - El `RolesGuard` verifica los roles requeridos
   - Compara el rol del usuario con los roles permitidos

3. **Ejecución de la Acción**:
   - Si todas las verificaciones pasan, se ejecuta la acción
   - Si no, se lanza una excepción de autorización

## Flujo de Autenticación

1. **Registro de Usuario**:
   ```typescript
   // 1. Cliente envía datos de registro
   POST /auth/register
   Body: {
     email: string,
     password: string,
     nombre: string,
     rol?: UserRole // Solo ALUMNO o COLABORADOR
   }
   
   // 2. Sistema verifica email único
   // 3. Sistema verifica que el rol sea válido para registro
   // 4. Crea usuario con rol especificado o ALUMNO por defecto
   // 5. Retorna token JWT y datos del usuario
   Response: {
     access_token: string,
     user: {
       id: string,
       email: string,
       nombre: string,
       rol: UserRole
     }
   }
   ```

2. **Login**:
   ```typescript
   // 1. Cliente envía credenciales
   POST /auth/login
   Body: {
     email: string,
     password: string
   }
   
   // 2. Sistema valida credenciales
   // 3. Verifica que el usuario esté activo
   // 4. Genera token JWT
   // 5. Retorna token y datos del usuario
   Response: {
     access_token: string,
     user: {
       id: string,
       email: string,
       nombre: string,
       rol: UserRole
     }
   }
   ```

3. **Autenticación de Peticiones**:
   ```typescript
   // 1. Cliente incluye token en header
   Authorization: Bearer <token>
   
   // 2. Sistema valida token
   // 3. Verifica estado del usuario
   // 4. Permite/deniega acceso
   ```

## Configuración

### Variables de Entorno
```env
JWT_SECRET=tu_clave_secreta_muy_segura
```

### Configuración JWT
```typescript
JwtModule.registerAsync({
  imports: [ConfigModule],
  useFactory: async (configService: ConfigService) => ({
    secret: configService.get<string>('JWT_SECRET'),
    signOptions: { 
      expiresIn: '24h',
    },
  }),
  inject: [ConfigService],
})
```

## Seguridad

### Medidas Implementadas
1. **Encriptación de Contraseñas**:
   - Uso de bcrypt para hash de contraseñas
   - Salt automático para cada usuario

2. **Tokens JWT**:
   - Expiración configurable (24 horas)
   - Firma con clave secreta
   - Payload mínimo necesario (id, email, rol)
   - Validación de tokens en cada petición

3. **Validaciones**:
   - Verificación de email único
   - Validación de estado de usuario (activo/inactivo)
   - Comprobación de roles
   - Validación de formato de email
   - Validación de contraseña segura

### Buenas Prácticas
1. **Headers de Seguridad**:
   - Uso de HTTPS
   - Headers CORS configurados
   - Protección contra ataques comunes

2. **Manejo de Errores**:
   - Mensajes de error genéricos
   - Logging de intentos fallidos
   - Bloqueo temporal tras múltiples fallos

## Uso en el Frontend

### Ejemplo de Login
```typescript
const login = async (email: string, password: string) => {
  const response = await fetch('/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ email, password }),
  });
  
  const data = await response.json();
  // Guardar token en localStorage o estado de la aplicación
  localStorage.setItem('token', data.access_token);
  // Guardar datos del usuario si es necesario
  localStorage.setItem('user', JSON.stringify(data.user));
};
```

### Ejemplo de Petición Autenticada
```typescript
const fetchProtectedData = async () => {
  const token = localStorage.getItem('token');
  const response = await fetch('/api/protected-route', {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });
  return response.json();
};
```

### Ejemplo de Logout
```typescript
const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  // Redirigir al login
  window.location.href = '/login';
};
```

## Consideraciones Adicionales

### Renovación de Tokens
- Implementar refresh tokens para sesiones largas
- Renovación automática antes de expiración

### Logout
- Invalidar tokens en el servidor
- Limpiar tokens en el cliente
- Redirección a login

### Recuperación de Contraseña
- Implementar flujo de recuperación
- Envío de emails seguros
- Tokens temporales de recuperación

## Mantenimiento

### Monitoreo
- Logging de intentos de login
- Alertas de seguridad
- Estadísticas de uso

### Actualizaciones
- Revisión periódica de dependencias
- Actualización de claves secretas
- Mejoras de seguridad continuas 