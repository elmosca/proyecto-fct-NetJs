import 'package:dio/dio.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/statistics.dart';

abstract class ReportRemoteDataSource {
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

  Future<String> exportData({
    required String dataType,
    required ReportFormat format,
    required Map<String, dynamic> filters,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio _dio;

  const ReportRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Report>> getReports({
    String? userId,
    ReportType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (userId != null) queryParameters['userId'] = userId;
      if (type != null) queryParameters['type'] = type.name;
      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();

      final response =
          await _dio.get('/reports', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'];
      return data.map((json) => Report.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Report> getReportById(String reportId) async {
    try {
      final response = await _dio.get('/reports/$reportId');
      return Report.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
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
    try {
      final response = await _dio.post('/reports', data: {
        'title': title,
        'description': description,
        'type': type.name,
        'format': format.name,
        'parameters': parameters,
        'userId': userId,
      });

      return Report.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    try {
      await _dio.delete('/reports/$reportId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> downloadReport(String reportId) async {
    try {
      final response = await _dio.get('/reports/$reportId/download');
      return response.data['downloadUrl'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<DashboardMetrics> getDashboardMetrics({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();

      final response = await _dio.get('/reports/dashboard-metrics',
          queryParameters: queryParameters);

      return DashboardMetrics.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<Statistics>> getStatistics({
    required List<StatisticsType> types,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    try {
      final response = await _dio.post('/reports/statistics', data: {
        'types': types.map((type) => type.name).toList(),
        'periodStart': periodStart.toIso8601String(),
        'periodEnd': periodEnd.toIso8601String(),
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => Statistics.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getAnteprojectSummary({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();
      if (tutorId != null) queryParameters['tutorId'] = tutorId;
      if (studentId != null) queryParameters['studentId'] = studentId;

      final response = await _dio.get('/reports/anteproject-summary',
          queryParameters: queryParameters);

      return response.data['data'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getDefenseSchedule({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();
      if (tutorId != null) queryParameters['tutorId'] = tutorId;
      if (studentId != null) queryParameters['studentId'] = studentId;

      final response = await _dio.get('/reports/defense-schedule',
          queryParameters: queryParameters);

      return response.data['data'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getEvaluationResults({
    DateTime? fromDate,
    DateTime? toDate,
    String? tutorId,
    String? studentId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();
      if (tutorId != null) queryParameters['tutorId'] = tutorId;
      if (studentId != null) queryParameters['studentId'] = studentId;

      final response = await _dio.get('/reports/evaluation-results',
          queryParameters: queryParameters);

      return response.data['data'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getStudentPerformance({
    required String studentId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'studentId': studentId,
      };

      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();

      final response = await _dio.get('/reports/student-performance',
          queryParameters: queryParameters);

      return response.data['data'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getTutorWorkload({
    required String tutorId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'tutorId': tutorId,
      };

      if (fromDate != null)
        queryParameters['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParameters['toDate'] = toDate.toIso8601String();

      final response = await _dio.get('/reports/tutor-workload',
          queryParameters: queryParameters);

      return response.data['data'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> exportData({
    required String dataType,
    required ReportFormat format,
    required Map<String, dynamic> filters,
  }) async {
    try {
      final response = await _dio.post('/reports/export', data: {
        'dataType': dataType,
        'format': format.name,
        'filters': filters,
      });

      return response.data['downloadUrl'];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Error de conexión: Tiempo de espera agotado');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'Error del servidor';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Solicitud cancelada');
      default:
        return Exception('Error de red: ${e.message}');
    }
  }
}
