import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_notification_entity.dart';

part 'task_notification_dto.freezed.dart';
part 'task_notification_dto.g.dart';

@freezed
class CreateTaskNotificationDto with _$CreateTaskNotificationDto {
  const factory CreateTaskNotificationDto({
    required String title,
    required String message,
    required TaskNotificationType type,
    required String userId,
    required String taskId,
    String? projectId,
    String? milestoneId,
    Map<String, dynamic>? metadata,
    DateTime? scheduledAt,
  }) = _CreateTaskNotificationDto;

  factory CreateTaskNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskNotificationDtoFromJson(json);
}

@freezed
class UpdateTaskNotificationDto with _$UpdateTaskNotificationDto {
  const factory UpdateTaskNotificationDto({
    String? title,
    String? message,
    TaskNotificationType? type,
    TaskNotificationStatus? status,
    Map<String, dynamic>? metadata,
    DateTime? readAt,
  }) = _UpdateTaskNotificationDto;

  factory UpdateTaskNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskNotificationDtoFromJson(json);
}

@freezed
class TaskNotificationFiltersDto with _$TaskNotificationFiltersDto {
  const factory TaskNotificationFiltersDto({
    String? userId,
    String? taskId,
    String? projectId,
    TaskNotificationType? type,
    TaskNotificationStatus? status,
    bool? unreadOnly,
    DateTime? fromDate,
    DateTime? toDate,
    int? limit,
    int? offset,
  }) = _TaskNotificationFiltersDto;

  factory TaskNotificationFiltersDto.fromJson(Map<String, dynamic> json) =>
      _$TaskNotificationFiltersDtoFromJson(json);
}

@freezed
class MarkNotificationAsReadDto with _$MarkNotificationAsReadDto {
  const factory MarkNotificationAsReadDto({
    required String notificationId,
    DateTime? readAt,
  }) = _MarkNotificationAsReadDto;

  factory MarkNotificationAsReadDto.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationAsReadDtoFromJson(json);
}

@freezed
class BulkMarkNotificationsAsReadDto with _$BulkMarkNotificationsAsReadDto {
  const factory BulkMarkNotificationsAsReadDto({
    required List<String> notificationIds,
    DateTime? readAt,
  }) = _BulkMarkNotificationsAsReadDto;

  factory BulkMarkNotificationsAsReadDto.fromJson(Map<String, dynamic> json) =>
      _$BulkMarkNotificationsAsReadDtoFromJson(json);
}
