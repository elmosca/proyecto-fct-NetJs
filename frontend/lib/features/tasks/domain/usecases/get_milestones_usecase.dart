import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class GetMilestonesUseCase {
  final MilestoneRepository _milestoneRepository;

  GetMilestonesUseCase(this._milestoneRepository);

  Future<List<MilestoneEntity>> execute(MilestoneFiltersDto filters) {
    return _milestoneRepository.getMilestones(
      projectId: filters.projectId,
      status: filters.status,
      searchQuery: filters.searchQuery,
      limit: filters.limit,
      offset: (filters.page - 1) * filters.limit,
    );
  }
}
