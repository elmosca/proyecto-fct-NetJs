import 'package:fct_frontend/features/tasks/domain/entities/task_report_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_report_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_report_repository.dart';

/// Servicio para manejar reportes de progreso de tareas
class TaskReportService {
  final TaskReportRepository _repository;

  TaskReportService(this._repository);

  /// Generar reporte de resumen de estados de tareas
  Future<TaskReport> generateStatusSummaryReport({
    String? projectId,
    String? milestoneId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Resumen de Estados de Tareas',
      description: 'Distribución de tareas por estado',
      type: TaskReportType.taskStatusSummary,
      projectId: projectId,
      milestoneId: milestoneId,
      filters: {
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de progreso por usuario
  Future<TaskReport> generateProgressByUserReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Progreso de Tareas por Usuario',
      description: 'Análisis del progreso de tareas por usuario asignado',
      type: TaskReportType.taskProgressByUser,
      projectId: projectId,
      filters: {
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de progreso por proyecto
  Future<TaskReport> generateProgressByProjectReport({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Progreso de Tareas por Proyecto',
      description: 'Evaluación del progreso de tareas por proyecto',
      type: TaskReportType.taskProgressByProject,
      filters: {
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de tareas vencidas
  Future<TaskReport> generateOverdueSummaryReport({
    String? projectId,
    String? userId,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Resumen de Tareas Vencidas',
      description: 'Lista de todas las tareas vencidas y su estado actual',
      type: TaskReportType.taskOverdueSummary,
      projectId: projectId,
      filters: {
        'userId': userId,
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de tendencias de completado
  Future<TaskReport> generateCompletionTrendsReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
    String? period,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Tendencias de Completado',
      description: 'Análisis de tendencias de completado en el tiempo',
      type: TaskReportType.taskCompletionTrends,
      projectId: projectId,
      filters: {
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
        'period': period,
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de distribución de prioridades
  Future<TaskReport> generatePriorityDistributionReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Distribución de Prioridades',
      description: 'Distribución de tareas por nivel de prioridad',
      type: TaskReportType.taskPriorityDistribution,
      projectId: projectId,
      filters: {
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de análisis de complejidad
  Future<TaskReport> generateComplexityAnalysisReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Análisis de Complejidad',
      description: 'Análisis de la complejidad de las tareas',
      type: TaskReportType.taskComplexityAnalysis,
      projectId: projectId,
      filters: {
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de análisis de dependencias
  Future<TaskReport> generateDependencyAnalysisReport({
    String? projectId,
    String? taskId,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Análisis de Dependencias',
      description: 'Análisis de dependencias entre tareas',
      type: TaskReportType.taskDependencyAnalysis,
      projectId: projectId,
      filters: {
        'taskId': taskId,
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte de análisis de tiempo
  Future<TaskReport> generateTimeAnalysisReport({
    String? projectId,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Análisis de Tiempo',
      description: 'Análisis de tiempo estimado vs tiempo real',
      type: TaskReportType.taskTimeAnalysis,
      projectId: projectId,
      filters: {
        'userId': userId,
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      },
    );

    return await _repository.createTaskReport(dto);
  }

  /// Generar reporte personalizado
  Future<TaskReport> generateCustomReport({
    required String title,
    required String description,
    required Map<String, dynamic> filters,
    String? projectId,
    String? milestoneId,
  }) async {
    final dto = CreateTaskReportDto(
      title: title,
      description: description,
      type: TaskReportType.taskCustomReport,
      projectId: projectId,
      milestoneId: milestoneId,
      filters: filters,
    );

    return await _repository.createTaskReport(dto);
  }

  /// Exportar reporte a diferentes formatos
  Future<TaskReportDataDto> exportReport({
    required String reportId,
    required String format,
    Map<String, dynamic>? options,
  }) async {
    final dto = TaskReportExportDto(
      reportId: reportId,
      format: format,
      exportOptions: options,
    );

    return await _repository.exportReport(dto);
  }

  /// Programar reporte para ejecución automática
  Future<TaskReportScheduleDto> scheduleReport({
    required String reportId,
    required String schedule,
    Map<String, dynamic>? config,
  }) async {
    return await _repository.scheduleReport(reportId, schedule);
  }

  /// Cancelar reporte programado
  Future<void> cancelScheduledReport(String reportId) async {
    await _repository.cancelScheduledReport(reportId);
  }

  /// Obtener reportes programados
  Future<List<TaskReportScheduleDto>> getScheduledReports() async {
    return await _repository.getScheduledReports();
  }

  /// Obtener reportes expirados
  Future<List<TaskReport>> getExpiredReports() async {
    return await _repository.getExpiredReports();
  }

  /// Limpiar reportes expirados
  Future<void> cleanupExpiredReports() async {
    await _repository.cleanupExpiredReports();
  }

  /// Obtener estadísticas de reportes
  Future<Map<String, dynamic>> getReportStatistics({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _repository.getReportStatistics(
      projectId: projectId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  /// Obtener reportes con filtros
  Future<List<TaskReport>> getReports({
    String? createdById,
    String? projectId,
    String? milestoneId,
    TaskReportType? type,
    TaskReportStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    bool? includeExpired,
    int? limit,
    int? offset,
  }) async {
    final filters = TaskReportFiltersDto(
      createdById: createdById,
      projectId: projectId,
      milestoneId: milestoneId,
      type: type,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
      includeExpired: includeExpired,
      limit: limit,
      offset: offset,
    );

    return await _repository.getTaskReports(filters);
  }

  /// Obtener un reporte específico
  Future<TaskReport?> getReportById(String id) async {
    return await _repository.getTaskReportById(id);
  }

  /// Actualizar un reporte
  Future<TaskReport> updateReport({
    required String id,
    String? title,
    String? description,
    TaskReportType? type,
    TaskReportStatus? status,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? data,
    DateTime? generatedAt,
    DateTime? expiresAt,
  }) async {
    final dto = UpdateTaskReportDto(
      title: title,
      description: description,
      type: type,
      status: status,
      filters: filters,
      data: data,
      generatedAt: generatedAt,
      expiresAt: expiresAt,
    );

    return await _repository.updateTaskReport(id, dto);
  }

  /// Eliminar un reporte
  Future<void> deleteReport(String id) async {
    await _repository.deleteTaskReport(id);
  }
}
