import 'package:fct_frontend/features/anteprojects/data/datasources/evaluation_remote_data_source.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation_criteria.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/evaluation_repository.dart';

class EvaluationRepositoryImpl implements EvaluationRepository {
  final EvaluationRemoteDataSource _remoteDataSource;

  const EvaluationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Evaluation>> getEvaluations({
    String? defenseId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    return await _remoteDataSource.getEvaluations(
      defenseId: defenseId,
      evaluatorId: evaluatorId,
      status: status,
    );
  }

  @override
  Future<Evaluation> getEvaluationById(String id) async {
    return await _remoteDataSource.getEvaluationById(id);
  }

  @override
  Future<Evaluation?> getEvaluationByDefenseId(String defenseId) async {
    return await _remoteDataSource.getEvaluationByDefenseId(defenseId);
  }

  @override
  Future<Evaluation> createEvaluation(Evaluation evaluation) async {
    return await _remoteDataSource.createEvaluation(evaluation);
  }

  @override
  Future<Evaluation> updateEvaluation(Evaluation evaluation) async {
    return await _remoteDataSource.updateEvaluation(evaluation);
  }

  @override
  Future<void> deleteEvaluation(String id) async {
    await _remoteDataSource.deleteEvaluation(id);
  }

  @override
  Future<Evaluation> submitEvaluation(String id) async {
    return await _remoteDataSource.submitEvaluation(id);
  }

  @override
  Future<Evaluation> approveEvaluation(String id, String? comments) async {
    return await _remoteDataSource.approveEvaluation(id, comments);
  }

  @override
  Future<Evaluation> rejectEvaluation(String id, String reason) async {
    return await _remoteDataSource.rejectEvaluation(id, reason);
  }

  @override
  Future<List<EvaluationCriteria>> getEvaluationCriteria() async {
    return await _remoteDataSource.getEvaluationCriteria();
  }

  @override
  Future<EvaluationCriteria> createEvaluationCriteria(
      EvaluationCriteria criteria) async {
    return await _remoteDataSource.createEvaluationCriteria(criteria);
  }

  @override
  Future<EvaluationCriteria> updateEvaluationCriteria(
      EvaluationCriteria criteria) async {
    return await _remoteDataSource.updateEvaluationCriteria(criteria);
  }

  @override
  Future<void> deleteEvaluationCriteria(String id) async {
    await _remoteDataSource.deleteEvaluationCriteria(id);
  }

  @override
  double calculateTotalScore(List<EvaluationScore> scores) {
    if (scores.isEmpty) return 0.0;

    double totalWeightedScore = 0.0;
    double totalWeight = 0.0;

    for (final score in scores) {
      final weightedScore = (score.score / score.maxScore) * score.weight;
      totalWeightedScore += weightedScore;
      totalWeight += score.weight;
    }

    if (totalWeight == 0) return 0.0;

    // Normalizar a una escala de 0-10
    return (totalWeightedScore / totalWeight) * 10;
  }

  @override
  Future<List<Evaluation>> getEvaluatorEvaluations(String evaluatorId) async {
    return await _remoteDataSource.getEvaluatorEvaluations(evaluatorId);
  }

  @override
  Future<EvaluationStatistics> getEvaluationStatistics({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final stats = await _remoteDataSource.getEvaluationStatistics(
      evaluatorId: evaluatorId,
      startDate: startDate,
      endDate: endDate,
    );

    // Convertir de evaluations.EvaluationStatistics a EvaluationStatistics
    return EvaluationStatistics(
      totalEvaluations: stats.totalEvaluations,
      completedEvaluations:
          stats.approvedEvaluations + stats.rejectedEvaluations,
      pendingEvaluations: stats.draftEvaluations + stats.submittedEvaluations,
      averageScore: stats.averageScore,
      statusDistribution: {
        EvaluationStatus.draft: stats.draftEvaluations,
        EvaluationStatus.submitted: stats.submittedEvaluations,
        EvaluationStatus.approved: stats.approvedEvaluations,
        EvaluationStatus.rejected: stats.rejectedEvaluations,
      },
      criteriaAverages: {}, // No disponible en la versión de evaluations
    );
  }
}
