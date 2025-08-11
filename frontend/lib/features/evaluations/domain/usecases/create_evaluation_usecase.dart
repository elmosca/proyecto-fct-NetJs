import '../repositories/evaluation_repository.dart';
import '../entities/evaluation.dart';

class CreateEvaluationUseCase {
  final EvaluationRepository repository;

  const CreateEvaluationUseCase(this.repository);

  Future<Evaluation> call(Evaluation evaluation) async {
    // Validaciones de negocio
    if (evaluation.scores.isEmpty) {
      throw ArgumentError('La evaluación debe tener al menos un criterio');
    }

    if (evaluation.totalScore < 0) {
      throw ArgumentError('La puntuación total no puede ser negativa');
    }

    // Verificar que todos los scores estén dentro del rango válido
    for (final score in evaluation.scores) {
      if (score.score < 0 || score.score > score.maxScore) {
        throw ArgumentError(
          'La puntuación del criterio ${score.criteriaName} debe estar entre 0 y ${score.maxScore}',
        );
      }
    }

    return await repository.createEvaluation(evaluation);
  }
} 
