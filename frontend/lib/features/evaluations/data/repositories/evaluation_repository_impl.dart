import '../../domain/entities/evaluation.dart';
import '../../domain/entities/evaluation_criteria.dart';
import '../../domain/entities/evaluation_result.dart';
import '../../domain/repositories/evaluation_repository.dart';
import '../datasources/evaluation_local_data_source.dart';
import '../datasources/evaluation_remote_data_source.dart';

class EvaluationRepositoryImpl implements EvaluationRepository {
  final EvaluationRemoteDataSource _remoteDataSource;
  final EvaluationLocalDataSource _localDataSource;

  const EvaluationRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Evaluation>> getEvaluations({
    String? anteprojectId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    try {
      final evaluations = await _remoteDataSource.getEvaluations(
        anteprojectId: anteprojectId,
        evaluatorId: evaluatorId,
        status: status,
      );

      // Cache las evaluaciones para uso offline
      await _localDataSource.cacheEvaluations(evaluations);
      return evaluations;
    } catch (e) {
      // Si falla la red, intentar usar cache local
      final cachedEvaluations = await _localDataSource.getCachedEvaluations();
      if (cachedEvaluations.isNotEmpty) {
        return cachedEvaluations;
      }
      rethrow;
    }
  }

  @override
  Future<Evaluation?> getEvaluationById(String id) async {
    try {
      return await _remoteDataSource.getEvaluationById(id);
    } catch (e) {
      // Buscar en cache local
      final cachedEvaluations = await _localDataSource.getCachedEvaluations();
      try {
        return cachedEvaluations.firstWhere((e) => e.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<Evaluation?> getEvaluationByAnteprojectId(String anteprojectId) async {
    try {
      return await _remoteDataSource
          .getEvaluationByAnteprojectId(anteprojectId);
    } catch (e) {
      // Buscar en cache local
      final cachedEvaluations = await _localDataSource.getCachedEvaluations();
      try {
        return cachedEvaluations
            .firstWhere((e) => e.anteprojectId == anteprojectId);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<Evaluation> createEvaluation(Evaluation evaluation) async {
    final createdEvaluation =
        await _remoteDataSource.createEvaluation(evaluation);

    // Actualizar cache local
    final cachedEvaluations = await _localDataSource.getCachedEvaluations();
    cachedEvaluations.add(createdEvaluation);
    await _localDataSource.cacheEvaluations(cachedEvaluations);

    return createdEvaluation;
  }

  @override
  Future<Evaluation> updateEvaluation(Evaluation evaluation) async {
    final updatedEvaluation =
        await _remoteDataSource.updateEvaluation(evaluation);

    // Actualizar cache local
    final cachedEvaluations = await _localDataSource.getCachedEvaluations();
    final index = cachedEvaluations.indexWhere((e) => e.id == evaluation.id);
    if (index != -1) {
      cachedEvaluations[index] = updatedEvaluation;
      await _localDataSource.cacheEvaluations(cachedEvaluations);
    }

    return updatedEvaluation;
  }

  @override
  Future<void> deleteEvaluation(String id) async {
    await _remoteDataSource.deleteEvaluation(id);

    // Actualizar cache local
    final cachedEvaluations = await _localDataSource.getCachedEvaluations();
    cachedEvaluations.removeWhere((e) => e.id == id);
    await _localDataSource.cacheEvaluations(cachedEvaluations);
  }

  @override
  Future<Evaluation> submitEvaluation(String id) async {
    final submittedEvaluation = await _remoteDataSource.submitEvaluation(id);

    // Actualizar cache local
    final cachedEvaluations = await _localDataSource.getCachedEvaluations();
    final index = cachedEvaluations.indexWhere((e) => e.id == id);
    if (index != -1) {
      cachedEvaluations[index] = submittedEvaluation;
      await _localDataSource.cacheEvaluations(cachedEvaluations);
    }

    return submittedEvaluation;
  }

  @override
  Future<Evaluation> approveEvaluation(String id, String? comments) async {
    final approvedEvaluation =
        await _remoteDataSource.approveEvaluation(id, comments);

    // Actualizar cache local
    final cachedEvaluations = await _localDataSource.getCachedEvaluations();
    final index = cachedEvaluations.indexWhere((e) => e.id == id);
    if (index != -1) {
      cachedEvaluations[index] = approvedEvaluation;
      await _localDataSource.cacheEvaluations(cachedEvaluations);
    }

    return approvedEvaluation;
  }

  @override
  Future<Evaluation> rejectEvaluation(String id, String reason) async {
    final rejectedEvaluation =
        await _remoteDataSource.rejectEvaluation(id, reason);

    // Actualizar cache local
    final cachedEvaluations = await _localDataSource.getCachedEvaluations();
    final index = cachedEvaluations.indexWhere((e) => e.id == id);
    if (index != -1) {
      cachedEvaluations[index] = rejectedEvaluation;
      await _localDataSource.cacheEvaluations(cachedEvaluations);
    }

    return rejectedEvaluation;
  }

  @override
  Future<List<EvaluationCriteria>> getEvaluationCriteria() async {
    try {
      final criteria = await _remoteDataSource.getEvaluationCriteria();

      // Cache los criterios para uso offline
      await _localDataSource.cacheEvaluationCriteria(criteria);
      return criteria;
    } catch (e) {
      // Si falla la red, intentar usar cache local
      final cachedCriteria =
          await _localDataSource.getCachedEvaluationCriteria();
      if (cachedCriteria.isNotEmpty) {
        return cachedCriteria;
      }
      rethrow;
    }
  }

  @override
  Future<EvaluationCriteria> createEvaluationCriteria(
      EvaluationCriteria criteria) async {
    final createdCriteria =
        await _remoteDataSource.createEvaluationCriteria(criteria);

    // Actualizar cache local
    final cachedCriteria = await _localDataSource.getCachedEvaluationCriteria();
    cachedCriteria.add(createdCriteria);
    await _localDataSource.cacheEvaluationCriteria(cachedCriteria);

    return createdCriteria;
  }

  @override
  Future<EvaluationCriteria> updateEvaluationCriteria(
      EvaluationCriteria criteria) async {
    final updatedCriteria =
        await _remoteDataSource.updateEvaluationCriteria(criteria);

    // Actualizar cache local
    final cachedCriteria = await _localDataSource.getCachedEvaluationCriteria();
    final index = cachedCriteria.indexWhere((c) => c.id == criteria.id);
    if (index != -1) {
      cachedCriteria[index] = updatedCriteria;
      await _localDataSource.cacheEvaluationCriteria(cachedCriteria);
    }

    return updatedCriteria;
  }

  @override
  Future<void> deleteEvaluationCriteria(String id) async {
    await _remoteDataSource.deleteEvaluationCriteria(id);

    // Actualizar cache local
    final cachedCriteria = await _localDataSource.getCachedEvaluationCriteria();
    cachedCriteria.removeWhere((c) => c.id == id);
    await _localDataSource.cacheEvaluationCriteria(cachedCriteria);
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
    return await _remoteDataSource.getEvaluationStatistics(
      evaluatorId: evaluatorId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<EvaluationResult> calculateEvaluationResult(
      String evaluationId) async {
    return await _remoteDataSource.calculateEvaluationResult(evaluationId);
  }
}
