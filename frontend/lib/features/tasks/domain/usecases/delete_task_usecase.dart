import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  Future<void> execute(String taskId) {
    return _taskRepository.deleteTask(taskId);
  }
}
