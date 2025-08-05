import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class UpdateMilestoneUseCase {
  final MilestoneRepository _milestoneRepository;

  UpdateMilestoneUseCase(this._milestoneRepository);

  Future<MilestoneEntity> execute(String milestoneId, UpdateMilestoneDto updateMilestoneDto) {
    return _milestoneRepository.updateMilestone(milestoneId, updateMilestoneDto);
  }
} 