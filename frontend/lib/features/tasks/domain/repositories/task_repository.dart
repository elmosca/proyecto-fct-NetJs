import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';

abstract class TaskRepository {
  /// Obtener todas las tareas con filtros opcionales
  Future<List<Task>> getTasks({
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    TaskStatus? status,
    TaskPriority? priority,
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// Obtener una tarea por ID
  Future<Task?> getTaskById(String id);

  /// Crear una nueva tarea
  Future<Task> createTask(Task task);

  /// Actualizar una tarea existente
  Future<Task> updateTask(Task task);

  /// Eliminar una tarea
  Future<void> deleteTask(String id);

  /// Cambiar el estado de una tarea
  Future<Task> updateTaskStatus(String id, TaskStatus status);

  /// Asignar una tarea a un usuario
  Future<Task> assignTask(String taskId, String userId);

  /// Obtener tareas por estado (para vista Kanban)
  Future<Map<TaskStatus, List<Task>>> getTasksByStatus({
    String? projectId,
    String? anteprojectId,
  });

  /// Obtener tareas próximas a vencer
  Future<List<Task>> getUpcomingTasks({
    int days = 7,
    String? userId,
  });

  /// Obtener tareas vencidas
  Future<List<Task>> getOverdueTasks({
    String? userId,
  });

  /// Obtener estadísticas de tareas
  Future<Map<String, dynamic>> getTaskStatistics({
    String? projectId,
    String? anteprojectId,
    String? userId,
  });

  /// Buscar tareas por texto
  Future<List<Task>> searchTasks(
    String query, {
    String? projectId,
    String? anteprojectId,
    int? limit,
  });

  /// Obtener tareas dependientes
  Future<List<Task>> getDependentTasks(String taskId);

  /// Marcar tarea como completada
  Future<Task> completeTask(String id, {String? notes});

  /// Obtener historial de cambios de una tarea
  Future<List<Map<String, dynamic>>> getTaskHistory(String taskId);

  /// Agregar una dependencia entre tareas
  Future<bool> addDependency(AddDependencyDto dto);

  /// Remover una dependencia entre tareas
  Future<bool> removeDependency(RemoveDependencyDto dto);

  /// Obtener las dependencias de una tarea
  Future<TaskDependenciesDto> getTaskDependencies(String taskId);

  /// Verificar si existe una dependencia circular
  Future<bool> hasCircularDependency(String taskId, String dependencyTaskId);
}
