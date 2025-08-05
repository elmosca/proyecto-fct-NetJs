import 'package:fct_frontend/features/tasks/domain/entities/milestone.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class UpdateMilestoneUseCase {
  final MilestoneRepository _milestoneRepository;

  UpdateMilestoneUseCase(this._milestoneRepository);

  Future<Milestone> execute(Milestone milestone) {
    return _milestoneRepository.updateMilestone(milestone);
  }
} 