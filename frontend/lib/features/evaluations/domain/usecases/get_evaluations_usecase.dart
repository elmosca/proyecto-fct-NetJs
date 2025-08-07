import '../repositories/evaluation_repository.dart';
import '../entities/evaluation.dart';

class GetEvaluationsUseCase {
  final EvaluationRepository repository;

  const GetEvaluationsUseCase(this.repository);

  Future<List<Evaluation>> call({
    String? anteprojectId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    return await repository.getEvaluations(
      anteprojectId: anteprojectId,
      evaluatorId: evaluatorId,
      status: status,
    );
  }
} 
