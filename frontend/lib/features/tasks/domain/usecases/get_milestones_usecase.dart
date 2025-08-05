import 'package:fct_frontend/features/tasks/domain/entities/milestone.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class GetMilestonesUseCase {
  final MilestoneRepository _milestoneRepository;

  GetMilestonesUseCase(this._milestoneRepository);

  Future<List<Milestone>> execute({
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    MilestoneStatus? status,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    return _milestoneRepository.getMilestones(
      projectId: projectId,
      anteprojectId: anteprojectId,
      assignedUserId: assignedUserId,
      status: status,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }
} 