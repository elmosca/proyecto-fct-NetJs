import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_report_entity.dart';

part 'task_report_dto.freezed.dart';
part 'task_report_dto.g.dart';

@freezed
class CreateTaskReportDto with _$CreateTaskReportDto {
  const factory CreateTaskReportDto({
    required String title,
    required String description,
    required TaskReportType type,
    String? projectId,
    String? milestoneId,
    Map<String, dynamic>? filters,
    DateTime? expiresAt,
  }) = _CreateTaskReportDto;

  factory CreateTaskReportDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskReportDtoFromJson(json);
}

@freezed
class UpdateTaskReportDto with _$UpdateTaskReportDto {
  const factory UpdateTaskReportDto({
    String? title,
    String? description,
    TaskReportType? type,
    TaskReportStatus? status,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? data,
    DateTime? generatedAt,
    DateTime? expiresAt,
  }) = _UpdateTaskReportDto;

  factory UpdateTaskReportDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskReportDtoFromJson(json);
}

@freezed
class TaskReportFiltersDto with _$TaskReportFiltersDto {
  const factory TaskReportFiltersDto({
    String? createdById,
    String? projectId,
    String? milestoneId,
    TaskReportType? type,
    TaskReportStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
    bool? includeExpired,
    int? limit,
    int? offset,
  }) = _TaskReportFiltersDto;

  factory TaskReportFiltersDto.fromJson(Map<String, dynamic> json) =>
      _$TaskReportFiltersDtoFromJson(json);
}

@freezed
class TaskReportDataDto with _$TaskReportDataDto {
  const factory TaskReportDataDto({
    required String reportId,
    required Map<String, dynamic> data,
    required DateTime generatedAt,
    String? format,
    String? downloadUrl,
  }) = _TaskReportDataDto;

  factory TaskReportDataDto.fromJson(Map<String, dynamic> json) =>
      _$TaskReportDataDtoFromJson(json);
}

@freezed
class TaskReportScheduleDto with _$TaskReportScheduleDto {
  const factory TaskReportScheduleDto({
    required String reportId,
    required String schedule,
    required DateTime nextRun,
    bool? isActive,
    Map<String, dynamic>? scheduleConfig,
  }) = _TaskReportScheduleDto;

  factory TaskReportScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$TaskReportScheduleDtoFromJson(json);
}

@freezed
class TaskReportExportDto with _$TaskReportExportDto {
  const factory TaskReportExportDto({
    required String reportId,
    required String format,
    Map<String, dynamic>? exportOptions,
  }) = _TaskReportExportDto;

  factory TaskReportExportDto.fromJson(Map<String, dynamic> json) =>
      _$TaskReportExportDtoFromJson(json);
}
