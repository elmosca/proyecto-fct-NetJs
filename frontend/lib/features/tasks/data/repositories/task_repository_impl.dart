import 'package:fct_frontend/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Task>> getTasks({
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    TaskStatus? status,
    TaskPriority? priority,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    return _remoteDataSource.getTasks(
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

  @override
  Future<Task?> getTaskById(String id) {
    return _remoteDataSource.getTaskById(id);
  }

  @override
  Future<Task> createTask(Task task) {
    return _remoteDataSource.createTask(task);
  }

  @override
  Future<Task> updateTask(Task task) {
    return _remoteDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) {
    return _remoteDataSource.deleteTask(id);
  }

  @override
  Future<Task> updateTaskStatus(String id, TaskStatus status) {
    return _remoteDataSource.updateTaskStatus(id, status);
  }

  @override
  Future<Task> assignTask(String taskId, String userId) {
    return _remoteDataSource.assignTask(taskId, userId);
  }

  @override
  Future<Map<TaskStatus, List<Task>>> getTasksByStatus({
    String? projectId,
    String? anteprojectId,
  }) {
    return _remoteDataSource.getTasksByStatus(
      projectId: projectId,
      anteprojectId: anteprojectId,
    );
  }

  @override
  Future<List<Task>> getUpcomingTasks({
    int days = 7,
    String? userId,
  }) {
    return _remoteDataSource.getUpcomingTasks(days: days, userId: userId);
  }

  @override
  Future<List<Task>> getOverdueTasks({
    String? userId,
  }) {
    return _remoteDataSource.getOverdueTasks(userId: userId);
  }

  @override
  Future<Map<String, dynamic>> getTaskStatistics({
    String? projectId,
    String? anteprojectId,
    String? userId,
  }) {
    return _remoteDataSource.getTaskStatistics(
      projectId: projectId,
      anteprojectId: anteprojectId,
      userId: userId,
    );
  }

  @override
  Future<List<Task>> searchTasks(
    String query, {
    String? projectId,
    String? anteprojectId,
    int? limit,
  }) {
    return _remoteDataSource.searchTasks(
      query,
      projectId: projectId,
      anteprojectId: anteprojectId,
      limit: limit,
    );
  }

  @override
  Future<List<Task>> getDependentTasks(String taskId) {
    return _remoteDataSource.getDependentTasks(taskId);
  }

  @override
  Future<Task> completeTask(String id, {String? notes}) {
    return _remoteDataSource.completeTask(id, notes: notes);
  }

  @override
  Future<List<Map<String, dynamic>>> getTaskHistory(String taskId) {
    return _remoteDataSource.getTaskHistory(taskId);
  }

  @override
  Future<bool> addDependency(AddDependencyDto dto) {
    return _remoteDataSource.addDependency(dto);
  }

  @override
  Future<bool> removeDependency(RemoveDependencyDto dto) {
    return _remoteDataSource.removeDependency(dto);
  }

  @override
  Future<TaskDependenciesDto> getTaskDependencies(String taskId) {
    return _remoteDataSource.getTaskDependencies(taskId);
  }

  @override
  Future<bool> hasCircularDependency(String taskId, String dependencyTaskId) {
    return _remoteDataSource.hasCircularDependency(taskId, dependencyTaskId);
  }
}
