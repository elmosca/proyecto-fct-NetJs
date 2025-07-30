import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/notification_repository.dart';

class CreateNotificationUseCase {
  final NotificationRepository _notificationRepository;

  CreateNotificationUseCase(this._notificationRepository);

  Future<Notification> call({
    required String title,
    required String message,
    required NotificationType type,
    required String userId,
    String? anteprojectId,
    String? defenseId,
    String? evaluationId,
    Map<String, dynamic>? metadata,
    DateTime? scheduledAt,
  }) async {
    if (title.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }

    if (message.isEmpty) {
      throw ArgumentError('El mensaje no puede estar vacío');
    }

    if (userId.isEmpty) {
      throw ArgumentError('userId no puede estar vacío');
    }

    if (scheduledAt != null && scheduledAt.isBefore(DateTime.now())) {
      throw ArgumentError('La fecha programada no puede estar en el pasado');
    }

    final notification = Notification(
      id: '', // Se generará en el repositorio
      title: title,
      message: message,
      type: type,
      status: NotificationStatus.pending,
      userId: userId,
      anteprojectId: anteprojectId,
      defenseId: defenseId,
      evaluationId: evaluationId,
      metadata: metadata,
      scheduledAt: scheduledAt,
      createdAt: DateTime.now(),
    );

    return await _notificationRepository.createNotification(notification);
  }
}
