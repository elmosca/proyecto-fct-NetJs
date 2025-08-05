import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/update_task_status_usecase.dart';

part 'task_providers.g.dart';

// Providers de inyección de dependencias
@riverpod
TaskRepository taskRepository(TaskRepositoryRef ref) {
  // TODO: Implementar inyección de dependencias con GetIt
  throw UnimplementedError('Implementar con GetIt');
}

@riverpod
GetTasksUseCase getTasksUseCase(GetTasksUseCaseRef ref) {
  return GetTasksUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
CreateTaskUseCase createTaskUseCase(CreateTaskUseCaseRef ref) {
  return CreateTaskUseCase(ref.watch(taskRepositoryProvider));
}

@riverpod
UpdateTaskStatusUseCase updateTaskStatusUseCase(UpdateTaskStatusUseCaseRef ref) {
  return UpdateTaskStatusUseCase(ref.watch(taskRepositoryProvider));
}

// Providers de estado
@riverpod
class TasksNotifier extends _$TasksNotifier {
  @override
  Future<List<Task>> build({
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    TaskStatus? status,
    TaskPriority? priority,
    String? searchQuery,
  }) async {
    final useCase = ref.read(getTasksUseCaseProvider);
    return useCase.execute(
      projectId: projectId,
      anteprojectId: anteprojectId,
      assignedUserId: assignedUserId,
      status: status,
      priority: priority,
      searchQuery: searchQuery,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> createTask(Task task) async {
    final useCase = ref.read(createTaskUseCaseProvider);
    await useCase.execute(task);
    ref.invalidateSelf();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    final useCase = ref.read(updateTaskStatusUseCaseProvider);
    await useCase.execute(taskId, status);
    ref.invalidateSelf();
  }
}

@riverpod
class TaskKanbanNotifier extends _$TaskKanbanNotifier {
  @override
  Future<Map<TaskStatus, List<Task>>> build({
    String? projectId,
    String? anteprojectId,
  }) async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getTasksByStatus(
      projectId: projectId,
      anteprojectId: anteprojectId,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> moveTask(String taskId, TaskStatus newStatus) async {
    final useCase = ref.read(updateTaskStatusUseCaseProvider);
    await useCase.execute(taskId, newStatus);
    ref.invalidateSelf();
  }
}

@riverpod
class TaskStatisticsNotifier extends _$TaskStatisticsNotifier {
  @override
  Future<Map<String, dynamic>> build({
    String? projectId,
    String? anteprojectId,
    String? userId,
  }) async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getTaskStatistics(
      projectId: projectId,
      anteprojectId: anteprojectId,
      userId: userId,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class UpcomingTasksNotifier extends _$UpcomingTasksNotifier {
  @override
  Future<List<Task>> build({int days = 7, String? userId}) async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getUpcomingTasks(days: days, userId: userId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class OverdueTasksNotifier extends _$OverdueTasksNotifier {
  @override
  Future<List<Task>> build({String? userId}) async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getOverdueTasks(userId: userId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
