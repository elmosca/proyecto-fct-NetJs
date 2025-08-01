import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/create_milestone_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/delete_milestone_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/get_milestone_statistics_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/get_milestones_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/update_milestone_status_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/update_milestone_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'milestone_providers.g.dart';

// Providers para casos de uso
@riverpod
GetMilestonesUseCase getMilestonesUseCase(GetMilestonesUseCaseRef ref) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return GetMilestonesUseCase(repository);
}

@riverpod
CreateMilestoneUseCase createMilestoneUseCase(CreateMilestoneUseCaseRef ref) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return CreateMilestoneUseCase(repository);
}

@riverpod
UpdateMilestoneUseCase updateMilestoneUseCase(UpdateMilestoneUseCaseRef ref) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return UpdateMilestoneUseCase(repository);
}

@riverpod
DeleteMilestoneUseCase deleteMilestoneUseCase(DeleteMilestoneUseCaseRef ref) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return DeleteMilestoneUseCase(repository);
}

@riverpod
UpdateMilestoneStatusUseCase updateMilestoneStatusUseCase(
    UpdateMilestoneStatusUseCaseRef ref) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return UpdateMilestoneStatusUseCase(repository);
}

@riverpod
GetMilestoneStatisticsUseCase getMilestoneStatisticsUseCase(
    GetMilestoneStatisticsUseCaseRef ref) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return GetMilestoneStatisticsUseCase(repository);
}

// Provider para el repositorio (se debe configurar en la inyección de dependencias)
@riverpod
MilestoneRepository milestoneRepository(MilestoneRepositoryRef ref) {
  throw UnimplementedError(
      'MilestoneRepository debe ser configurado en la inyección de dependencias');
}

// Notifier para el estado de los milestones
@riverpod
class MilestonesNotifier extends _$MilestonesNotifier {
  @override
  Future<List<MilestoneEntity>> build() async {
    return _loadMilestones();
  }

  Future<List<MilestoneEntity>> _loadMilestones() async {
    final useCase = ref.read(getMilestonesUseCaseProvider);
    final filters = ref.read(milestoneFiltersNotifierProvider);
    return await useCase.execute(filters);
  }

  Future<void> refreshMilestones() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadMilestones());
  }

  Future<void> createMilestone(CreateMilestoneDto createMilestoneDto) async {
    final useCase = ref.read(createMilestoneUseCaseProvider);
    await useCase.execute(createMilestoneDto);
    await refreshMilestones();
  }

  Future<void> updateMilestone(
      String milestoneId, UpdateMilestoneDto updateMilestoneDto) async {
    final useCase = ref.read(updateMilestoneUseCaseProvider);
    await useCase.execute(milestoneId, updateMilestoneDto);
    await refreshMilestones();
  }

  Future<void> deleteMilestone(String milestoneId) async {
    final useCase = ref.read(deleteMilestoneUseCaseProvider);
    await useCase.execute(milestoneId);
    await refreshMilestones();
  }

  Future<void> updateMilestoneStatus(
      String milestoneId, MilestoneStatus status) async {
    final useCase = ref.read(updateMilestoneStatusUseCaseProvider);
    await useCase.execute(milestoneId, status);
    await refreshMilestones();
  }
}

// Notifier para los filtros de milestones
@riverpod
class MilestoneFiltersNotifier extends _$MilestoneFiltersNotifier {
  @override
  MilestoneFiltersDto build() {
    return const MilestoneFiltersDto();
  }

  void updateFilters(MilestoneFiltersDto filters) {
    state = filters;
  }

  void clearFilters() {
    state = const MilestoneFiltersDto();
  }

  void setProjectId(String? projectId) {
    state = state.copyWith(projectId: projectId);
  }

  void setStatus(MilestoneStatus? status) {
    state = state.copyWith(status: status);
  }

  void setMilestoneType(MilestoneType? milestoneType) {
    state = state.copyWith(milestoneType: milestoneType);
  }

  void setSearchQuery(String? searchQuery) {
    state = state.copyWith(searchQuery: searchQuery);
  }

  void setDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(
      plannedDateFrom: from,
      plannedDateTo: to,
    );
  }
}

// Notifier para estadísticas de milestones
@riverpod
class MilestoneStatisticsNotifier extends _$MilestoneStatisticsNotifier {
  @override
  Future<Map<String, dynamic>> build(String? projectId) async {
    return _loadStatistics(projectId);
  }

  Future<Map<String, dynamic>> _loadStatistics(String? projectId) async {
    final useCase = ref.read(getMilestoneStatisticsUseCaseProvider);
    return await useCase.execute(projectId);
  }

  Future<void> refreshStatistics(String? projectId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadStatistics(projectId));
  }
}
