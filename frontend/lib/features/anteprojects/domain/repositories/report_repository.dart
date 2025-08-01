import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/statistics.dart';

abstract class ReportRepository {
  // Métodos para reportes
  Future<List<Report>> getReports({
    String? userId,
    ReportType? type,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<Report> getReportById(String reportId);

  Future<Report> createReport({
    required String title,
    required String description,
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    required String userId,
  });

  Future<void> deleteReport(String reportId);

  Future<String> downloadReport(String reportId);

  // Métodos para estadísticas
  Future<DashboardMetrics> getDashboardMetrics({
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<List<Statistics>> getStatistics({
    required List<StatisticsType> types,
    required DateTime periodStart,
    required DateTime periodEnd,
  });

  Future<Map<String, dynamic>> getAnteprojectSummary({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  });

  Future<Map<String, dynamic>> getDefenseSchedule({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  });

  Future<Map<String, dynamic>> getEvaluationResults({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  });

  Future<Map<String, dynamic>> getStudentPerformance({
    required String studentId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<Map<String, dynamic>> getTutorWorkload({
    required String tutorId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  // Métodos para exportación
  Future<String> exportData({
    required String dataType,
    required ReportFormat format,
    required Map<String, dynamic> filters,
  });
}
