import { Controller, Get, UseGuards, Req, Res } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AuthGoogleService } from './auth-google.service';
import { Response } from 'express';

@Controller('auth/google')
export class AuthGoogleController {
  constructor(private readonly authGoogleService: AuthGoogleService) {}

  @Get()
  @UseGuards(AuthGuard('google'))
  async googleAuth() {
    // Este endpoint inicia el proceso de autenticación con Google
  }

  @Get('callback')
  @UseGuards(AuthGuard('google'))
  async googleAuthCallback(@Req() req, @Res() res: Response) {
    const result = await this.authGoogleService.validateOAuthLogin(req.user);

    // Redirigir al frontend con el token
    res.redirect(
      `${process.env.FRONTEND_URL}/auth/callback?token=${result.access_token}`,
    );
  }
}
