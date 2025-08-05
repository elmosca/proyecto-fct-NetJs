import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class CreateMilestoneUseCase {
  final MilestoneRepository _milestoneRepository;

  CreateMilestoneUseCase(this._milestoneRepository);

  Future<MilestoneEntity> execute(CreateMilestoneDto createMilestoneDto) {
    return _milestoneRepository.createMilestone(createMilestoneDto);
  }
} 