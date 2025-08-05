import 'package:fct_frontend/features/anteprojects/domain/repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository _notificationRepository;

  MarkNotificationReadUseCase(this._notificationRepository);

  Future<void> call(String notificationId) async {
    if (notificationId.isEmpty) {
      throw ArgumentError('notificationId no puede estar vacío');
    }

    await _notificationRepository.markAsRead(notificationId);
  }
}

class MarkAllNotificationsReadUseCase {
  final NotificationRepository _notificationRepository;

  MarkAllNotificationsReadUseCase(this._notificationRepository);

  Future<void> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('userId no puede estar vacío');
    }

    await _notificationRepository.markAllAsRead(userId);
  }
}
