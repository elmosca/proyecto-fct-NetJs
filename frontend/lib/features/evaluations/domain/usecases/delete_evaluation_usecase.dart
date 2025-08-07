import '../repositories/evaluation_repository.dart';

class DeleteEvaluationUseCase {
  final EvaluationRepository repository;

  const DeleteEvaluationUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteEvaluation(id);
  }
} 
