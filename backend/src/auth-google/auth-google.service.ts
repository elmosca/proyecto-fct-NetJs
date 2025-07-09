import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { RoleEnum } from '../roles/roles.enum';
import { CreateUserDto } from 'src/users/dto/create-user.dto';

@Injectable()
export class AuthGoogleService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  async validateOAuthLogin(profile: any): Promise<{ access_token: string; user: any }> {
    try {
      let user = await this.usersService.findByEmail(profile.email);

      if (!user) {
        // Crear nuevo usuario si no existe
        const createUserDto: CreateUserDto = {
          email: profile.email,
          fullName: profile.nombre, // Asumimos que el perfil de Google tiene 'nombre'
          password: Math.random().toString(36).slice(-8), // Contraseña aleatoria
          role: RoleEnum.STUDENT, // Rol por defecto
        };
        user = await this.usersService.create(createUserDto);
      }

      const payload = {
        sub: user.id,
        email: user.email,
        role: user.role,
      };

      return {
        access_token: this.jwtService.sign(payload),
        user: {
          id: user.id,
          email: user.email,
          fullName: user.fullName,
          role: user.role,
        },
      };
    } catch (err) {
      throw new Error('Error en la autenticación con Google');
    }
  }
} 