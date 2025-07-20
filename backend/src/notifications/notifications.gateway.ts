import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';
import { WsJwtAuthGuard } from '../auth/guards/ws-jwt-auth.guard';
import {
  NotificationEventEnum,
  NotificationPayload,
} from './notifications.types';

@WebSocketGateway({
  cors: {
    origin: '*', // En un entorno de producción, esto debería ser más restrictivo
  },
})
export class NotificationsGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(NotificationsGateway.name);

  constructor(private readonly wsGuard: WsJwtAuthGuard) {}

  afterInit(server: Server) {
    this.logger.log('WebSocket Gateway Initialized');

    // Usar un "middleware" de socket.io para la autenticación
    server.use(async (socket, next) => {
      try {
        // Ejecutar la lógica del guard manualmente
        await this.wsGuard.canActivate({
          switchToWs: () => ({ getClient: () => socket }),
        } as any);
        next();
      } catch (error) {
        this.logger.error(`Authentication error: ${error.message}`);
        next(error);
      }
    });
  }

  handleConnection(client: Socket, ...args: any[]) {
    // El usuario ya está autenticado por el middleware
    const user = client.data.user;
    this.logger.log(`Client connected: ${client.id}, User ID: ${user?.id}`);

    // Unir al cliente a una "sala" con su propio ID de usuario
    if (user?.id) {
      client.join(user.id.toString());
    }
  }

  handleDisconnect(client: Socket) {
    const user = client.data.user;
    this.logger.log(`Client disconnected: ${client.id}, User ID: ${user?.id}`);
  }

  @SubscribeMessage('messageToServer')
  handleMessage(client: Socket, payload: any): void {
    // Este es un ejemplo, se puede expandir para manejar mensajes específicos
    this.server.emit('messageToClient', payload);
  }

  /**
   * Emite un evento a todos los clientes conectados.
   * @param event - El nombre del evento.
   * @param data - Los datos a enviar.
   */
  sendToAll(event: string, data: any) {
    this.server.emit(event, data);
  }

  /**
   * Emite un evento a una sala de usuario específica.
   * @param userId - El ID del usuario al que se le enviará el evento.
   * @param event - El nombre del evento de tipo `NotificationEventEnum`.
   * @param data - Los datos a enviar, con el tipo `NotificationPayload`.
   */
  sendToUser(
    userId: number,
    event: NotificationEventEnum,
    data: NotificationPayload,
  ) {
    this.logger.log(`Sending event '${event}' to user ${userId}`);
    this.server.to(userId.toString()).emit(event, data);
  }
}
