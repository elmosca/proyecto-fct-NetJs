import 'package:fct_frontend/features/anteprojects/domain/entities/calendar_event.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/notification_repository.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/create_calendar_event_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/create_notification_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_calendar_events_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_notifications_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/mark_notification_read_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_providers.g.dart';

// Provider para el repositorio (placeholder para inyección de dependencias)
@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  throw UnimplementedError('Implementar con inyección de dependencias');
}

// Providers para casos de uso
@riverpod
GetNotificationsUseCase getNotificationsUseCase(
    GetNotificationsUseCaseRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationsUseCase(repository);
}

@riverpod
CreateNotificationUseCase createNotificationUseCase(
    CreateNotificationUseCaseRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return CreateNotificationUseCase(repository);
}

@riverpod
MarkNotificationReadUseCase markNotificationReadUseCase(
    MarkNotificationReadUseCaseRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkNotificationReadUseCase(repository);
}

@riverpod
MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase(
    MarkAllNotificationsReadUseCaseRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAllNotificationsReadUseCase(repository);
}

@riverpod
GetCalendarEventsUseCase getCalendarEventsUseCase(
    GetCalendarEventsUseCaseRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetCalendarEventsUseCase(repository);
}

@riverpod
CreateCalendarEventUseCase createCalendarEventUseCase(
    CreateCalendarEventUseCaseRef ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return CreateCalendarEventUseCase(repository);
}

// Modelo para filtros de notificaciones
class NotificationFilters {
  final String? userId;
  final NotificationType? type;
  final NotificationStatus? status;
  final DateTime? fromDate;
  final DateTime? toDate;

  const NotificationFilters({
    this.userId,
    this.type,
    this.status,
    this.fromDate,
    this.toDate,
  });

  NotificationFilters copyWith({
    String? userId,
    NotificationType? type,
    NotificationStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return NotificationFilters(
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

// Modelo para filtros de calendario
class CalendarFilters {
  final String? userId;
  final CalendarEventType? type;
  final DateTime? fromDate;
  final DateTime? toDate;

  const CalendarFilters({
    this.userId,
    this.type,
    this.fromDate,
    this.toDate,
  });

  CalendarFilters copyWith({
    String? userId,
    CalendarEventType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return CalendarFilters(
      userId: userId ?? this.userId,
      type: type ?? this.type,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

// Notifier para listas de notificaciones
@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  Future<List<Notification>> build() async {
    final useCase = ref.watch(getNotificationsUseCaseProvider);
    return await useCase();
  }

  Future<void> loadNotifications(NotificationFilters filters) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getNotificationsUseCaseProvider);
      final notifications = await useCase(
        userId: filters.userId,
        type: filters.type,
        status: filters.status,
        fromDate: filters.fromDate,
        toDate: filters.toDate,
      );
      state = AsyncValue.data(notifications);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createNotification({
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
    try {
      final useCase = ref.read(createNotificationUseCaseProvider);
      await useCase(
        title: title,
        message: message,
        type: type,
        userId: userId,
        anteprojectId: anteprojectId,
        defenseId: defenseId,
        evaluationId: evaluationId,
        metadata: metadata,
        scheduledAt: scheduledAt,
      );
      // Recargar notificaciones después de crear una nueva
      await loadNotifications(const NotificationFilters());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final useCase = ref.read(markNotificationReadUseCaseProvider);
      await useCase(notificationId);
      // Actualizar la lista local
      final currentNotifications = state.value ?? [];
      final updatedNotifications = currentNotifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(
            status: NotificationStatus.read,
            readAt: DateTime.now(),
          );
        }
        return notification;
      }).toList();
      state = AsyncValue.data(updatedNotifications);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      final useCase = ref.read(markAllNotificationsReadUseCaseProvider);
      await useCase(userId);
      // Actualizar la lista local
      final currentNotifications = state.value ?? [];
      final updatedNotifications = currentNotifications.map((notification) {
        if (notification.userId == userId && !notification.status.isRead) {
          return notification.copyWith(
            status: NotificationStatus.read,
            readAt: DateTime.now(),
          );
        }
        return notification;
      }).toList();
      state = AsyncValue.data(updatedNotifications);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Notifier para detalles de notificación
@riverpod
class NotificationDetailNotifier extends _$NotificationDetailNotifier {
  @override
  Future<Notification?> build(String notificationId) async {
    if (notificationId.isEmpty) return null;

    final repository = ref.watch(notificationRepositoryProvider);
    return await repository.getNotificationById(notificationId);
  }

  Future<void> refresh() async {
    final notificationId = state.value?.id;
    if (notificationId != null) {
      state = const AsyncValue.loading();
      try {
        final repository = ref.read(notificationRepositoryProvider);
        final notification =
            await repository.getNotificationById(notificationId);
        state = AsyncValue.data(notification);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

// Notifier para filtros de notificaciones
@riverpod
class NotificationFiltersNotifier extends _$NotificationFiltersNotifier {
  @override
  NotificationFilters build() {
    return const NotificationFilters();
  }

  void updateFilters(NotificationFilters filters) {
    state = filters;
  }

  void clearFilters() {
    state = const NotificationFilters();
  }
}

// Notifier para listas de eventos del calendario
@riverpod
class CalendarEventsNotifier extends _$CalendarEventsNotifier {
  @override
  Future<List<CalendarEvent>> build() async {
    final useCase = ref.watch(getCalendarEventsUseCaseProvider);
    return await useCase();
  }

  Future<void> loadCalendarEvents(CalendarFilters filters) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getCalendarEventsUseCaseProvider);
      final events = await useCase(
        userId: filters.userId,
        type: filters.type,
        fromDate: filters.fromDate,
        toDate: filters.toDate,
      );
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createCalendarEvent({
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
    try {
      final useCase = ref.read(createCalendarEventUseCaseProvider);
      await useCase(
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
        color: color,
        isRecurring: isRecurring,
        recurrenceRule: recurrenceRule,
      );
      // Recargar eventos después de crear uno nuevo
      await loadCalendarEvents(const CalendarFilters());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Notifier para filtros de calendario
@riverpod
class CalendarFiltersNotifier extends _$CalendarFiltersNotifier {
  @override
  CalendarFilters build() {
    return const CalendarFilters();
  }

  void updateFilters(CalendarFilters filters) {
    state = filters;
  }

  void clearFilters() {
    state = const CalendarFilters();
  }
}

// Provider para conteo de notificaciones no leídas
@riverpod
Future<int> unreadNotificationsCount(
    UnreadNotificationsCountRef ref, String userId) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getUnreadCount(userId);
}
