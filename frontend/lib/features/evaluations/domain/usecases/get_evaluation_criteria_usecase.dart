import '../repositories/evaluation_repository.dart';
import '../entities/evaluation_criteria.dart';

class GetEvaluationCriteriaUseCase {
  final EvaluationRepository repository;

  const GetEvaluationCriteriaUseCase(this.repository);

  Future<List<EvaluationCriteria>> call() async {
    return await repository.getEvaluationCriteria();
  }
} 