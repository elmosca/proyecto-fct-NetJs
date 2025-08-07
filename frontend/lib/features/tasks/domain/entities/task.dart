import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    @Default(TaskStatus.pending) TaskStatus status,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(TaskComplexity.medium) TaskComplexity complexity,
    required String projectId,
    String? anteprojectId,
    String? milestoneId,
    required String createdById,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    @Default(0) int kanbanPosition,
    int? estimatedHours,
    int? actualHours,
    @Default([]) List<String> tags,
    @Default([]) List<String> attachments,
    @Default([]) List<String> assignees,
    @Default([]) List<String> dependencies, // IDs de tareas de las que depende
    @Default([]) List<String> dependents, // IDs de tareas que dependen de esta
    String? notes,
    Map<String, dynamic>? metadata,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
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
  @JsonValue('critical')
  critical,
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
      case TaskStatus.cancelled:
        return 'Cancelada';
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
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get icon {
    switch (this) {
      case TaskStatus.pending:
        return '📋';
      case TaskStatus.inProgress:
        return '🔄';
      case TaskStatus.underReview:
        return '👀';
      case TaskStatus.completed:
        return '✅';
      case TaskStatus.cancelled:
        return '❌';
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
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  IconData get iconData {
    switch (this) {
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.underReview:
        return Icons.rate_review;
      case TaskStatus.completed:
        return Icons.check_circle_outline;
      case TaskStatus.cancelled:
        return Icons.cancel;
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
      case TaskPriority.critical:
        return 'Crítica';
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
      case TaskPriority.critical:
        return 'Critical';
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
      case TaskPriority.critical:
        return '🔴';
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
      case TaskPriority.critical:
        return Colors.purple;
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

// Extension para compatibilidad con código existente
extension TaskCompatibilityExtension on Task {
  // Getters para compatibilidad con código que usa assignedUserId
  String? get assignedUserId => assignees.isNotEmpty ? assignees.first : null;
  
  // Getters para compatibilidad con código que usa createdByUserId
  String get createdByUserId => createdById;
  
  // Método para agregar asignado
  Task assignUser(String userId) {
    if (!assignees.contains(userId)) {
      return copyWith(assignees: [...assignees, userId]);
    }
    return this;
  }
  
  // Método para remover asignado
  Task unassignUser(String userId) {
    return copyWith(assignees: assignees.where((id) => id != userId).toList());
  }
  
  // Método para cambiar estado
  Task changeStatus(TaskStatus newStatus) {
    return copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      completedAt: newStatus == TaskStatus.completed ? DateTime.now() : completedAt,
    );
  }
  
  // Método para actualizar prioridad
  Task updatePriority(TaskPriority newPriority) {
    return copyWith(
      priority: newPriority,
      updatedAt: DateTime.now(),
    );
  }
  
  // Método para agregar tag
  Task addTag(String tag) {
    if (!tags.contains(tag)) {
      return copyWith(tags: [...tags, tag]);
    }
    return this;
  }
  
  // Método para remover tag
  Task removeTag(String tag) {
    return copyWith(tags: tags.where((t) => t != tag).toList());
  }
  
  // Método para agregar dependencia
  Task addDependency(String taskId) {
    if (!dependencies.contains(taskId)) {
      return copyWith(dependencies: [...dependencies, taskId]);
    }
    return this;
  }
  
  // Método para remover dependencia
  Task removeDependency(String taskId) {
    return copyWith(dependencies: dependencies.where((id) => id != taskId).toList());
  }
  
  // Método para marcar como completada
  Task markAsCompleted() {
    return copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  // Método para marcar como cancelada
  Task markAsCancelled() {
    return copyWith(
      status: TaskStatus.cancelled,
      updatedAt: DateTime.now(),
    );
  }
  
  // Método para verificar si está vencida
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed || status == TaskStatus.cancelled) {
      return false;
    }
    return DateTime.now().isAfter(dueDate!);
  }
  
  // Método para verificar si está próxima a vencer (3 días)
  bool get isDueSoon {
    if (dueDate == null || status == TaskStatus.completed || status == TaskStatus.cancelled) {
      return false;
    }
    final threeDaysFromNow = DateTime.now().add(const Duration(days: 3));
    return dueDate!.isBefore(threeDaysFromNow) && !isOverdue;
  }
}
