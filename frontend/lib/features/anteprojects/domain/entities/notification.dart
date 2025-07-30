import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String title,
    required String message,
    required NotificationType type,
    required NotificationStatus status,
    required String userId,
    String? anteprojectId,
    String? defenseId,
    String? evaluationId,
    Map<String, dynamic>? metadata,
    DateTime? scheduledAt,
    DateTime? readAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}

enum NotificationType {
  @JsonValue('defense_reminder')
  defenseReminder,
  @JsonValue('status_change')
  statusChange,
  @JsonValue('evaluation_completed')
  evaluationCompleted,
  @JsonValue('defense_scheduled')
  defenseScheduled,
  @JsonValue('defense_cancelled')
  defenseCancelled,
  @JsonValue('general')
  general,
}

enum NotificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('sent')
  sent,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.defenseReminder:
        return 'Recordatorio de Defensa';
      case NotificationType.statusChange:
        return 'Cambio de Estado';
      case NotificationType.evaluationCompleted:
        return 'Evaluación Completada';
      case NotificationType.defenseScheduled:
        return 'Defensa Programada';
      case NotificationType.defenseCancelled:
        return 'Defensa Cancelada';
      case NotificationType.general:
        return 'General';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.defenseReminder:
        return '⏰';
      case NotificationType.statusChange:
        return '🔄';
      case NotificationType.evaluationCompleted:
        return '✅';
      case NotificationType.defenseScheduled:
        return '📅';
      case NotificationType.defenseCancelled:
        return '❌';
      case NotificationType.general:
        return '📢';
    }
  }
}

extension NotificationStatusExtension on NotificationStatus {
  String get displayName {
    switch (this) {
      case NotificationStatus.pending:
        return 'Pendiente';
      case NotificationStatus.sent:
        return 'Enviada';
      case NotificationStatus.read:
        return 'Leída';
      case NotificationStatus.failed:
        return 'Fallida';
    }
  }

  bool get isRead => this == NotificationStatus.read;
  bool get isPending => this == NotificationStatus.pending;
  bool get isFailed => this == NotificationStatus.failed;
}
