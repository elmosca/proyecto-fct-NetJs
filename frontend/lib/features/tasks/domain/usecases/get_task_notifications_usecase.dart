import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/task_notification_dto.dart';
import '../entities/task_notification_entity.dart';
import '../repositories/task_notification_repository.dart';

part 'get_task_notifications_usecase.g.dart';

/// Use case para obtener notificaciones de tareas
class GetTaskNotificationsUseCase {
  final TaskNotificationRepository _repository;

  const GetTaskNotificationsUseCase(this._repository);

  /// Ejecuta el use case para obtener notificaciones
  ///
  /// [filters] - Filtros para las notificaciones
  ///
  /// Retorna la lista de notificaciones
  Future<List<TaskNotification>> execute(
      TaskNotificationFiltersDto filters) async {
    return await _repository.getTaskNotifications(filters);
  }
}

/// Provider para el use case de obtener notificaciones
@riverpod
GetTaskNotificationsUseCase getTaskNotificationsUseCase(
    GetTaskNotificationsUseCaseRef ref) {
  final repository = ref.watch(taskNotificationRepositoryProvider);
  return GetTaskNotificationsUseCase(repository);
}
