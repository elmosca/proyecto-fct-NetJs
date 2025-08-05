import 'package:fct_frontend/features/anteprojects/domain/entities/calendar_event.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/notification_repository.dart';

class CreateCalendarEventUseCase {
  final NotificationRepository _notificationRepository;

  CreateCalendarEventUseCase(this._notificationRepository);

  Future<CalendarEvent> call({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required CalendarEventType type,
    required String userId,
    String? anteprojectId,
    String? defenseId,
    String? location,
    String? notes,
    bool isAllDay = false,
    String? color,
    bool isRecurring = false,
    String? recurrenceRule,
  }) async {
    if (title.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }

    if (description.isEmpty) {
      throw ArgumentError('La descripción no puede estar vacía');
    }

    if (userId.isEmpty) {
      throw ArgumentError('userId no puede estar vacío');
    }

    if (startDate.isAfter(endDate)) {
      throw ArgumentError(
          'La fecha de inicio no puede ser posterior a la fecha de fin');
    }

    if (startDate.isBefore(DateTime.now()) && !isAllDay) {
      throw ArgumentError('La fecha de inicio no puede estar en el pasado');
    }

    final event = CalendarEvent(
      id: '', // Se generará en el repositorio
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      type: type,
      userId: userId,
      anteprojectId: anteprojectId,
      defenseId: defenseId,
      location: location,
      notes: notes,
      isAllDay: isAllDay,
      color: color ?? type.defaultColor,
      isRecurring: isRecurring,
      recurrenceRule: recurrenceRule,
      createdAt: DateTime.now(),
    );

    return await _notificationRepository.createCalendarEvent(event);
  }
}
