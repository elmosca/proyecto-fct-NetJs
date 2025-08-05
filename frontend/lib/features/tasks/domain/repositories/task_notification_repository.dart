import 'package:fct_frontend/features/tasks/domain/entities/task_notification_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_notification_entity.dart';

abstract class TaskNotificationRepository {
  /// Obtener notificaciones de tareas con filtros opcionales
  Future<List<TaskNotification>> getTaskNotifications(
      TaskNotificationFiltersDto filters);

  /// Obtener una notificación por ID
  Future<TaskNotification?> getTaskNotificationById(String id);

  /// Crear una nueva notificación
  Future<TaskNotification> createTaskNotification(
      CreateTaskNotificationDto dto);

  /// Actualizar una notificación existente
  Future<TaskNotification> updateTaskNotification(
      String id, UpdateTaskNotificationDto dto);

  /// Eliminar una notificación
  Future<void> deleteTaskNotification(String id);

  /// Marcar notificación como leída
  Future<TaskNotification> markAsRead(MarkNotificationAsReadDto dto);

  /// Marcar múltiples notificaciones como leídas
  Future<List<TaskNotification>> bulkMarkAsRead(
      BulkMarkNotificationsAsReadDto dto);

  /// Obtener notificaciones no leídas de un usuario
  Future<List<TaskNotification>> getUnreadNotifications(String userId);

  /// Obtener contador de notificaciones no leídas
  Future<int> getUnreadCount(String userId);

  /// Eliminar todas las notificaciones de un usuario
  Future<void> deleteAllUserNotifications(String userId);

  /// Eliminar notificaciones leídas de un usuario
  Future<void> deleteReadNotifications(String userId);

  /// Obtener notificaciones de una tarea específica
  Future<List<TaskNotification>> getTaskNotificationsByTaskId(String taskId);

  /// Obtener notificaciones de un proyecto específico
  Future<List<TaskNotification>> getTaskNotificationsByProjectId(
      String projectId);

  /// Programar notificación para fecha futura
  Future<TaskNotification> scheduleTaskNotification(
      CreateTaskNotificationDto dto, DateTime scheduledAt);

  /// Cancelar notificación programada
  Future<void> cancelScheduledNotification(String notificationId);
}
