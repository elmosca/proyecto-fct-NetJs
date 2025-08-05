import 'package:fct_frontend/features/anteprojects/data/datasources/notification_remote_data_source.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/calendar_event.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Notification>> getNotifications({
    String? userId,
    NotificationType? type,
    NotificationStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _remoteDataSource.getNotifications(
      userId: userId,
      type: type,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<Notification?> getNotificationById(String id) async {
    return await _remoteDataSource.getNotificationById(id);
  }

  @override
  Future<Notification> createNotification(Notification notification) async {
    return await _remoteDataSource.createNotification(notification);
  }

  @override
  Future<Notification> updateNotification(Notification notification) async {
    return await _remoteDataSource.updateNotification(notification);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await _remoteDataSource.deleteNotification(id);
  }

  @override
  Future<void> markAsRead(String id) async {
    await _remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _remoteDataSource.markAllAsRead(userId);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    return await _remoteDataSource.getUnreadCount(userId);
  }

  @override
  Future<List<CalendarEvent>> getCalendarEvents({
    String? userId,
    CalendarEventType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _remoteDataSource.getCalendarEvents(
      userId: userId,
      type: type,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<CalendarEvent?> getCalendarEventById(String id) async {
    return await _remoteDataSource.getCalendarEventById(id);
  }

  @override
  Future<CalendarEvent> createCalendarEvent(CalendarEvent event) async {
    return await _remoteDataSource.createCalendarEvent(event);
  }

  @override
  Future<CalendarEvent> updateCalendarEvent(CalendarEvent event) async {
    return await _remoteDataSource.updateCalendarEvent(event);
  }

  @override
  Future<void> deleteCalendarEvent(String id) async {
    await _remoteDataSource.deleteCalendarEvent(id);
  }

  @override
  Future<void> scheduleDefenseReminder(
      String defenseId, DateTime defenseDate) async {
    await _remoteDataSource.scheduleDefenseReminder(defenseId, defenseDate);
  }

  @override
  Future<void> cancelDefenseReminder(String defenseId) async {
    await _remoteDataSource.cancelDefenseReminder(defenseId);
  }

  @override
  Future<List<Notification>> getPendingReminders() async {
    return await _remoteDataSource.getPendingReminders();
  }

  @override
  Future<void> sendNotification(Notification notification) async {
    await _remoteDataSource.sendNotification(notification);
  }

  @override
  Future<void> processScheduledNotifications() async {
    await _remoteDataSource.processScheduledNotifications();
  }
}
