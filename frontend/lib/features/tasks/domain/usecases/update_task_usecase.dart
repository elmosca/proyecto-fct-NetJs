import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository _taskRepository;

  UpdateTaskUseCase(this._taskRepository);

  Future<TaskEntity> execute(TaskEntity task) {
    return _taskRepository.updateTask(task);
  }
}
