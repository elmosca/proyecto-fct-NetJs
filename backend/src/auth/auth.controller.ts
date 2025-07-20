import {
  Controller,
  Post,
  Body,
  UnauthorizedException,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { UsersService } from '../users/users.service';
import { CreateUserDto } from 'src/users/dto/create-user.dto';
import { AuthThrottle } from '../common/decorators/throttle.decorator';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @AuthThrottle()
  async login(@Body() loginDto: { email: string; password: string }) {
    const user = await this.authService.validateUser(
      loginDto.email,
      loginDto.password,
    );
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }
    return this.authService.login(user);
  }

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @AuthThrottle()
  async register(@Body() createUserDto: CreateUserDto) {
    const existingUser = await this.usersService.findByEmail(
      createUserDto.email,
    );
    if (existingUser) {
      throw new UnauthorizedException('Email is already registered');
    }

    const registeredUser = await this.authService.register(createUserDto);

    // Iniciar sesión automáticamente después del registro
    const user = await this.authService.validateUser(
      createUserDto.email,
      createUserDto.password,
    );

    if (!user) {
      // Esto no debería ocurrir si el registro fue exitoso
      throw new UnauthorizedException('Error logging in after registration');
    }

    return this.authService.login(user);
  }
}
