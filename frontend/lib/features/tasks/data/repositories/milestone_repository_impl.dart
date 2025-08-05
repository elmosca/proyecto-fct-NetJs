import 'package:fct_frontend/features/tasks/data/datasources/milestone_remote_datasource.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class MilestoneRepositoryImpl implements MilestoneRepository {
  final MilestoneRemoteDataSource _remoteDataSource;

  MilestoneRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Milestone>> getMilestones({
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    MilestoneStatus? status,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    return _remoteDataSource.getMilestones(
      projectId: projectId,
      anteprojectId: anteprojectId,
      assignedUserId: assignedUserId,
      status: status,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Milestone?> getMilestoneById(String milestoneId) {
    return _remoteDataSource.getMilestoneById(milestoneId);
  }

  @override
  Future<Milestone> createMilestone(Milestone milestone) {
    return _remoteDataSource.createMilestone(milestone);
  }

  @override
  Future<Milestone> updateMilestone(Milestone milestone) {
    return _remoteDataSource.updateMilestone(milestone);
  }

  @override
  Future<void> deleteMilestone(String milestoneId) {
    return _remoteDataSource.deleteMilestone(milestoneId);
  }

  @override
  Future<Milestone> updateMilestoneStatus(String milestoneId, MilestoneStatus status) async {
    return _remoteDataSource.updateMilestoneStatus(milestoneId, status);
  }

  @override
  Future<Map<String, dynamic>> getMilestoneStatistics({
    String? anteprojectId,
    String? projectId,
    String? userId,
  }) async {
    return _remoteDataSource.getMilestoneStatistics(projectId);
  }
}
