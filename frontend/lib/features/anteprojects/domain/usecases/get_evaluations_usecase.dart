import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/evaluation_repository.dart';

class GetEvaluationsUseCase {
  final EvaluationRepository _evaluationRepository;

  const GetEvaluationsUseCase(this._evaluationRepository);

  Future<List<Evaluation>> call({
    String? defenseId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    return await _evaluationRepository.getEvaluations(
      defenseId: defenseId,
      evaluatorId: evaluatorId,
      status: status,
    );
  }
}
