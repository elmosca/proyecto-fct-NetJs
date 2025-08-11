import 'package:fct_frontend/features/anteprojects/domain/entities/calendar_event.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/notification_repository.dart';

class GetCalendarEventsUseCase {
  final NotificationRepository _notificationRepository;

  GetCalendarEventsUseCase(this._notificationRepository);

  Future<List<CalendarEvent>> call({
    String? userId,
    CalendarEventType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (userId != null && userId.isEmpty) {
      throw ArgumentError('userId no puede estar vacío');
    }

    if (fromDate != null && toDate != null && fromDate.isAfter(toDate)) {
      throw ArgumentError('fromDate no puede ser posterior a toDate');
    }

    return await _notificationRepository.getCalendarEvents(
      userId: userId,
      type: type,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
