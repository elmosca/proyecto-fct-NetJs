import 'package:fct_frontend/features/tasks/domain/entities/task_report_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_report_entity.dart';

abstract class TaskReportRepository {
  /// Obtener reportes con filtros opcionales
  Future<List<TaskReport>> getTaskReports(TaskReportFiltersDto filters);

  /// Obtener un reporte por ID
  Future<TaskReport?> getTaskReportById(String id);

  /// Crear un nuevo reporte
  Future<TaskReport> createTaskReport(CreateTaskReportDto dto);

  /// Actualizar un reporte existente
  Future<TaskReport> updateTaskReport(String id, UpdateTaskReportDto dto);

  /// Eliminar un reporte
  Future<void> deleteTaskReport(String id);

  /// Generar reporte de resumen de estados
  Future<TaskReport> generateStatusSummaryReport({
    String? projectId,
    String? milestoneId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Generar reporte de progreso por usuario
  Future<TaskReport> generateProgressByUserReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Generar reporte de progreso por proyecto
  Future<TaskReport> generateProgressByProjectReport({
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Generar reporte de tareas vencidas
  Future<TaskReport> generateOverdueSummaryReport({
    String? projectId,
    String? userId,
  });

  /// Generar reporte de tendencias de completado
  Future<TaskReport> generateCompletionTrendsReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
    String? period,
  });

  /// Generar reporte de distribución de prioridades
  Future<TaskReport> generatePriorityDistributionReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Generar reporte de análisis de complejidad
  Future<TaskReport> generateComplexityAnalysisReport({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Generar reporte de análisis de dependencias
  Future<TaskReport> generateDependencyAnalysisReport({
    String? projectId,
    String? taskId,
  });

  /// Generar reporte de análisis de tiempo
  Future<TaskReport> generateTimeAnalysisReport({
    String? projectId,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Exportar reporte
  Future<TaskReportDataDto> exportReport(TaskReportExportDto dto);

  /// Programar reporte
  Future<TaskReportScheduleDto> scheduleReport(
      String reportId, String schedule);

  /// Cancelar reporte programado
  Future<void> cancelScheduledReport(String reportId);

  /// Obtener reportes programados
  Future<List<TaskReportScheduleDto>> getScheduledReports();

  /// Obtener reportes expirados
  Future<List<TaskReport>> getExpiredReports();

  /// Limpiar reportes expirados
  Future<void> cleanupExpiredReports();

  /// Obtener estadísticas de reportes
  Future<Map<String, dynamic>> getReportStatistics({
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
  });
}
