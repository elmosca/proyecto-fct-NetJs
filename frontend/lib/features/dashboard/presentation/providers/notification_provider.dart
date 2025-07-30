import 'package:fct_frontend/core/services/notification_service.dart';
import 'package:fct_frontend/shared/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para el servicio de notificaciones
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Estado de las notificaciones
class NotificationState {
  final List<Notification> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    List<Notification>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// Notifier para el estado de notificaciones
class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref _ref;

  NotificationNotifier(this._ref) : super(const NotificationState());

  /// Carga las notificaciones del usuario
  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implementar carga de notificaciones desde el backend
      // Por ahora usamos datos de ejemplo
      await Future.delayed(const Duration(milliseconds: 500));

      final notifications = [
        Notification(
          id: '1',
          title: 'Nuevo proyecto asignado',
          message: 'Se te ha asignado el proyecto "Sistema de Gestión"',
          type: 'project',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Notification(
          id: '2',
          title: 'Tarea completada',
          message: 'La tarea "Configurar base de datos" ha sido completada',
          type: 'task',
          readAt: DateTime.now().subtract(const Duration(hours: 1)),
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      final unreadCount = notifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Marca una notificación como leída
  Future<void> markAsRead(String notificationId) async {
    try {
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(readAt: DateTime.now());
        }
        return notification;
      }).toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );

      // TODO: Actualizar en el backend
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Marca todas las notificaciones como leídas
  Future<void> markAllAsRead() async {
    try {
      final updatedNotifications = state.notifications
          .map((notification) => notification.copyWith(readAt: DateTime.now()))
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );

      // TODO: Actualizar en el backend
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Elimina una notificación
  Future<void> deleteNotification(String notificationId) async {
    try {
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != notificationId)
          .toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );

      // TODO: Eliminar en el backend
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Muestra una notificación local
  Future<void> showLocalNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.general,
  }) async {
    try {
      final notificationService = _ref.read(notificationServiceProvider);
      await notificationService.showNotification(
        title: title,
        body: message,
        type: type,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Limpia el error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para acceder al estado de notificaciones
final notificationStateProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
  (ref) => NotificationNotifier(ref),
);
