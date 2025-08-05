import 'package:fct_frontend/features/tasks/domain/entities/milestone.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class CreateMilestoneUseCase {
  final MilestoneRepository _milestoneRepository;

  CreateMilestoneUseCase(this._milestoneRepository);

  Future<Milestone> execute(Milestone milestone) {
    return _milestoneRepository.createMilestone(milestone);
  }
} 