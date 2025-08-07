import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../../domain/entities/task_notification_dto.dart';
import '../../domain/entities/task_notification_entity.dart';
import '../../domain/services/task_notification_service.dart';
import '../../domain/usecases/create_task_notification_usecase.dart';
import '../../domain/usecases/get_task_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';

// Providers para use cases
final createTaskNotificationUseCaseProvider =
    Provider<CreateTaskNotificationUseCase>((ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
});

final getTaskNotificationsUseCaseProvider =
    Provider<GetTaskNotificationsUseCase>((ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
});

final markNotificationAsReadUseCaseProvider =
    Provider<MarkNotificationAsReadUseCase>((ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
});

// Notifier para gestionar el estado de las notificaciones
class TaskNotificationsNotifier
    extends StateNotifier<AsyncValue<List<TaskNotification>>> {
  final TaskNotificationService _service;

  TaskNotificationsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadNotifications(TaskNotificationFiltersDto filters) async {
    state = const AsyncValue.loading();
    // TODO: Implementar cuando tengamos el repository configurado
    state = const AsyncValue.data([]);
  }

  Future<void> refresh(TaskNotificationFiltersDto filters) async {
    // TODO: Implementar cuando tengamos el repository configurado
    state = const AsyncValue.data([]);
  }

  Future<void> createNotification(CreateTaskNotificationDto dto) async {
    // TODO: Implementar cuando tengamos el repository configurado
  }

  Future<void> markAsRead(String notificationId) async {
    await _service.markAsRead(notificationId);
    // Actualizar el estado local
    if (state.hasValue) {
      final notifications = state.value!;
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updatedNotifications = List<TaskNotification>.from(notifications);
        updatedNotifications[index] = updatedNotifications[index].copyWith(
          status: TaskNotificationStatus.read,
          readAt: DateTime.now(),
        );
        state = AsyncValue.data(updatedNotifications);
      }
    }
  }

  Future<void> markMultipleAsRead(List<String> notificationIds) async {
    final updatedNotifications = await _service.bulkMarkAsRead(notificationIds);
    state = AsyncValue.data(updatedNotifications);
  }

  Future<void> deleteNotification(String notificationId) async {
    // TODO: Implementar cuando tengamos el repository configurado
    // Actualizar el estado local
    if (state.hasValue) {
      final notifications = state.value!;
      final updatedNotifications =
          notifications.where((n) => n.id != notificationId).toList();
      state = AsyncValue.data(updatedNotifications);
    }
  }

  Future<void> notifyTaskAssigned(
      Task task, String assignedUserId) async {
    await _service.notifyTaskAssigned(task, assignedUserId);
  }

  Future<void> notifyTaskStatusChanged(
      Task task, String userId, String previousStatus) async {
    await _service.notifyTaskStatusChanged(task, userId, previousStatus);
  }

  Future<void> notifyTaskDueDateReminder(
      Task task, String userId, int daysUntilDue) async {
    await _service.notifyTaskDueDateReminder(task, userId, daysUntilDue);
  }

  Future<void> notifyTaskOverdue(Task task, String userId) async {
    await _service.notifyTaskOverdue(task, userId);
  }

  Future<void> notifyTaskCompleted(Task task, String userId) async {
    await _service.notifyTaskCompleted(task, userId);
  }

  Future<void> notifyDependencyCompleted(
      Task task, Task dependencyTask, String userId) async {
    await _service.notifyDependencyCompleted(task, dependencyTask, userId);
  }

  Future<void> notifyCommentAdded(
      Task task, String userId, String commentAuthor) async {
    await _service.notifyTaskCommentAdded(task, userId, commentAuthor);
  }

  Future<void> notifyPriorityChanged(
      Task task, String userId, String previousPriority) async {
    await _service.notifyTaskPriorityChanged(task, userId, previousPriority);
  }

  Future<void> notifyMilestoneReached(
      Task task, String userId, String milestoneName) async {
    await _service.notifyMilestoneReached(task, userId, milestoneName);
  }

  Future<void> scheduleDueDateReminder(
      Task task, String userId, DateTime reminderDate) async {
    await _service.scheduleDueDateReminder(task, userId, reminderDate);
  }
}

// Provider para el notifier
final taskNotificationsNotifierProvider = StateNotifierProvider<
    TaskNotificationsNotifier, AsyncValue<List<TaskNotification>>>((ref) {
  // TODO: Implementar cuando tengamos el service configurado
  throw UnimplementedError('Service not configured yet');
});

// Providers para notificaciones específicas
final taskNotificationByIdProvider =
    FutureProvider.family<TaskNotification?, String>((ref, id) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return null;
});

final unreadNotificationsCountProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return 0;
});

final unreadNotificationsProvider =
    FutureProvider.family<List<TaskNotification>, String>((ref, userId) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

final taskNotificationsByTaskIdProvider =
    FutureProvider.family<List<TaskNotification>, String>((ref, taskId) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

final taskNotificationsByProjectIdProvider =
    FutureProvider.family<List<TaskNotification>, String>(
        (ref, projectId) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});
