import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    String? createdByUserId,
    List<String>? tags,
    List<String>? attachments,
    int? estimatedHours,
    int? actualHours,
    String? notes,
    List<String>? dependencies,
    Map<String, dynamic>? metadata,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

enum TaskStatus {
  @JsonValue('todo')
  todo,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('review')
  review,
  @JsonValue('done')
  done,
  @JsonValue('cancelled')
  cancelled,
}

enum TaskPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'Por hacer';
      case TaskStatus.inProgress:
        return 'En progreso';
      case TaskStatus.review:
        return 'En revisión';
      case TaskStatus.done:
        return 'Completada';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  String get icon {
    switch (this) {
      case TaskStatus.todo:
        return '📋';
      case TaskStatus.inProgress:
        return '🔄';
      case TaskStatus.review:
        return '👀';
      case TaskStatus.done:
        return '✅';
      case TaskStatus.cancelled:
        return '❌';
    }
  }

  String get color {
    switch (this) {
      case TaskStatus.todo:
        return '#9CA3AF';
      case TaskStatus.inProgress:
        return '#3B82F6';
      case TaskStatus.review:
        return '#F59E0B';
      case TaskStatus.done:
        return '#10B981';
      case TaskStatus.cancelled:
        return '#EF4444';
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
      case TaskPriority.urgent:
        return 'Urgente';
    }
  }

  String get icon {
    switch (this) {
      case TaskPriority.low:
        return '🟢';
      case TaskPriority.medium:
        return '🟡';
      case TaskPriority.high:
        return '🟠';
      case TaskPriority.urgent:
        return '🔴';
    }
  }

  String get color {
    switch (this) {
      case TaskPriority.low:
        return '#10B981';
      case TaskPriority.medium:
        return '#F59E0B';
      case TaskPriority.high:
        return '#F97316';
      case TaskPriority.urgent:
        return '#EF4444';
    }
  }
}
