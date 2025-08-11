import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  GetNotificationsUseCase(this._notificationRepository);

  Future<List<Notification>> call({
    String? userId,
    NotificationType? type,
    NotificationStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (userId != null && userId.isEmpty) {
      throw ArgumentError('userId no puede estar vacío');
    }

    if (fromDate != null && toDate != null && fromDate.isAfter(toDate)) {
      throw ArgumentError('fromDate no puede ser posterior a toDate');
    }

    return await _notificationRepository.getNotifications(
      userId: userId,
      type: type,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
