import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class GetTaskStatisticsUseCase {
  final TaskRepository _taskRepository;

  GetTaskStatisticsUseCase(this._taskRepository);

  Future<Map<String, dynamic>> execute(String? projectId) {
    return _taskRepository.getTaskStatistics(projectId: projectId);
  }
} 
