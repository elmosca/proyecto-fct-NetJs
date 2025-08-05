import 'package:dio/dio.dart';

import '../../domain/entities/evaluation.dart';
import '../../domain/entities/evaluation_criteria.dart';
import '../../domain/entities/evaluation_result.dart';
import '../../domain/repositories/evaluation_repository.dart';

abstract class EvaluationRemoteDataSource {
  Future<List<Evaluation>> getEvaluations({
    String? anteprojectId,
    String? evaluatorId,
    EvaluationStatus? status,
  });

  Future<Evaluation?> getEvaluationById(String id);
  Future<Evaluation?> getEvaluationByAnteprojectId(String anteprojectId);
  Future<Evaluation> createEvaluation(Evaluation evaluation);
  Future<Evaluation> updateEvaluation(Evaluation evaluation);
  Future<void> deleteEvaluation(String id);
  Future<Evaluation> submitEvaluation(String id);
  Future<Evaluation> approveEvaluation(String id, String? comments);
  Future<Evaluation> rejectEvaluation(String id, String reason);
  Future<List<EvaluationCriteria>> getEvaluationCriteria();
  Future<EvaluationCriteria> createEvaluationCriteria(
      EvaluationCriteria criteria);
  Future<EvaluationCriteria> updateEvaluationCriteria(
      EvaluationCriteria criteria);
  Future<void> deleteEvaluationCriteria(String id);
  Future<List<Evaluation>> getEvaluatorEvaluations(String evaluatorId);
  Future<EvaluationStatistics> getEvaluationStatistics({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<EvaluationResult> calculateEvaluationResult(String evaluationId);
}

class EvaluationRemoteDataSourceImpl implements EvaluationRemoteDataSource {
  final Dio _dio;

  const EvaluationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Evaluation>> getEvaluations({
    String? anteprojectId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (anteprojectId != null) queryParameters['anteprojectId'] = anteprojectId;
    if (evaluatorId != null) queryParameters['evaluatorId'] = evaluatorId;
    if (status != null) queryParameters['status'] = status.name;

    final response =
        await _dio.get('/evaluations', queryParameters: queryParameters);
    final List<dynamic> data = response.data;
    return data.map((json) => Evaluation.fromJson(json)).toList();
  }

  @override
  Future<Evaluation?> getEvaluationById(String id) async {
    try {
      final response = await _dio.get('/evaluations/$id');
      return Evaluation.fromJson(response.data);
    } catch (e) {
      if (e.toString().contains('404')) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<Evaluation?> getEvaluationByAnteprojectId(String anteprojectId) async {
    try {
      final response =
          await _dio.get('/evaluations/anteproject/$anteprojectId');
      return Evaluation.fromJson(response.data);
    } catch (e) {
      if (e.toString().contains('404')) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<Evaluation> createEvaluation(Evaluation evaluation) async {
    final response = await _dio.post('/evaluations', data: evaluation.toJson());
    return Evaluation.fromJson(response.data);
  }

  @override
  Future<Evaluation> updateEvaluation(Evaluation evaluation) async {
    final response = await _dio.put('/evaluations/${evaluation.id}',
        data: evaluation.toJson());
    return Evaluation.fromJson(response.data);
  }

  @override
  Future<void> deleteEvaluation(String id) async {
    await _dio.delete('/evaluations/$id');
  }

  @override
  Future<Evaluation> submitEvaluation(String id) async {
    final response = await _dio.post('/evaluations/$id/submit');
    return Evaluation.fromJson(response.data);
  }

  @override
  Future<Evaluation> approveEvaluation(String id, String? comments) async {
    final data = <String, dynamic>{};
    if (comments != null) data['comments'] = comments;

    final response = await _dio.post('/evaluations/$id/approve', data: data);
    return Evaluation.fromJson(response.data);
  }

  @override
  Future<Evaluation> rejectEvaluation(String id, String reason) async {
    final response =
        await _dio.post('/evaluations/$id/reject', data: {'reason': reason});
    return Evaluation.fromJson(response.data);
  }

  @override
  Future<List<EvaluationCriteria>> getEvaluationCriteria() async {
    final response = await _dio.get('/evaluations/criteria');
    final List<dynamic> data = response.data;
    return data.map((json) => EvaluationCriteria.fromJson(json)).toList();
  }

  @override
  Future<EvaluationCriteria> createEvaluationCriteria(
      EvaluationCriteria criteria) async {
    final response =
        await _dio.post('/evaluations/criteria', data: criteria.toJson());
    return EvaluationCriteria.fromJson(response.data);
  }

  @override
  Future<EvaluationCriteria> updateEvaluationCriteria(
      EvaluationCriteria criteria) async {
    final response = await _dio.put('/evaluations/criteria/${criteria.id}',
        data: criteria.toJson());
    return EvaluationCriteria.fromJson(response.data);
  }

  @override
  Future<void> deleteEvaluationCriteria(String id) async {
    await _dio.delete('/evaluations/criteria/$id');
  }

  @override
  Future<List<Evaluation>> getEvaluatorEvaluations(String evaluatorId) async {
    final response = await _dio.get('/evaluations/evaluator/$evaluatorId');
    final List<dynamic> data = response.data;
    return data.map((json) => Evaluation.fromJson(json)).toList();
  }

  @override
  Future<EvaluationStatistics> getEvaluationStatistics({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (evaluatorId != null) queryParameters['evaluatorId'] = evaluatorId;
    if (startDate != null)
      queryParameters['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParameters['endDate'] = endDate.toIso8601String();

    final response = await _dio.get('/evaluations/statistics',
        queryParameters: queryParameters);
    final data = response.data;

    return EvaluationStatistics(
      totalEvaluations: data['totalEvaluations'],
      draftEvaluations: data['draftEvaluations'],
      submittedEvaluations: data['submittedEvaluations'],
      approvedEvaluations: data['approvedEvaluations'],
      rejectedEvaluations: data['rejectedEvaluations'],
      averageScore: data['averageScore'].toDouble(),
      gradeDistribution:
          Map<EvaluationGrade, int>.from(data['gradeDistribution']),
      monthlyStats: (data['monthlyStats'] as List)
          .map((item) => MonthlyStats(
                month: item['month'],
                evaluations: item['evaluations'],
                averageScore: item['averageScore'].toDouble(),
              ))
          .toList(),
    );
  }

  @override
  Future<EvaluationResult> calculateEvaluationResult(
      String evaluationId) async {
    final response = await _dio.post('/evaluations/$evaluationId/calculate');
    return EvaluationResult.fromJson(response.data);
  }
}
