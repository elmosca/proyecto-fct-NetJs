import { Notification } from './entities/notification.entity';

/**
 * Enumeración de los eventos de notificación que el servidor puede emitir.
 */
export enum NotificationEventEnum {
  /**
   * Se emite cuando se crea una nueva notificación para el usuario.
   * El payload será de tipo `NotificationPayload`.
   */
  NEW_NOTIFICATION = 'new_notification',

  /**
   * Se emite cuando el estado de una tarea cambia.
   * El payload contendrá el ID de la tarea y su nuevo estado.
   */
  TASK_STATUS_UPDATED = 'task_status_updated',
}

/**
 * Define la estructura del payload para un evento de notificación.
 * Es un subconjunto de la entidad `Notification`.
 */
export type NotificationPayload = Pick<
  Notification,
  'id' | 'title' | 'message' | 'type' | 'actionUrl' | 'createdAt'
>;
