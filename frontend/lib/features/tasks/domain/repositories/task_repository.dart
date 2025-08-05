import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  /// Obtener todas las tareas con filtros opcionales
  Future<List<TaskEntity>> getTasks({
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
  Future<TaskEntity?> getTaskById(String id);

  /// Crear una nueva tarea
  Future<TaskEntity> createTask(TaskEntity task);

  /// Actualizar una tarea existente
  Future<TaskEntity> updateTask(TaskEntity task);

  /// Eliminar una tarea
  Future<void> deleteTask(String id);

  /// Cambiar el estado de una tarea
  Future<TaskEntity> updateTaskStatus(String id, TaskStatus status);

  /// Asignar una tarea a un usuario
  Future<TaskEntity> assignTask(String taskId, String userId);

  /// Obtener tareas por estado (para vista Kanban)
  Future<Map<TaskStatus, List<TaskEntity>>> getTasksByStatus({
    String? projectId,
    String? anteprojectId,
  });

  /// Obtener tareas próximas a vencer
  Future<List<TaskEntity>> getUpcomingTasks({
    int days = 7,
    String? userId,
  });

  /// Obtener tareas vencidas
  Future<List<TaskEntity>> getOverdueTasks({
    String? userId,
  });

  /// Obtener estadísticas de tareas
  Future<Map<String, dynamic>> getTaskStatistics({
    String? projectId,
    String? anteprojectId,
    String? userId,
  });

  /// Buscar tareas por texto
  Future<List<TaskEntity>> searchTasks(
    String query, {
    String? projectId,
    String? anteprojectId,
    int? limit,
  });

  /// Obtener tareas dependientes
  Future<List<TaskEntity>> getDependentTasks(String taskId);

  /// Marcar tarea como completada
  Future<TaskEntity> completeTask(String id, {String? notes});

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
