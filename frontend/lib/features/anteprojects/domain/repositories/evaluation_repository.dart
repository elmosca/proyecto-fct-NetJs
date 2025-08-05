import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation_criteria.dart';

abstract class EvaluationRepository {
  /// Obtiene todas las evaluaciones con filtros opcionales
  Future<List<Evaluation>> getEvaluations({
    String? defenseId,
    String? evaluatorId,
    EvaluationStatus? status,
  });

  /// Obtiene una evaluación por su ID
  Future<Evaluation> getEvaluationById(String id);

  /// Obtiene la evaluación de una defensa específica
  Future<Evaluation?> getEvaluationByDefenseId(String defenseId);

  /// Crea una nueva evaluación
  Future<Evaluation> createEvaluation(Evaluation evaluation);

  /// Actualiza una evaluación existente
  Future<Evaluation> updateEvaluation(Evaluation evaluation);

  /// Elimina una evaluación
  Future<void> deleteEvaluation(String id);

  /// Envía una evaluación (cambia estado a submitted)
  Future<Evaluation> submitEvaluation(String id);

  /// Aprueba una evaluación
  Future<Evaluation> approveEvaluation(String id, String? comments);

  /// Rechaza una evaluación
  Future<Evaluation> rejectEvaluation(String id, String reason);

  /// Obtiene los criterios de evaluación
  Future<List<EvaluationCriteria>> getEvaluationCriteria();

  /// Crea un criterio de evaluación
  Future<EvaluationCriteria> createEvaluationCriteria(
      EvaluationCriteria criteria);

  /// Actualiza un criterio de evaluación
  Future<EvaluationCriteria> updateEvaluationCriteria(
      EvaluationCriteria criteria);

  /// Elimina un criterio de evaluación
  Future<void> deleteEvaluationCriteria(String id);

  /// Calcula la puntuación total basada en los criterios y pesos
  double calculateTotalScore(List<EvaluationScore> scores);

  /// Obtiene las evaluaciones de un evaluador específico
  Future<List<Evaluation>> getEvaluatorEvaluations(String evaluatorId);

  /// Obtiene estadísticas de evaluaciones
  Future<EvaluationStatistics> getEvaluationStatistics({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// Estadísticas de evaluaciones
class EvaluationStatistics {
  final int totalEvaluations;
  final int completedEvaluations;
  final int pendingEvaluations;
  final double averageScore;
  final Map<EvaluationStatus, int> statusDistribution;
  final Map<String, double> criteriaAverages;

  const EvaluationStatistics({
    required this.totalEvaluations,
    required this.completedEvaluations,
    required this.pendingEvaluations,
    required this.averageScore,
    required this.statusDistribution,
    required this.criteriaAverages,
  });
}
