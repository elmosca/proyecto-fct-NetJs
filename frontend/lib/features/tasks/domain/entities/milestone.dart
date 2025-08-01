import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone.freezed.dart';
part 'milestone.g.dart';

@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required MilestoneStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    String? createdByUserId,
    List<String>? taskIds,
    List<String>? dependencies,
    int? progress,
    String? notes,
    Map<String, dynamic>? metadata,
  }) = _Milestone;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
}

enum MilestoneStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('overdue')
  overdue,
  @JsonValue('cancelled')
  cancelled,
}

extension MilestoneStatusExtension on MilestoneStatus {
  String get displayName {
    switch (this) {
      case MilestoneStatus.pending:
        return 'Pendiente';
      case MilestoneStatus.inProgress:
        return 'En progreso';
      case MilestoneStatus.completed:
        return 'Completado';
      case MilestoneStatus.overdue:
        return 'Retrasado';
      case MilestoneStatus.cancelled:
        return 'Cancelado';
    }
  }

  String get icon {
    switch (this) {
      case MilestoneStatus.pending:
        return '⏳';
      case MilestoneStatus.inProgress:
        return '🔄';
      case MilestoneStatus.completed:
        return '🎯';
      case MilestoneStatus.overdue:
        return '⚠️';
      case MilestoneStatus.cancelled:
        return '❌';
    }
  }

  String get color {
    switch (this) {
      case MilestoneStatus.pending:
        return '#9CA3AF';
      case MilestoneStatus.inProgress:
        return '#3B82F6';
      case MilestoneStatus.completed:
        return '#10B981';
      case MilestoneStatus.overdue:
        return '#EF4444';
      case MilestoneStatus.cancelled:
        return '#6B7280';
    }
  }
}
