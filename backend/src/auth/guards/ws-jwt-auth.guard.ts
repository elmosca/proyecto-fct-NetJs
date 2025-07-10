import {
  CanActivate,
  ExecutionContext,
  Injectable,
  Logger,
} from '@nestjs/common';
import { WsException } from '@nestjs/websockets';
import { Socket } from 'socket.io';
import { AuthService } from '../auth.service';

@Injectable()
export class WsJwtAuthGuard implements CanActivate {
  private readonly logger = new Logger(WsJwtAuthGuard.name);

  constructor(private readonly authService: AuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    try {
      const client: Socket = context.switchToWs().getClient<Socket>();
      const authToken = client.handshake.headers.authorization?.split(' ')[1];

      if (!authToken) {
        throw new WsException('Unauthorized: No token provided');
      }

      const user = await this.authService.validateToken(authToken);
      if (!user) {
        throw new WsException('Unauthorized: Invalid token');
      }

      // Adjuntar el usuario al objeto del socket para uso posterior
      client.data.user = user;
      return true;
    } catch (error) {
      this.logger.error('WebSocket Authentication Error:', error.message);
      // Lanzar una excepción específica de WebSocket
      throw new WsException(error.message || 'Unauthorized');
    }
  }
}
