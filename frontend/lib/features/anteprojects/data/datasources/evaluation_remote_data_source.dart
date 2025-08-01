import 'package:dio/dio.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation_criteria.dart';

abstract class EvaluationRemoteDataSource {
  Future<List<Evaluation>> getEvaluations({
    String? defenseId,
    String? evaluatorId,
    EvaluationStatus? status,
  });

  Future<Evaluation> getEvaluationById(String id);
  Future<Evaluation?> getEvaluationByDefenseId(String defenseId);
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
}

class EvaluationRemoteDataSourceImpl implements EvaluationRemoteDataSource {
  final Dio _dio;

  const EvaluationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Evaluation>> getEvaluations({
    String? defenseId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (defenseId != null) queryParameters['defenseId'] = defenseId;
    if (evaluatorId != null) queryParameters['evaluatorId'] = evaluatorId;
    if (status != null) queryParameters['status'] = status.name;

    final response =
        await _dio.get('/evaluations', queryParameters: queryParameters);
    final List<dynamic> data = response.data;
    return data.map((json) => Evaluation.fromJson(json)).toList();
  }

  @override
  Future<Evaluation> getEvaluationById(String id) async {
    final response = await _dio.get('/evaluations/$id');
    return Evaluation.fromJson(response.data);
  }

  @override
  Future<Evaluation?> getEvaluationByDefenseId(String defenseId) async {
    try {
      final response = await _dio.get('/evaluations/defense/$defenseId');
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
    final data = {'reason': reason};
    final response = await _dio.post('/evaluations/$id/reject', data: data);
    return Evaluation.fromJson(response.data);
  }

  @override
  Future<List<EvaluationCriteria>> getEvaluationCriteria() async {
    final response = await _dio.get('/evaluation-criteria');
    final List<dynamic> data = response.data;
    return data.map((json) => EvaluationCriteria.fromJson(json)).toList();
  }

  @override
  Future<EvaluationCriteria> createEvaluationCriteria(
      EvaluationCriteria criteria) async {
    final response =
        await _dio.post('/evaluation-criteria', data: criteria.toJson());
    return EvaluationCriteria.fromJson(response.data);
  }

  @override
  Future<EvaluationCriteria> updateEvaluationCriteria(
      EvaluationCriteria criteria) async {
    final response = await _dio.put('/evaluation-criteria/${criteria.id}',
        data: criteria.toJson());
    return EvaluationCriteria.fromJson(response.data);
  }

  @override
  Future<void> deleteEvaluationCriteria(String id) async {
    await _dio.delete('/evaluation-criteria/$id');
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
      completedEvaluations: data['completedEvaluations'],
      pendingEvaluations: data['pendingEvaluations'],
      averageScore: data['averageScore'].toDouble(),
      statusDistribution: Map<EvaluationStatus, int>.from(
        data['statusDistribution'].map((key, value) => MapEntry(
              EvaluationStatus.values.firstWhere((e) => e.name == key),
              value,
            )),
      ),
      criteriaAverages: Map<String, double>.from(
        data['criteriaAverages']
            .map((key, value) => MapEntry(key, value.toDouble())),
      ),
    );
  }
}
