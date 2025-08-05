import 'package:dio/dio.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskEntity>> getTasks(TaskFiltersDto filters);
  Future<TaskEntity> getTaskById(String taskId);
  Future<TaskEntity> createTask(CreateTaskDto createTaskDto);
  Future<TaskEntity> updateTask(String taskId, UpdateTaskDto updateTaskDto);
  Future<void> deleteTask(String taskId);
  Future<TaskEntity> assignUserToTask(
      String taskId, AssignUserDto assignUserDto);
  Future<TaskEntity> unassignUserFromTask(String taskId, String userId);
  Future<TaskEntity> updateTaskStatus(String taskId, TaskStatus status);
  Future<List<TaskEntity>> getTasksByProject(String projectId);
  Future<List<TaskEntity>> getTasksByAssignee(String userId);
  Future<List<TaskEntity>> getTasksByMilestone(String milestoneId);
  Future<TaskEntity> updateTaskPosition(String taskId, int newPosition);
  Future<TaskEntity> completeTask(String taskId);
  Future<Map<String, dynamic>> getTaskStatistics(String? projectId);
  
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
  Future<List<TaskEntity>> getTasks(TaskFiltersDto filters) async {
    try {
      final response =
          await _dio.get('/tasks', queryParameters: filters.toJson());
      final List<dynamic> data = response.data['data'];
      return data.map((json) => TaskEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  @override
  Future<TaskEntity> getTaskById(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId');
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener tarea: $e');
    }
  }

  @override
  Future<TaskEntity> createTask(CreateTaskDto createTaskDto) async {
    try {
      final response = await _dio.post('/tasks', data: createTaskDto.toJson());
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear tarea: $e');
    }
  }

  @override
  Future<TaskEntity> updateTask(
      String taskId, UpdateTaskDto updateTaskDto) async {
    try {
      final response =
          await _dio.patch('/tasks/$taskId', data: updateTaskDto.toJson());
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _dio.delete('/tasks/$taskId');
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }

  @override
  Future<TaskEntity> assignUserToTask(
      String taskId, AssignUserDto assignUserDto) async {
    try {
      final response = await _dio.post('/tasks/$taskId/assign',
          data: assignUserDto.toJson());
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al asignar usuario a tarea: $e');
    }
  }

  @override
  Future<TaskEntity> unassignUserFromTask(String taskId, String userId) async {
    try {
      final response = await _dio.delete('/tasks/$taskId/assign/$userId');
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al desasignar usuario de tarea: $e');
    }
  }

  @override
  Future<TaskEntity> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final response = await _dio
          .patch('/tasks/$taskId/status', data: {'status': status.name});
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar estado de tarea: $e');
    }
  }

  @override
  Future<List<TaskEntity>> getTasksByProject(String projectId) async {
    try {
      final response =
          await _dio.get('/tasks', queryParameters: {'projectId': projectId});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => TaskEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas del proyecto: $e');
    }
  }

  @override
  Future<List<TaskEntity>> getTasksByAssignee(String userId) async {
    try {
      final response =
          await _dio.get('/tasks', queryParameters: {'assigneeId': userId});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => TaskEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas del usuario: $e');
    }
  }

  @override
  Future<List<TaskEntity>> getTasksByMilestone(String milestoneId) async {
    try {
      final response = await _dio
          .get('/tasks', queryParameters: {'milestoneId': milestoneId});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => TaskEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas del milestone: $e');
    }
  }

  @override
  Future<TaskEntity> updateTaskPosition(String taskId, int newPosition) async {
    try {
      final response = await _dio
          .patch('/tasks/$taskId/position', data: {'position': newPosition});
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar posición de tarea: $e');
    }
  }

  @override
  Future<TaskEntity> completeTask(String taskId) async {
    try {
      final response = await _dio.patch('/tasks/$taskId/complete');
      return TaskEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al completar tarea: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getTaskStatistics(String? projectId) async {
    try {
      final response = await _dio.get('/tasks/statistics',
          queryParameters: projectId != null ? {'projectId': projectId} : null);
      return response.data;
    } catch (e) {
      throw Exception('Error al obtener estadísticas de tareas: $e');
    }
  }

  @override
  Future<bool> addDependency(AddDependencyDto dto) async {
    try {
      final response = await _dio.post('/tasks/dependencies', data: dto.toJson());
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al agregar dependencia: $e');
    }
  }

  @override
  Future<bool> removeDependency(RemoveDependencyDto dto) async {
    try {
      final response = await _dio.delete('/tasks/dependencies', data: dto.toJson());
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error al remover dependencia: $e');
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
  Future<bool> hasCircularDependency(String taskId, String dependencyTaskId) async {
    try {
      final response = await _dio.get('/tasks/dependencies/check-circular', 
          queryParameters: {
            'taskId': taskId,
            'dependencyTaskId': dependencyTaskId,
          });
      return response.data['hasCircularDependency'] ?? false;
    } catch (e) {
      throw Exception('Error al verificar dependencia circular: $e');
    }
  }
}
