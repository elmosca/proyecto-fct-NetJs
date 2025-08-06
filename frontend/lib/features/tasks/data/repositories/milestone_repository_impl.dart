import 'package:fct_frontend/features/tasks/data/datasources/milestone_remote_datasource.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
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
    // TODO: Implementar con filtros reales
    final filters = MilestoneFiltersDto(
      projectId: projectId,
      status: status,
      searchQuery: searchQuery,
      page: offset != null ? (offset ~/ (limit ?? 20)) + 1 : 1,
      limit: limit ?? 20,
    );
    return _remoteDataSource.getMilestones(filters);
  }

  @override
  Future<Milestone?> getMilestoneById(String id) {
    return _remoteDataSource.getMilestoneById(id);
  }

  @override
  Future<Milestone> createMilestone(Milestone milestone) {
    // TODO: Convertir Milestone a DTO
    final dto = CreateMilestoneDto(
      projectId: milestone.projectId,
      milestoneNumber: milestone.milestoneNumber,
      title: milestone.title,
      description: milestone.description,
      plannedDate: milestone.plannedDate,
      milestoneType: milestone.milestoneType,
      isFromAnteproject: milestone.isFromAnteproject,
      expectedDeliverables: milestone.expectedDeliverables,
    );
    return _remoteDataSource.createMilestone(dto);
  }

  @override
  Future<Milestone> updateMilestone(Milestone milestone) {
    // TODO: Convertir Milestone a DTO
    final dto = UpdateMilestoneDto(
      title: milestone.title,
      description: milestone.description,
      plannedDate: milestone.plannedDate,
      completedDate: milestone.completedDate,
      status: milestone.status,
      milestoneType: milestone.milestoneType,
      expectedDeliverables: milestone.expectedDeliverables,
      reviewComments: milestone.reviewComments,
    );
    return _remoteDataSource.updateMilestone(milestone.id, dto);
  }

  @override
  Future<void> deleteMilestone(String id) {
    return _remoteDataSource.deleteMilestone(id);
  }

  @override
  Future<Milestone> updateMilestoneStatus(String id, MilestoneStatus status) {
    return _remoteDataSource.updateMilestoneStatus(id, status);
  }

  @override
  Future<Milestone> assignMilestone(String milestoneId, String userId) {
    // TODO: Implementar asignación
    throw UnimplementedError('assignMilestone not implemented');
  }

  @override
  Future<List<Milestone>> getUpcomingMilestones({
    int days = 30,
    String? userId,
  }) {
    // TODO: Implementar milestones próximos
    throw UnimplementedError('getUpcomingMilestones not implemented');
  }

  @override
  Future<List<Milestone>> getOverdueMilestones({
    String? userId,
  }) {
    // TODO: Implementar milestones vencidos
    throw UnimplementedError('getOverdueMilestones not implemented');
  }

  @override
  Future<Map<String, dynamic>> getMilestoneStatistics({
    String? projectId,
    String? anteprojectId,
    String? userId,
  }) {
    return _remoteDataSource.getMilestoneStatistics(projectId);
  }

  @override
  Future<List<Milestone>> searchMilestones(
    String query, {
    String? projectId,
    String? anteprojectId,
    int? limit,
  }) {
    // TODO: Implementar búsqueda
    throw UnimplementedError('searchMilestones not implemented');
  }

  @override
  Future<List<Milestone>> getDependentMilestones(String milestoneId) {
    // TODO: Implementar milestones dependientes
    throw UnimplementedError('getDependentMilestones not implemented');
  }

  @override
  Future<Milestone> completeMilestone(String id, {String? notes}) {
    return _remoteDataSource.completeMilestone(id);
  }

  @override
  Future<List<String>> getMilestoneTasks(String milestoneId) {
    // TODO: Implementar obtención de tareas
    throw UnimplementedError('getMilestoneTasks not implemented');
  }

  @override
  Future<Milestone> addTaskToMilestone(String milestoneId, String taskId) {
    // TODO: Implementar agregar tarea
    throw UnimplementedError('addTaskToMilestone not implemented');
  }

  @override
  Future<Milestone> removeTaskFromMilestone(String milestoneId, String taskId) {
    // TODO: Implementar remover tarea
    throw UnimplementedError('removeTaskFromMilestone not implemented');
  }

  @override
  Future<List<Map<String, dynamic>>> getMilestoneHistory(String milestoneId) {
    // TODO: Implementar historial
    throw UnimplementedError('getMilestoneHistory not implemented');
  }
}
