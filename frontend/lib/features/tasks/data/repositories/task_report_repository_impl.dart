import '../../domain/entities/task_report_dto.dart';
import '../../domain/entities/task_report_entity.dart';
import '../../domain/repositories/task_report_repository.dart';
import '../datasources/task_report_remote_datasource.dart';

class TaskReportRepositoryImpl implements TaskReportRepository {
  final TaskReportRemoteDataSource _remoteDataSource;

  TaskReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<TaskReport>> getTaskReports(TaskReportFiltersDto filters) async {
    return await _remoteDataSource.getReports(filters);
  }

  @override
  Future<TaskReport?> getTaskReportById(String id) async {
    return await _remoteDataSource.getReportById(id);
  }

  @override
  Future<TaskReport> createTaskReport(CreateTaskReportDto dto) async {
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> updateTaskReport(
      String id, UpdateTaskReportDto dto) async {
    return await _remoteDataSource.updateReport(id, dto);
  }

  @override
  Future<void> deleteTaskReport(String id) async {
    await _remoteDataSource.deleteReport(id);
  }

  @override
  Future<TaskReport> generateStatusSummaryReport({
    String? projectId,
    String? milestoneId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Resumen de Estados',
      description: 'Reporte de resumen de estados de tareas',
      type: TaskReportType.taskStatusSummary,
      projectId: projectId,
      milestoneId: milestoneId,
      filters: {
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generateProgressByUserReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Progreso por Usuario',
      description: 'Reporte de progreso de tareas por usuario',
      type: TaskReportType.taskProgressByUser,
      projectId: projectId,
      filters: {
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generateProgressByProjectReport({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Progreso por Proyecto',
      description: 'Reporte de progreso de tareas por proyecto',
      type: TaskReportType.taskProgressByProject,
      filters: {
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generateOverdueSummaryReport({
    String? projectId,
    String? userId,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Resumen de Tareas Vencidas',
      description: 'Reporte de tareas vencidas',
      type: TaskReportType.taskOverdueSummary,
      projectId: projectId,
      filters: {
        if (userId != null) 'userId': userId,
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generateCompletionTrendsReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
    String? period,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Tendencias de Completado',
      description: 'Reporte de tendencias de completado de tareas',
      type: TaskReportType.taskCompletionTrends,
      projectId: projectId,
      filters: {
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
        if (period != null) 'period': period,
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generatePriorityDistributionReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Distribución de Prioridades',
      description: 'Reporte de distribución de prioridades de tareas',
      type: TaskReportType.taskPriorityDistribution,
      projectId: projectId,
      filters: {
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generateComplexityAnalysisReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Análisis de Complejidad',
      description: 'Reporte de análisis de complejidad de tareas',
      type: TaskReportType.taskComplexityAnalysis,
      projectId: projectId,
      filters: {
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generateDependencyAnalysisReport({
    String? projectId,
    String? taskId,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Análisis de Dependencias',
      description: 'Reporte de análisis de dependencias entre tareas',
      type: TaskReportType.taskDependencyAnalysis,
      projectId: projectId,
      filters: {
        if (taskId != null) 'taskId': taskId,
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReport> generateTimeAnalysisReport({
    String? projectId,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final dto = CreateTaskReportDto(
      title: 'Análisis de Tiempo',
      description: 'Reporte de análisis de tiempo de tareas',
      type: TaskReportType.taskTimeAnalysis,
      projectId: projectId,
      filters: {
        if (userId != null) 'userId': userId,
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      },
    );
    return await _remoteDataSource.generateReport(dto);
  }

  @override
  Future<TaskReportDataDto> exportReport(TaskReportExportDto dto) async {
    final downloadUrl = await _remoteDataSource.exportReport(dto.reportId, dto);
    return TaskReportDataDto(
      reportId: dto.reportId,
      data: {'downloadUrl': downloadUrl},
      format: dto.format,
      generatedAt: DateTime.now(),
    );
  }

  @override
  Future<TaskReportScheduleDto> scheduleReport(
      String reportId, String schedule) async {
    final scheduleDto = TaskReportScheduleDto(
      reportId: reportId,
      schedule: schedule,
      nextRun: DateTime.now()
          .add(const Duration(days: 1)), // Ejemplo: próxima ejecución en 1 día
      isActive: true,
    );
    await _remoteDataSource.scheduleReport(reportId, scheduleDto);
    return scheduleDto;
  }

  @override
  Future<void> cancelScheduledReport(String reportId) async {
    await _remoteDataSource.cancelScheduledReport(reportId);
  }

  @override
  Future<List<TaskReportScheduleDto>> getScheduledReports() async {
    final reports = await _remoteDataSource.getScheduledReports();
    return reports
        .map((report) => TaskReportScheduleDto(
              reportId: report.id,
              schedule: 'daily', // Valor por defecto
              nextRun: report.generatedAt ?? DateTime.now(),
              isActive: report.status == TaskReportStatus.pending,
            ))
        .toList();
  }

  @override
  Future<List<TaskReport>> getExpiredReports() async {
    return await _remoteDataSource.getExpiredReports();
  }

  @override
  Future<void> cleanupExpiredReports() async {
    await _remoteDataSource.cleanupExpiredReports();
  }

  @override
  Future<Map<String, dynamic>> getReportStatistics({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final stats = await _remoteDataSource.getReportStatistics();
    // Filtrar por parámetros si se proporcionan
    if (projectId != null || fromDate != null || toDate != null) {
      // Aquí se podría implementar filtrado adicional si es necesario
    }
    return stats;
  }
}
