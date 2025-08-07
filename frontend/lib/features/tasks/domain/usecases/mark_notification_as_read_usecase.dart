import 'package:fct_frontend/features/tasks/domain/entities/task_notification_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_notification_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_notification_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_notification_as_read_usecase.g.dart';

/// Use case para marcar notificaciones como leídas
class MarkNotificationAsReadUseCase {
  final TaskNotificationRepository _repository;

  const MarkNotificationAsReadUseCase(this._repository);

  /// Ejecuta el use case para marcar una notificación como leída
  ///
  /// [dto] - DTO con el ID de la notificación
  ///
  /// Retorna la notificación actualizada
  Future<TaskNotification> execute(MarkNotificationAsReadDto dto) async {
    return await _repository.markAsRead(dto);
  }
}

/// Provider para el use case de marcar como leída
@riverpod
MarkNotificationAsReadUseCase markNotificationAsReadUseCase(Ref ref) {
  // TODO: Implementar provider del repositorio
  throw UnimplementedError('taskNotificationRepositoryProvider not implemented');
}
