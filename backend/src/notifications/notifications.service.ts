import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification } from './entities/notification.entity';
import { User } from '../users/entities/user.entity';
import { NotificationsGateway } from './notifications.gateway';
import { NotificationEventEnum } from './notifications.types';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepository: Repository<Notification>,
    private readonly notificationsGateway: NotificationsGateway,
  ) {}

  async createAndEmitNotification(
    user: User,
    type: string,
    title: string,
    message: string,
    actionUrl?: string,
    metadata?: object,
  ): Promise<Notification> {
    // 1. Crear y guardar la notificación en la base de datos
    const notification = this.notificationRepository.create({
      userId: user.id,
      type,
      title,
      message,
      actionUrl,
      metadata,
    });
    const savedNotification =
      await this.notificationRepository.save(notification);
    this.logger.log(`Notification created in DB for user ${user.id}`);

    // 2. Emitir el evento a través del gateway
    this.notificationsGateway.sendToUser(
      user.id,
      NotificationEventEnum.NEW_NOTIFICATION,
      {
        id: savedNotification.id,
        title: savedNotification.title,
        message: savedNotification.message,
        type: savedNotification.type,
        actionUrl: savedNotification.actionUrl,
        createdAt: savedNotification.createdAt,
      },
    );

    return savedNotification;
  }
}
