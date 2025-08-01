import 'package:fct_frontend/features/anteprojects/data/datasources/report_remote_data_source.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/statistics.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  const ReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Report>> getReports({
    String? userId,
    ReportType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _remoteDataSource.getReports(
      userId: userId,
      type: type,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<Report> getReportById(String reportId) async {
    return await _remoteDataSource.getReportById(reportId);
  }

  @override
  Future<Report> createReport({
    required String title,
    required String description,
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    required String userId,
  }) async {
    return await _remoteDataSource.createReport(
      title: title,
      description: description,
      type: type,
      format: format,
      parameters: parameters,
      userId: userId,
    );
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _remoteDataSource.deleteReport(reportId);
  }

  @override
  Future<String> downloadReport(String reportId) async {
    return await _remoteDataSource.downloadReport(reportId);
  }

  @override
  Future<DashboardMetrics> getDashboardMetrics({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _remoteDataSource.getDashboardMetrics(
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<List<Statistics>> getStatistics({
    required List<StatisticsType> types,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    return await _remoteDataSource.getStatistics(
      types: types,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );
  }

  @override
  Future<Map<String, dynamic>> getAnteprojectSummary({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  }) async {
    return await _remoteDataSource.getAnteprojectSummary(
      fromDate: fromDate,
      toDate: toDate,
      tutorId: tutorId,
      studentId: studentId,
    );
  }

  @override
  Future<Map<String, dynamic>> getDefenseSchedule({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  }) async {
    return await _remoteDataSource.getDefenseSchedule(
      fromDate: fromDate,
      toDate: toDate,
      tutorId: tutorId,
      studentId: studentId,
    );
  }

  @override
  Future<Map<String, dynamic>> getEvaluationResults({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  }) async {
    return await _remoteDataSource.getEvaluationResults(
      fromDate: fromDate,
      toDate: toDate,
      tutorId: tutorId,
      studentId: studentId,
    );
  }

  @override
  Future<Map<String, dynamic>> getStudentPerformance({
    required String studentId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _remoteDataSource.getStudentPerformance(
      studentId: studentId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<Map<String, dynamic>> getTutorWorkload({
    required String tutorId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await _remoteDataSource.getTutorWorkload(
      tutorId: tutorId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<String> exportData({
    required String dataType,
    required ReportFormat format,
    required Map<String, dynamic> filters,
  }) async {
    return await _remoteDataSource.exportData(
      dataType: dataType,
      format: format,
      filters: filters,
    );
  }
}
