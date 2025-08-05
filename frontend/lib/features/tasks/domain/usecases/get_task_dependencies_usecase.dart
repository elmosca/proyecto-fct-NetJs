import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/providers/task_providers.dart';
import '../entities/task_dto.dart';
import '../repositories/task_repository.dart';

part 'get_task_dependencies_usecase.g.dart';

/// Use case para obtener las dependencias de una tarea
class GetTaskDependenciesUseCase {
  final TaskRepository _taskRepository;

  const GetTaskDependenciesUseCase(this._taskRepository);

  /// Ejecuta el use case para obtener las dependencias de una tarea
  ///
  /// [taskId] - ID de la tarea
  ///
  /// Retorna un [TaskDependenciesDto] con las dependencias y dependientes
  Future<TaskDependenciesDto> execute(String taskId) async {
    return await _taskRepository.getTaskDependencies(taskId);
  }
}

/// Provider para el use case de obtener dependencias
@riverpod
GetTaskDependenciesUseCase getTaskDependenciesUseCase(
    GetTaskDependenciesUseCaseRef ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return GetTaskDependenciesUseCase(taskRepository);
}
