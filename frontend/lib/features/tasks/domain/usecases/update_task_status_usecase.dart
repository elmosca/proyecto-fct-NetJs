import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository _taskRepository;

  UpdateTaskStatusUseCase(this._taskRepository);

  Future<TaskEntity> execute(String taskId, TaskStatus status) {
    return _taskRepository.updateTaskStatus(taskId, status);
  }
}