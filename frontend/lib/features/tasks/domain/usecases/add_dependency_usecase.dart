import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/providers/task_providers.dart';
import '../entities/task_dto.dart';
import '../repositories/task_repository.dart';

part 'add_dependency_usecase.g.dart';

/// Use case para agregar una dependencia entre tareas
class AddDependencyUseCase {
  final TaskRepository _taskRepository;

  const AddDependencyUseCase(this._taskRepository);

  /// Ejecuta el use case para agregar una dependencia
  ///
  /// [taskId] - ID de la tarea que tendrá la dependencia
  /// [dependencyTaskId] - ID de la tarea de la que dependerá
  ///
  /// Retorna `true` si la dependencia se agregó exitosamente
  Future<bool> execute(String taskId, String dependencyTaskId) async {
    final dto = AddDependencyDto(
      taskId: taskId,
      dependencyTaskId: dependencyTaskId,
    );

    return await _taskRepository.addDependency(dto);
  }
}

/// Provider para el use case de agregar dependencias
@riverpod
AddDependencyUseCase addDependencyUseCase(AddDependencyUseCaseRef ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return AddDependencyUseCase(taskRepository);
}
