import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/evaluation_repository.dart';

class SubmitEvaluationUseCase {
  final EvaluationRepository _evaluationRepository;

  const SubmitEvaluationUseCase(this._evaluationRepository);

  Future<Evaluation> call(String evaluationId) async {
    if (evaluationId.isEmpty) {
      throw ArgumentError('El ID de la evaluación no puede estar vacío');
    }

    return await _evaluationRepository.submitEvaluation(evaluationId);
  }
}
