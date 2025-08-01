import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';
part 'task_entity.g.dart';

@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String id,
    required String projectId,
    String? milestoneId,
    required String createdById,
    required String title,
    required String description,
    @Default(TaskStatus.pending) TaskStatus status,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(TaskComplexity.medium) TaskComplexity complexity,
    DateTime? dueDate,
    DateTime? completedAt,
    @Default(0) int kanbanPosition,
    int? estimatedHours,
    int? actualHours,
    @Default([]) List<String> tags,
    @Default([]) List<String> assignees,
    @Default([]) List<String> dependencies, // IDs de tareas de las que depende
    @Default([]) List<String> dependents, // IDs de tareas que dependen de esta
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _TaskEntity;

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);
}

enum TaskStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('under_review')
  underReview,
  @JsonValue('completed')
  completed,
}

enum TaskPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
}

enum TaskComplexity {
  @JsonValue('simple')
  simple,
  @JsonValue('medium')
  medium,
  @JsonValue('complex')
  complex,
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.underReview:
        return 'En Revisión';
      case TaskStatus.completed:
        return 'Completada';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.underReview:
        return 'Under Review';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.underReview:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.underReview:
        return Icons.rate_review;
      case TaskStatus.completed:
        return Icons.check_circle_outline;
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}

extension TaskComplexityExtension on TaskComplexity {
  String get displayName {
    switch (this) {
      case TaskComplexity.simple:
        return 'Simple';
      case TaskComplexity.medium:
        return 'Media';
      case TaskComplexity.complex:
        return 'Compleja';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case TaskComplexity.simple:
        return 'Simple';
      case TaskComplexity.medium:
        return 'Medium';
      case TaskComplexity.complex:
        return 'Complex';
    }
  }

  Color get color {
    switch (this) {
      case TaskComplexity.simple:
        return Colors.green;
      case TaskComplexity.medium:
        return Colors.orange;
      case TaskComplexity.complex:
        return Colors.red;
    }
  }
}
