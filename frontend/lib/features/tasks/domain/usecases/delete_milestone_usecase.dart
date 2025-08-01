import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class DeleteMilestoneUseCase {
  final MilestoneRepository _milestoneRepository;

  DeleteMilestoneUseCase(this._milestoneRepository);

  Future<void> execute(String milestoneId) {
    return _milestoneRepository.deleteMilestone(milestoneId);
  }
} 