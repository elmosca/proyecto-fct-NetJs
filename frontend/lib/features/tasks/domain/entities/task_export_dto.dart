import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_export_entity.dart';

part 'task_export_dto.freezed.dart';
part 'task_export_dto.g.dart';

@freezed
class CreateTaskExportDto with _$CreateTaskExportDto {
  const factory CreateTaskExportDto({
    required String title,
    required String description,
    required TaskExportFormat format,
    required TaskExportFilters filters,
    required List<String> columns,
  }) = _CreateTaskExportDto;

  factory CreateTaskExportDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskExportDtoFromJson(json);
}

@freezed
class UpdateTaskExportDto with _$UpdateTaskExportDto {
  const factory UpdateTaskExportDto({
    String? title,
    String? description,
    TaskExportFormat? format,
    TaskExportFilters? filters,
    List<String>? columns,
  }) = _UpdateTaskExportDto;

  factory UpdateTaskExportDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskExportDtoFromJson(json);
}

@freezed
class TaskExportFiltersDto with _$TaskExportFiltersDto {
  const factory TaskExportFiltersDto({
    String? projectId,
    String? milestoneId,
    List<String>? statuses,
    List<String>? priorities,
    List<String>? complexities,
    List<String>? assignees,
    List<String>? tags,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
    bool? includeCompleted,
    bool? includeOverdue,
    String? searchTerm,
    int? limit,
    int? offset,
  }) = _TaskExportFiltersDto;

  factory TaskExportFiltersDto.fromJson(Map<String, dynamic> json) =>
      _$TaskExportFiltersDtoFromJson(json);
}

@freezed
class CreateTaskExportTemplateDto with _$CreateTaskExportTemplateDto {
  const factory CreateTaskExportTemplateDto({
    required String name,
    required String description,
    required TaskExportFormat format,
    required List<String> columns,
    required TaskExportFilters defaultFilters,
  }) = _CreateTaskExportTemplateDto;

  factory CreateTaskExportTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskExportTemplateDtoFromJson(json);
}

@freezed
class UpdateTaskExportTemplateDto with _$UpdateTaskExportTemplateDto {
  const factory UpdateTaskExportTemplateDto({
    String? name,
    String? description,
    TaskExportFormat? format,
    List<String>? columns,
    TaskExportFilters? defaultFilters,
  }) = _UpdateTaskExportTemplateDto;

  factory UpdateTaskExportTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskExportTemplateDtoFromJson(json);
}

@freezed
class TaskExportPreviewDto with _$TaskExportPreviewDto {
  const factory TaskExportPreviewDto({
    required int totalRecords,
    required List<Map<String, dynamic>> sampleData,
    required List<TaskExportColumn> availableColumns,
    String? estimatedFileSize,
    int? estimatedProcessingTime,
  }) = _TaskExportPreviewDto;

  factory TaskExportPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$TaskExportPreviewDtoFromJson(json);
}

@freezed
class TaskExportDownloadDto with _$TaskExportDownloadDto {
  const factory TaskExportDownloadDto({
    required String exportId,
    required String downloadUrl,
    required String fileName,
    required String fileSize,
    required DateTime expiresAt,
  }) = _TaskExportDownloadDto;

  factory TaskExportDownloadDto.fromJson(Map<String, dynamic> json) =>
      _$TaskExportDownloadDtoFromJson(json);
}

@freezed
class TaskExportScheduleDto with _$TaskExportScheduleDto {
  const factory TaskExportScheduleDto({
    required String title,
    required String description,
    required TaskExportFormat format,
    required TaskExportFilters filters,
    required List<String> columns,
    required DateTime scheduledAt,
    String? cronExpression,
    bool? repeat,
    String? repeatInterval,
    int? repeatCount,
  }) = _TaskExportScheduleDto;

  factory TaskExportScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$TaskExportScheduleDtoFromJson(json);
}
