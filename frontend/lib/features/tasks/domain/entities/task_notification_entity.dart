import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_notification_entity.freezed.dart';
part 'task_notification_entity.g.dart';

@freezed
class TaskNotification with _$TaskNotification {
  const factory TaskNotification({
    required String id,
    required String title,
    required String message,
    required TaskNotificationType type,
    required TaskNotificationStatus status,
    required String userId,
    required String taskId,
    String? projectId,
    String? milestoneId,
    Map<String, dynamic>? metadata,
    DateTime? scheduledAt,
    DateTime? readAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TaskNotification;

  factory TaskNotification.fromJson(Map<String, dynamic> json) =>
      _$TaskNotificationFromJson(json);
}

enum TaskNotificationType {
  @JsonValue('task_assigned')
  taskAssigned,
  @JsonValue('task_status_changed')
  taskStatusChanged,
  @JsonValue('task_due_date_reminder')
  taskDueDateReminder,
  @JsonValue('task_overdue')
  taskOverdue,
  @JsonValue('task_completed')
  taskCompleted,
  @JsonValue('task_dependency_completed')
  taskDependencyCompleted,
  @JsonValue('task_comment_added')
  taskCommentAdded,
  @JsonValue('task_priority_changed')
  taskPriorityChanged,
  @JsonValue('task_milestone_reached')
  taskMilestoneReached,
  @JsonValue('task_general')
  taskGeneral,
}

enum TaskNotificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('sent')
  sent,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed,
}

extension TaskNotificationTypeExtension on TaskNotificationType {
  String get displayName {
    switch (this) {
      case TaskNotificationType.taskAssigned:
        return 'Tarea Asignada';
      case TaskNotificationType.taskStatusChanged:
        return 'Estado de Tarea Cambiado';
      case TaskNotificationType.taskDueDateReminder:
        return 'Recordatorio de Fecha de Vencimiento';
      case TaskNotificationType.taskOverdue:
        return 'Tarea Vencida';
      case TaskNotificationType.taskCompleted:
        return 'Tarea Completada';
      case TaskNotificationType.taskDependencyCompleted:
        return 'Dependencia Completada';
      case TaskNotificationType.taskCommentAdded:
        return 'Comentario Agregado';
      case TaskNotificationType.taskPriorityChanged:
        return 'Prioridad Cambiada';
      case TaskNotificationType.taskMilestoneReached:
        return 'Hito Alcanzado';
      case TaskNotificationType.taskGeneral:
        return 'Notificación General';
    }
  }

  String get icon {
    switch (this) {
      case TaskNotificationType.taskAssigned:
        return '👤';
      case TaskNotificationType.taskStatusChanged:
        return '🔄';
      case TaskNotificationType.taskDueDateReminder:
        return '⏰';
      case TaskNotificationType.taskOverdue:
        return '⚠️';
      case TaskNotificationType.taskCompleted:
        return '✅';
      case TaskNotificationType.taskDependencyCompleted:
        return '🔗';
      case TaskNotificationType.taskCommentAdded:
        return '💬';
      case TaskNotificationType.taskPriorityChanged:
        return '🎯';
      case TaskNotificationType.taskMilestoneReached:
        return '🏆';
      case TaskNotificationType.taskGeneral:
        return '📋';
    }
  }

  String get color {
    switch (this) {
      case TaskNotificationType.taskAssigned:
        return '#2196F3'; // Azul
      case TaskNotificationType.taskStatusChanged:
        return '#FF9800'; // Naranja
      case TaskNotificationType.taskDueDateReminder:
        return '#FFC107'; // Amarillo
      case TaskNotificationType.taskOverdue:
        return '#F44336'; // Rojo
      case TaskNotificationType.taskCompleted:
        return '#4CAF50'; // Verde
      case TaskNotificationType.taskDependencyCompleted:
        return '#9C27B0'; // Púrpura
      case TaskNotificationType.taskCommentAdded:
        return '#00BCD4'; // Cyan
      case TaskNotificationType.taskPriorityChanged:
        return '#FF5722'; // Rojo oscuro
      case TaskNotificationType.taskMilestoneReached:
        return '#FFD700'; // Dorado
      case TaskNotificationType.taskGeneral:
        return '#607D8B'; // Gris azulado
    }
  }
}

extension TaskNotificationStatusExtension on TaskNotificationStatus {
  String get displayName {
    switch (this) {
      case TaskNotificationStatus.pending:
        return 'Pendiente';
      case TaskNotificationStatus.sent:
        return 'Enviada';
      case TaskNotificationStatus.read:
        return 'Leída';
      case TaskNotificationStatus.failed:
        return 'Fallida';
    }
  }

  bool get isRead => this == TaskNotificationStatus.read;
  bool get isPending => this == TaskNotificationStatus.pending;
  bool get isFailed => this == TaskNotificationStatus.failed;
}
