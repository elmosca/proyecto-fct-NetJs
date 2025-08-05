import 'package:fct_frontend/features/anteprojects/domain/entities/calendar_event.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart';

abstract class NotificationRepository {
  // Notificaciones
  Future<List<Notification>> getNotifications({
    String? userId,
    NotificationType? type,
    NotificationStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<Notification?> getNotificationById(String id);

  Future<Notification> createNotification(Notification notification);

  Future<Notification> updateNotification(Notification notification);

  Future<void> deleteNotification(String id);

  Future<void> markAsRead(String id);

  Future<void> markAllAsRead(String userId);

  Future<int> getUnreadCount(String userId);

  // Eventos de Calendario
  Future<List<CalendarEvent>> getCalendarEvents({
    String? userId,
    CalendarEventType? type,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<CalendarEvent?> getCalendarEventById(String id);

  Future<CalendarEvent> createCalendarEvent(CalendarEvent event);

  Future<CalendarEvent> updateCalendarEvent(CalendarEvent event);

  Future<void> deleteCalendarEvent(String id);

  // Recordatorios automáticos
  Future<void> scheduleDefenseReminder(String defenseId, DateTime defenseDate);

  Future<void> cancelDefenseReminder(String defenseId);

  Future<List<Notification>> getPendingReminders();

  Future<void> sendNotification(Notification notification);

  Future<void> processScheduledNotifications();
}
