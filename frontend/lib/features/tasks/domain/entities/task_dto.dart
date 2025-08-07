import 'package:freezed_annotation/freezed_annotation.dart';

import 'task.dart';

part 'task_dto.freezed.dart';
part 'task_dto.g.dart';

@freezed
class CreateTaskDto with _$CreateTaskDto {
  const factory CreateTaskDto({
    required String projectId,
    String? milestoneId,
    required String title,
    required String description,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(TaskComplexity.medium) TaskComplexity complexity,
    DateTime? dueDate,
    int? estimatedHours,
    @Default([]) List<String> tags,
    @Default([]) List<String> assignees,
    @Default([]) List<String> dependencies, // IDs de tareas de las que depende
  }) = _CreateTaskDto;

  factory CreateTaskDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskDtoFromJson(json);
}

@freezed
class UpdateTaskDto with _$UpdateTaskDto {
  const factory UpdateTaskDto({
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    TaskComplexity? complexity,
    DateTime? dueDate,
    DateTime? completedAt,
    int? kanbanPosition,
    int? estimatedHours,
    int? actualHours,
    List<String>? tags,
    List<String>? assignees,
    List<String>? dependencies, // IDs de tareas de las que depende
  }) = _UpdateTaskDto;

  factory UpdateTaskDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskDtoFromJson(json);
}

@freezed
class AssignUserDto with _$AssignUserDto {
  const factory AssignUserDto({
    required String userId,
  }) = _AssignUserDto;

  factory AssignUserDto.fromJson(Map<String, dynamic> json) =>
      _$AssignUserDtoFromJson(json);
}

@freezed
class TaskFiltersDto with _$TaskFiltersDto {
  const factory TaskFiltersDto({
    String? projectId,
    String? milestoneId,
    TaskStatus? status,
    TaskPriority? priority,
    TaskComplexity? complexity,
    String? assigneeId,
    String? createdById,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
    String? searchQuery,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _TaskFiltersDto;

  factory TaskFiltersDto.fromJson(Map<String, dynamic> json) =>
      _$TaskFiltersDtoFromJson(json);
}

@freezed
class AddDependencyDto with _$AddDependencyDto {
  const factory AddDependencyDto({
    required String taskId,
    required String dependencyTaskId, // ID de la tarea de la que depende
  }) = _AddDependencyDto;

  factory AddDependencyDto.fromJson(Map<String, dynamic> json) =>
      _$AddDependencyDtoFromJson(json);
}

@freezed
class RemoveDependencyDto with _$RemoveDependencyDto {
  const factory RemoveDependencyDto({
    required String taskId,
    required String dependencyTaskId, // ID de la tarea de la que ya no depende
  }) = _RemoveDependencyDto;

  factory RemoveDependencyDto.fromJson(Map<String, dynamic> json) =>
      _$RemoveDependencyDtoFromJson(json);
}

@freezed
class TaskDependenciesDto with _$TaskDependenciesDto {
  const factory TaskDependenciesDto({
    required String taskId,
    required List<String> dependencies, // IDs de tareas de las que depende
    required List<String> dependents, // IDs de tareas que dependen de esta
  }) = _TaskDependenciesDto;

  factory TaskDependenciesDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDependenciesDtoFromJson(json);
}
