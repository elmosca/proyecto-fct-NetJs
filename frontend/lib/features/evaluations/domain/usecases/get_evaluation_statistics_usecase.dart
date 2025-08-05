import '../repositories/evaluation_repository.dart';

class GetEvaluationStatisticsUseCase {
  final EvaluationRepository repository;

  const GetEvaluationStatisticsUseCase(this.repository);

  Future<EvaluationStatistics> call({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getEvaluationStatistics(
      evaluatorId: evaluatorId,
      startDate: startDate,
      endDate: endDate,
    );
  }
} 