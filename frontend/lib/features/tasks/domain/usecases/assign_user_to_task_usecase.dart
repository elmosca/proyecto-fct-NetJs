import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class AssignUserToTaskUseCase {
  final TaskRepository _taskRepository;

  AssignUserToTaskUseCase(this._taskRepository);

  Future<TaskEntity> execute(String taskId, String userId) {
    return _taskRepository.assignTask(taskId, userId);
  }
}
