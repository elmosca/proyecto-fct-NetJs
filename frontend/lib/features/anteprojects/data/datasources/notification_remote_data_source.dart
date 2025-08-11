import 'package:dio/dio.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/calendar_event.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart';

abstract class NotificationRemoteDataSource {
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

  Future<void> scheduleDefenseReminder(String defenseId, DateTime defenseDate);

  Future<void> cancelDefenseReminder(String defenseId);

  Future<List<Notification>> getPendingReminders();

  Future<void> sendNotification(Notification notification);

  Future<void> processScheduledNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Notification>> getNotifications({
    String? userId,
    NotificationType? type,
    NotificationStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (userId != null) queryParameters['userId'] = userId;
      if (type != null) queryParameters['type'] = type.name;
      if (status != null) queryParameters['status'] = status.name;
      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();

      final response =
          await _dio.get('/notifications', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Notification.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener notificaciones: $e');
    }
  }

  @override
  Future<Notification?> getNotificationById(String id) async {
    try {
      final response = await _dio.get('/notifications/$id');
      final data = response.data['data'];
      return data != null ? Notification.fromJson(data) : null;
    } catch (e) {
      throw Exception('Error al obtener notificación: $e');
    }
  }

  @override
  Future<Notification> createNotification(Notification notification) async {
    try {
      final response =
          await _dio.post('/notifications', data: notification.toJson());
      return Notification.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al crear notificación: $e');
    }
  }

  @override
  Future<Notification> updateNotification(Notification notification) async {
    try {
      final response = await _dio.put('/notifications/${notification.id}',
          data: notification.toJson());
      return Notification.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al actualizar notificación: $e');
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await _dio.delete('/notifications/$id');
    } catch (e) {
      throw Exception('Error al eliminar notificación: $e');
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await _dio.patch('/notifications/$id/read');
    } catch (e) {
      throw Exception('Error al marcar notificación como leída: $e');
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      await _dio.patch('/notifications/read-all',
          queryParameters: {'userId': userId});
    } catch (e) {
      throw Exception(
          'Error al marcar todas las notificaciones como leídas: $e');
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _dio.get('/notifications/unread-count',
          queryParameters: {'userId': userId});
      return response.data['count'] ?? 0;
    } catch (e) {
      throw Exception(
          'Error al obtener conteo de notificaciones no leídas: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getCalendarEvents({
    String? userId,
    CalendarEventType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (userId != null) queryParameters['userId'] = userId;
      if (type != null) queryParameters['type'] = type.name;
      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();

      final response =
          await _dio.get('/calendar-events', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => CalendarEvent.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos del calendario: $e');
    }
  }

  @override
  Future<CalendarEvent?> getCalendarEventById(String id) async {
    try {
      final response = await _dio.get('/calendar-events/$id');
      final data = response.data['data'];
      return data != null ? CalendarEvent.fromJson(data) : null;
    } catch (e) {
      throw Exception('Error al obtener evento del calendario: $e');
    }
  }

  @override
  Future<CalendarEvent> createCalendarEvent(CalendarEvent event) async {
    try {
      final response =
          await _dio.post('/calendar-events', data: event.toJson());
      return CalendarEvent.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al crear evento del calendario: $e');
    }
  }

  @override
  Future<CalendarEvent> updateCalendarEvent(CalendarEvent event) async {
    try {
      final response =
          await _dio.put('/calendar-events/${event.id}', data: event.toJson());
      return CalendarEvent.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al actualizar evento del calendario: $e');
    }
  }

  @override
  Future<void> deleteCalendarEvent(String id) async {
    try {
      await _dio.delete('/calendar-events/$id');
    } catch (e) {
      throw Exception('Error al eliminar evento del calendario: $e');
    }
  }

  @override
  Future<void> scheduleDefenseReminder(
      String defenseId, DateTime defenseDate) async {
    try {
      await _dio.post('/notifications/schedule-defense-reminder', data: {
        'defenseId': defenseId,
        'defenseDate': defenseDate.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al programar recordatorio de defensa: $e');
    }
  }

  @override
  Future<void> cancelDefenseReminder(String defenseId) async {
    try {
      await _dio.delete('/notifications/cancel-defense-reminder/$defenseId');
    } catch (e) {
      throw Exception('Error al cancelar recordatorio de defensa: $e');
    }
  }

  @override
  Future<List<Notification>> getPendingReminders() async {
    try {
      final response = await _dio.get('/notifications/pending-reminders');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Notification.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener recordatorios pendientes: $e');
    }
  }

  @override
  Future<void> sendNotification(Notification notification) async {
    try {
      await _dio.post('/notifications/send', data: notification.toJson());
    } catch (e) {
      throw Exception('Error al enviar notificación: $e');
    }
  }

  @override
  Future<void> processScheduledNotifications() async {
    try {
      await _dio.post('/notifications/process-scheduled');
    } catch (e) {
      throw Exception('Error al procesar notificaciones programadas: $e');
    }
  }
}
