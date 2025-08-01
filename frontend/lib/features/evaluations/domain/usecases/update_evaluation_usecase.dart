import '../repositories/evaluation_repository.dart';
import '../entities/evaluation.dart';

class UpdateEvaluationUseCase {
  final EvaluationRepository repository;

  const UpdateEvaluationUseCase(this.repository);

  Future<Evaluation> call(Evaluation evaluation) async {
    // Validaciones de negocio
    if (evaluation.status != EvaluationStatus.draft) {
      throw ArgumentError('Solo se pueden editar evaluaciones en borrador');
    }

    return await repository.updateEvaluation(evaluation);
  }
} 