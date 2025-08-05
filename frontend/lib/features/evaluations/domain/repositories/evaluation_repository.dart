import '../entities/evaluation.dart';
import '../entities/evaluation_criteria.dart';
import '../entities/evaluation_result.dart';

abstract class EvaluationRepository {
  // Evaluaciones
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
  
  // Criterios de evaluación
  Future<List<EvaluationCriteria>> getEvaluationCriteria();
  Future<EvaluationCriteria> createEvaluationCriteria(EvaluationCriteria criteria);
  Future<EvaluationCriteria> updateEvaluationCriteria(EvaluationCriteria criteria);
  Future<void> deleteEvaluationCriteria(String id);
  
  // Resultados y estadísticas
  Future<List<Evaluation>> getEvaluatorEvaluations(String evaluatorId);
  Future<EvaluationStatistics> getEvaluationStatistics({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  Future<EvaluationResult> calculateEvaluationResult(String evaluationId);
}

class EvaluationStatistics {
  final int totalEvaluations;
  final int draftEvaluations;
  final int submittedEvaluations;
  final int approvedEvaluations;
  final int rejectedEvaluations;
  final double averageScore;
  final Map<EvaluationGrade, int> gradeDistribution;
  final List<MonthlyStats> monthlyStats;

  const EvaluationStatistics({
    required this.totalEvaluations,
    required this.draftEvaluations,
    required this.submittedEvaluations,
    required this.approvedEvaluations,
    required this.rejectedEvaluations,
    required this.averageScore,
    required this.gradeDistribution,
    required this.monthlyStats,
  });
}

class MonthlyStats {
  final String month;
  final int evaluations;
  final double averageScore;

  const MonthlyStats({
    required this.month,
    required this.evaluations,
    required this.averageScore,
  });
} 