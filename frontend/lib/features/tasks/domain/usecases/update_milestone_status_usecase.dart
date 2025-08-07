import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class UpdateMilestoneStatusUseCase {
  final MilestoneRepository _milestoneRepository;

  UpdateMilestoneStatusUseCase(this._milestoneRepository);

  Future<MilestoneEntity> execute(String milestoneId, MilestoneStatus status) {
    return _milestoneRepository.updateMilestoneStatus(milestoneId, status);
  }
} 
