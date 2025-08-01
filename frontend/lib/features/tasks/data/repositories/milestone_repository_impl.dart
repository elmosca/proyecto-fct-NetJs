import 'package:fct_frontend/features/tasks/data/datasources/milestone_remote_datasource.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class MilestoneRepositoryImpl implements MilestoneRepository {
  final MilestoneRemoteDataSource _remoteDataSource;

  MilestoneRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<MilestoneEntity>> getMilestones(MilestoneFiltersDto filters) {
    return _remoteDataSource.getMilestones(filters);
  }

  @override
  Future<MilestoneEntity> getMilestoneById(String milestoneId) {
    return _remoteDataSource.getMilestoneById(milestoneId);
  }

  @override
  Future<MilestoneEntity> createMilestone(
      CreateMilestoneDto createMilestoneDto) {
    return _remoteDataSource.createMilestone(createMilestoneDto);
  }

  @override
  Future<MilestoneEntity> updateMilestone(
      String milestoneId, UpdateMilestoneDto updateMilestoneDto) {
    return _remoteDataSource.updateMilestone(milestoneId, updateMilestoneDto);
  }

  @override
  Future<void> deleteMilestone(String milestoneId) {
    return _remoteDataSource.deleteMilestone(milestoneId);
  }

  @override
  Future<List<MilestoneEntity>> getMilestonesByProject(String projectId) {
    return _remoteDataSource.getMilestonesByProject(projectId);
  }

  @override
  Future<MilestoneEntity> updateMilestoneStatus(
      String milestoneId, MilestoneStatus status) {
    return _remoteDataSource.updateMilestoneStatus(milestoneId, status);
  }

  @override
  Future<MilestoneEntity> completeMilestone(String milestoneId) {
    return _remoteDataSource.completeMilestone(milestoneId);
  }

  @override
  Future<Map<String, dynamic>> getMilestoneStatistics(String? projectId) {
    return _remoteDataSource.getMilestoneStatistics(projectId);
  }

  @override
  Future<MilestoneEntity?> getNextPendingMilestone(String projectId) {
    return _remoteDataSource.getNextPendingMilestone(projectId);
  }

  @override
  Future<List<MilestoneEntity>> getDelayedMilestones(String? projectId) {
    return _remoteDataSource.getDelayedMilestones(projectId);
  }
}
