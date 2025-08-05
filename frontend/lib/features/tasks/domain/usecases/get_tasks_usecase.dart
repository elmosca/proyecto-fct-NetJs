import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository _taskRepository;

  GetTasksUseCase(this._taskRepository);

  Future<List<TaskEntity>> execute({
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    TaskStatus? status,
    TaskPriority? priority,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    return _taskRepository.getTasks(
      projectId: projectId,
      anteprojectId: anteprojectId,
      assignedUserId: assignedUserId,
      status: status,
      priority: priority,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }
}
