import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/providers/task_providers.dart';
import '../entities/task_dto.dart';
import '../repositories/task_repository.dart';

part 'remove_dependency_usecase.g.dart';

/// Use case para remover una dependencia entre tareas
class RemoveDependencyUseCase {
  final TaskRepository _taskRepository;

  const RemoveDependencyUseCase(this._taskRepository);

  /// Ejecuta el use case para remover una dependencia
  ///
  /// [taskId] - ID de la tarea que tiene la dependencia
  /// [dependencyTaskId] - ID de la tarea de la que ya no dependerá
  ///
  /// Retorna `true` si la dependencia se removió exitosamente
  Future<bool> execute(String taskId, String dependencyTaskId) async {
    final dto = RemoveDependencyDto(
      taskId: taskId,
      dependencyTaskId: dependencyTaskId,
    );

    return await _taskRepository.removeDependency(dto);
  }
}

/// Provider para el use case de remover dependencias
@riverpod
RemoveDependencyUseCase removeDependencyUseCase(
    RemoveDependencyUseCaseRef ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return RemoveDependencyUseCase(taskRepository);
}
