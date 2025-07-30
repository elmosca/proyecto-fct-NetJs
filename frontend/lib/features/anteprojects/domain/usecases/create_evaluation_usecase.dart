import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/evaluation_repository.dart';

class CreateEvaluationUseCase {
  final EvaluationRepository _evaluationRepository;

  const CreateEvaluationUseCase(this._evaluationRepository);

  Future<Evaluation> call({
    required String defenseId,
    required String evaluatorId,
    required List<EvaluationScore> scores,
    required String comments,
  }) async {
    // Validaciones de negocio
    if (defenseId.isEmpty) {
      throw ArgumentError('El ID de la defensa no puede estar vacío');
    }
    if (evaluatorId.isEmpty) {
      throw ArgumentError('El ID del evaluador no puede estar vacío');
    }
    if (scores.isEmpty) {
      throw ArgumentError('Debe incluir al menos un criterio de evaluación');
    }
    if (comments.isEmpty) {
      throw ArgumentError('Los comentarios no pueden estar vacíos');
    }

    // Validar que todos los scores estén dentro del rango válido
    for (final score in scores) {
      if (score.score < 0 || score.score > score.maxScore) {
        throw ArgumentError(
          'La puntuación para ${score.criteriaName} debe estar entre 0 y ${score.maxScore}',
        );
      }
    }

    // Calcular puntuación total
    final totalScore = _evaluationRepository.calculateTotalScore(scores);

    // Crear la evaluación
    final evaluation = Evaluation(
      id: '', // Se generará en el backend
      defenseId: defenseId,
      evaluatorId: evaluatorId,
      scores: scores,
      totalScore: totalScore,
      comments: comments,
      status: EvaluationStatus.draft,
      createdAt: DateTime.now(),
    );

    return await _evaluationRepository.createEvaluation(evaluation);
  }
}
