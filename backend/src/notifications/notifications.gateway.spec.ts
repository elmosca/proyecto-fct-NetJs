import { Test, TestingModule } from '@nestjs/testing';
import { NotificationsGateway } from './notifications.gateway';
import { WsJwtAuthGuard } from '../auth/guards/ws-jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import { UserStatus } from '../users/entities/user.entity';
import {
  NotificationEventEnum,
  NotificationPayload,
} from './notifications.types';

describe('NotificationsGateway', () => {
  let gateway: NotificationsGateway;
  let guard: WsJwtAuthGuard;

  // Mock del cliente Socket
  const mockSocket = {
    handshake: {
      headers: {
        authorization: 'Bearer valid-token',
      },
    },
    data: {
      user: null as User | null,
    },
    join: jest.fn(),
    disconnect: jest.fn(),
  };

  // Mock del servidor Socket.IO
  const mockServer = {
    use: jest.fn(),
    to: jest.fn().mockReturnValue({
      emit: jest.fn(),
    }),
    emit: jest.fn(),
  };

  const mockUser: User = {
    id: 1,
    email: 'test@example.com',
    fullName: 'Test User',
    role: RoleEnum.STUDENT,
    status: UserStatus.ACTIVE,
    passwordHash: '',
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NotificationsGateway,
        {
          provide: WsJwtAuthGuard,
          useValue: {
            canActivate: jest.fn(),
          },
        },
      ],
    }).compile();

    gateway = module.get<NotificationsGateway>(NotificationsGateway);
    guard = module.get<WsJwtAuthGuard>(WsJwtAuthGuard);

    // Asignar el servidor mock al gateway
    (gateway as any).server = mockServer;
  });

  it('should be defined', () => {
    expect(gateway).toBeDefined();
  });

  describe('handleConnection', () => {
    beforeEach(() => {
      // Inicializar el gateway para configurar el middleware
      gateway.afterInit(mockServer as any);
    });

    it('should authenticate user and join them to a room', async () => {
      jest.spyOn(guard, 'canActivate').mockResolvedValue(true);
      mockSocket.data.user = mockUser; // Simulamos que el guard adjunta el usuario

      // Llamamos a handleConnection directamente
      gateway.handleConnection(mockSocket as any);

      expect(mockSocket.join).toHaveBeenCalledWith(mockUser.id.toString());
    });

    it('should handle authentication middleware correctly', async () => {
      // Limpiar mocks previos
      jest.clearAllMocks();

      // Re-inicializar el gateway para obtener un middleware fresco
      gateway.afterInit(mockServer as any);

      jest.spyOn(guard, 'canActivate').mockResolvedValue(true);

      const nextFunction = jest.fn();
      const middleware = mockServer.use.mock.calls[0][0] as (
        socket: any,
        next: any,
      ) => void;

      await middleware(mockSocket, nextFunction);

      expect(guard.canActivate).toHaveBeenCalled();
      expect(nextFunction).toHaveBeenCalledWith();
    });

    it('should reject connection if authentication fails', async () => {
      // Limpiar mocks previos
      jest.clearAllMocks();

      // Re-inicializar el gateway para obtener un middleware fresco
      gateway.afterInit(mockServer as any);

      const error = new Error('Unauthorized');
      jest.spyOn(guard, 'canActivate').mockRejectedValue(error);

      const nextFunction = jest.fn();
      const middleware = mockServer.use.mock.calls[0][0] as (
        socket: any,
        next: any,
      ) => void;

      await middleware(mockSocket, nextFunction);

      expect(guard.canActivate).toHaveBeenCalled();
      expect(nextFunction).toHaveBeenCalledWith(error);
    });
  });

  describe('sendToUser', () => {
    it('should emit an event to a specific user room', () => {
      const payload: NotificationPayload = {
        id: 1,
        title: 'Test',
        message: 'Test message',
        type: 'task_assigned',
        actionUrl: '/tasks/1',
        createdAt: new Date(),
      };

      gateway.sendToUser(
        mockUser.id,
        NotificationEventEnum.NEW_NOTIFICATION,
        payload,
      );

      const emitMock = mockServer.to(mockUser.id.toString()).emit;
      expect(mockServer.to).toHaveBeenCalledWith(mockUser.id.toString());
      expect(emitMock).toHaveBeenCalledWith(
        NotificationEventEnum.NEW_NOTIFICATION,
        payload,
      );
    });
  });
});
