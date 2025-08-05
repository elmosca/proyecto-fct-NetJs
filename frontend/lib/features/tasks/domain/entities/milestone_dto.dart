import 'package:freezed_annotation/freezed_annotation.dart';

import 'milestone_entity.dart';

part 'milestone_dto.freezed.dart';
part 'milestone_dto.g.dart';

@freezed
class CreateMilestoneDto with _$CreateMilestoneDto {
  const factory CreateMilestoneDto({
    required String projectId,
    required int milestoneNumber,
    required String title,
    required String description,
    required DateTime plannedDate,
    @Default(MilestoneType.execution) MilestoneType milestoneType,
    @Default(false) bool isFromAnteproject,
    @Default([]) List<String> expectedDeliverables,
  }) = _CreateMilestoneDto;

  factory CreateMilestoneDto.fromJson(Map<String, dynamic> json) =>
      _$CreateMilestoneDtoFromJson(json);
}

@freezed
class UpdateMilestoneDto with _$UpdateMilestoneDto {
  const factory UpdateMilestoneDto({
    String? title,
    String? description,
    DateTime? plannedDate,
    DateTime? completedDate,
    MilestoneStatus? status,
    MilestoneType? milestoneType,
    List<String>? expectedDeliverables,
    String? reviewComments,
  }) = _UpdateMilestoneDto;

  factory UpdateMilestoneDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateMilestoneDtoFromJson(json);
}

@freezed
class MilestoneFiltersDto with _$MilestoneFiltersDto {
  const factory MilestoneFiltersDto({
    String? projectId,
    MilestoneStatus? status,
    MilestoneType? milestoneType,
    DateTime? plannedDateFrom,
    DateTime? plannedDateTo,
    String? searchQuery,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _MilestoneFiltersDto;

  factory MilestoneFiltersDto.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFiltersDtoFromJson(json);
}
