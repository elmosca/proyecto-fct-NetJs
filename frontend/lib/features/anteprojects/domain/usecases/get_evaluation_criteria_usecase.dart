import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation_criteria.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/evaluation_repository.dart';

class GetEvaluationCriteriaUseCase {
  final EvaluationRepository _evaluationRepository;

  const GetEvaluationCriteriaUseCase(this._evaluationRepository);

  Future<List<EvaluationCriteria>> call() async {
    return await _evaluationRepository.getEvaluationCriteria();
  }
}
