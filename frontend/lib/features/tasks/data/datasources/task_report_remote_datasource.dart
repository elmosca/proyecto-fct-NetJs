import 'package:dio/dio.dart';

import '../../domain/entities/task_report_dto.dart';
import '../../domain/entities/task_report_entity.dart';

abstract class TaskReportRemoteDataSource {
  Future<TaskReport> generateReport(CreateTaskReportDto dto);
  Future<List<TaskReport>> getReports(TaskReportFiltersDto? filters);
  Future<TaskReport?> getReportById(String id);
  Future<TaskReport> updateReport(String id, UpdateTaskReportDto dto);
  Future<void> deleteReport(String id);
  Future<String> exportReport(String id, TaskReportExportDto dto);
  Future<TaskReport> scheduleReport(String id, TaskReportScheduleDto dto);
  Future<void> cancelScheduledReport(String id);
  Future<List<TaskReport>> getScheduledReports();
  Future<List<TaskReport>> getExpiredReports();
  Future<void> cleanupExpiredReports();
  Future<Map<String, dynamic>> getReportStatistics();
}

class TaskReportRemoteDataSourceImpl implements TaskReportRemoteDataSource {
  final Dio _dio;

  TaskReportRemoteDataSourceImpl(this._dio);

  @override
  Future<TaskReport> generateReport(CreateTaskReportDto dto) async {
    try {
      final response = await _dio.post(
        '/api/task-reports',
        data: dto.toJson(),
      );
      return TaskReport.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al generar reporte: $e');
    }
  }

  @override
  Future<List<TaskReport>> getReports(TaskReportFiltersDto? filters) async {
    try {
      final response = await _dio.get(
        '/api/task-reports',
        queryParameters: filters?.toJson(),
      );
      return (response.data as List)
          .map((json) => TaskReport.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener reportes: $e');
    }
  }

  @override
  Future<TaskReport?> getReportById(String id) async {
    try {
      final response = await _dio.get('/api/task-reports/$id');
      return TaskReport.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Error al obtener reporte: $e');
    }
  }

  @override
  Future<TaskReport> updateReport(String id, UpdateTaskReportDto dto) async {
    try {
      final response = await _dio.put(
        '/api/task-reports/$id',
        data: dto.toJson(),
      );
      return TaskReport.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar reporte: $e');
    }
  }

  @override
  Future<void> deleteReport(String id) async {
    try {
      await _dio.delete('/api/task-reports/$id');
    } catch (e) {
      throw Exception('Error al eliminar reporte: $e');
    }
  }

  @override
  Future<String> exportReport(String id, TaskReportExportDto dto) async {
    try {
      final response = await _dio.post(
        '/api/task-reports/$id/export',
        data: dto.toJson(),
      );
      return response.data['downloadUrl'] as String;
    } catch (e) {
      throw Exception('Error al exportar reporte: $e');
    }
  }

  @override
  Future<TaskReport> scheduleReport(
      String id, TaskReportScheduleDto dto) async {
    try {
      final response = await _dio.post(
        '/api/task-reports/$id/schedule',
        data: dto.toJson(),
      );
      return TaskReport.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al programar reporte: $e');
    }
  }

  @override
  Future<void> cancelScheduledReport(String id) async {
    try {
      await _dio.delete('/api/task-reports/$id/schedule');
    } catch (e) {
      throw Exception('Error al cancelar reporte programado: $e');
    }
  }

  @override
  Future<List<TaskReport>> getScheduledReports() async {
    try {
      final response = await _dio.get('/api/task-reports/scheduled');
      return (response.data as List)
          .map((json) => TaskReport.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener reportes programados: $e');
    }
  }

  @override
  Future<List<TaskReport>> getExpiredReports() async {
    try {
      final response = await _dio.get('/api/task-reports/expired');
      return (response.data as List)
          .map((json) => TaskReport.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener reportes expirados: $e');
    }
  }

  @override
  Future<void> cleanupExpiredReports() async {
    try {
      await _dio.delete('/api/task-reports/cleanup');
    } catch (e) {
      throw Exception('Error al limpiar reportes expirados: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getReportStatistics() async {
    try {
      final response = await _dio.get('/api/task-reports/statistics');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error al obtener estadísticas de reportes: $e');
    }
  }
}
