import 'package:dio/dio.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';

abstract class TaskRemoteDataSource {
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

  Future<Task?> getTaskById(String id);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<Task> updateTaskStatus(String id, TaskStatus status);
  Future<Task> assignTask(String taskId, String userId);
  Future<Map<TaskStatus, List<Task>>> getTasksByStatus({
    String? projectId,
    String? anteprojectId,
  });
  Future<List<Task>> getUpcomingTasks({int days = 7, String? userId});
  Future<List<Task>> getOverdueTasks({String? userId});
  Future<Map<String, dynamic>> getTaskStatistics({
    String? projectId,
    String? anteprojectId,
    String? userId,
  });
  Future<List<Task>> searchTasks(
    String query, {
    String? projectId,
    String? anteprojectId,
    int? limit,
  });
  Future<List<Task>> getDependentTasks(String taskId);
  Future<Task> completeTask(String id, {String? notes});
  Future<List<Map<String, dynamic>>> getTaskHistory(String taskId);

  // Métodos para dependencias
  Future<bool> addDependency(AddDependencyDto dto);
  Future<bool> removeDependency(RemoveDependencyDto dto);
  Future<TaskDependenciesDto> getTaskDependencies(String taskId);
  Future<bool> hasCircularDependency(String taskId, String dependencyTaskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio _dio;

  TaskRemoteDataSourceImpl(this._dio);

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
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (projectId != null) queryParameters['projectId'] = projectId;
      if (anteprojectId != null)
        queryParameters['anteprojectId'] = anteprojectId;
      if (assignedUserId != null)
        queryParameters['assignedUserId'] = assignedUserId;
      if (status != null) queryParameters['status'] = status.name;
      if (priority != null) queryParameters['priority'] = priority.name;
      if (searchQuery != null) queryParameters['search'] = searchQuery;
      if (limit != null) queryParameters['limit'] = limit;
      if (offset != null) queryParameters['offset'] = offset;

      final response =
          await _dio.get('/tasks', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  @override
  Future<Task?> getTaskById(String id) async {
    try {
      final response = await _dio.get('/tasks/$id');
      return Task.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Error al obtener tarea: $e');
    }
  }

  @override
  Future<Task> createTask(Task task) async {
    try {
      final response = await _dio.post('/tasks', data: task.toJson());
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear tarea: $e');
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _dio.put('/tasks/${task.id}', data: task.toJson());
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/tasks/$id');
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }

  @override
  Future<Task> updateTaskStatus(String id, TaskStatus status) async {
    try {
      final response = await _dio.patch('/tasks/$id/status', data: {
        'status': status.name,
      });
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar estado de tarea: $e');
    }
  }

  @override
  Future<Task> assignTask(String taskId, String userId) async {
    try {
      final response = await _dio.patch('/tasks/$taskId/assign', data: {
        'userId': userId,
      });
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al asignar tarea: $e');
    }
  }

  @override
  Future<Map<TaskStatus, List<Task>>> getTasksByStatus({
    String? projectId,
    String? anteprojectId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (projectId != null) queryParameters['projectId'] = projectId;
      if (anteprojectId != null)
        queryParameters['anteprojectId'] = anteprojectId;

      final response =
          await _dio.get('/tasks/by-status', queryParameters: queryParameters);

      final Map<String, dynamic> data = response.data;
      final Map<TaskStatus, List<Task>> result = {};

      for (final entry in data.entries) {
        final status = TaskStatus.values.firstWhere(
          (s) => s.name == entry.key,
          orElse: () => TaskStatus.pending,
        );
        final tasks = (entry.value as List)
            .map((json) => Task.fromJson(json))
            .toList();
        result[status] = tasks;
      }

      return result;
    } catch (e) {
      throw Exception('Error al obtener tareas por estado: $e');
    }
  }

  @override
  Future<List<Task>> getUpcomingTasks(
      {int days = 7, String? userId}) async {
    try {
      final queryParameters = <String, dynamic>{'days': days};
      if (userId != null) queryParameters['userId'] = userId;

      final response =
          await _dio.get('/tasks/upcoming', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas próximas: $e');
    }
  }

  @override
  Future<List<Task>> getOverdueTasks({String? userId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (userId != null) queryParameters['userId'] = userId;

      final response =
          await _dio.get('/tasks/overdue', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas vencidas: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getTaskStatistics({
    String? projectId,
    String? anteprojectId,
    String? userId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (projectId != null) queryParameters['projectId'] = projectId;
      if (anteprojectId != null)
        queryParameters['anteprojectId'] = anteprojectId;
      if (userId != null) queryParameters['userId'] = userId;

      final response =
          await _dio.get('/tasks/statistics', queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      throw Exception('Error al obtener estadísticas de tareas: $e');
    }
  }

  @override
  Future<List<Task>> searchTasks(
    String query, {
    String? projectId,
    String? anteprojectId,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'q': query};
      if (projectId != null) queryParameters['projectId'] = projectId;
      if (anteprojectId != null)
        queryParameters['anteprojectId'] = anteprojectId;
      if (limit != null) queryParameters['limit'] = limit;

      final response =
          await _dio.get('/tasks/search', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al buscar tareas: $e');
    }
  }

  @override
  Future<List<Task>> getDependentTasks(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId/dependencies');

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas dependientes: $e');
    }
  }

  @override
  Future<Task> completeTask(String id, {String? notes}) async {
    try {
      final data = <String, dynamic>{};
      if (notes != null) data['notes'] = notes;

      final response = await _dio.patch('/tasks/$id/complete', data: data);
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al completar tarea: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTaskHistory(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId/history');

      final List<dynamic> data = response.data['data'] ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Error al obtener historial de tarea: $e');
    }
  }

  @override
  Future<bool> addDependency(AddDependencyDto dto) async {
    try {
      final response =
          await _dio.post('/tasks/dependencies', data: dto.toJson());
      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al agregar dependencia: $e');
    }
  }

  @override
  Future<bool> removeDependency(RemoveDependencyDto dto) async {
    try {
      final response =
          await _dio.delete('/tasks/dependencies', data: dto.toJson());
      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error al eliminar dependencia: $e');
    }
  }

  @override
  Future<TaskDependenciesDto> getTaskDependencies(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId/dependencies');
      return TaskDependenciesDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener dependencias de tarea: $e');
    }
  }

  @override
  Future<bool> hasCircularDependency(
      String taskId, String dependencyTaskId) async {
    try {
      final response = await _dio
          .get('/tasks/$taskId/has-circular-dependency/$dependencyTaskId');
      return response.data['hasCircularDependency'] as bool;
    } catch (e) {
      throw Exception('Error al verificar dependencia circular: $e');
    }
  }
}
