import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class GetMilestoneStatisticsUseCase {
  final MilestoneRepository _milestoneRepository;

  GetMilestoneStatisticsUseCase(this._milestoneRepository);

  Future<Map<String, dynamic>> execute(String? projectId) {
    return _milestoneRepository.getMilestoneStatistics(projectId: projectId);
  }
} 