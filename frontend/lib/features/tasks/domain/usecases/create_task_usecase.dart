import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository _taskRepository;

  CreateTaskUseCase(this._taskRepository);

  Future<Task> execute(Task task) {
    return _taskRepository.createTask(task);
  }
}
