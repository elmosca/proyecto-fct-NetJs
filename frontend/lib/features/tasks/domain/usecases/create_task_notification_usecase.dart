import 'package:fct_frontend/features/tasks/domain/entities/task_notification_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_notification_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_notification_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_task_notification_usecase.g.dart';

/// Use case para crear notificaciones de tareas
class CreateTaskNotificationUseCase {
  final TaskNotificationRepository _repository;

  const CreateTaskNotificationUseCase(this._repository);

  /// Ejecuta el use case para crear una notificación
  ///
  /// [dto] - DTO con los datos de la notificación
  ///
  /// Retorna la notificación creada
  Future<TaskNotification> execute(CreateTaskNotificationDto dto) async {
    return await _repository.createTaskNotification(dto);
  }
}

/// Provider para el use case de crear notificaciones
@riverpod
CreateTaskNotificationUseCase createTaskNotificationUseCase(Ref ref) {
  // TODO: Implementar provider del repositorio
  throw UnimplementedError(
      'taskNotificationRepositoryProvider not implemented');
}
