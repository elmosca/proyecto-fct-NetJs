import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_entity.freezed.dart';
part 'milestone_entity.g.dart';

@freezed
class MilestoneEntity with _$MilestoneEntity {
  const factory MilestoneEntity({
    required String id,
    required String projectId,
    required int milestoneNumber,
    required String title,
    required String description,
    required DateTime plannedDate,
    DateTime? completedDate,
    @Default(MilestoneStatus.pending) MilestoneStatus status,
    @Default(MilestoneType.execution) MilestoneType milestoneType,
    @Default(false) bool isFromAnteproject,
    @Default([]) List<String> expectedDeliverables,
    String? reviewComments,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _MilestoneEntity;

  factory MilestoneEntity.fromJson(Map<String, dynamic> json) =>
      _$MilestoneEntityFromJson(json);
}

enum MilestoneStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('delayed')
  delayed,
}

enum MilestoneType {
  @JsonValue('planning')
  planning,
  @JsonValue('execution')
  execution,
  @JsonValue('review')
  review,
  @JsonValue('final')
  final_,
}

extension MilestoneStatusExtension on MilestoneStatus {
  String get displayName {
    switch (this) {
      case MilestoneStatus.pending:
        return 'Pendiente';
      case MilestoneStatus.inProgress:
        return 'En Progreso';
      case MilestoneStatus.completed:
        return 'Completado';
      case MilestoneStatus.delayed:
        return 'Retrasado';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case MilestoneStatus.pending:
        return 'Pending';
      case MilestoneStatus.inProgress:
        return 'In Progress';
      case MilestoneStatus.completed:
        return 'Completed';
      case MilestoneStatus.delayed:
        return 'Delayed';
    }
  }

  Color get color {
    switch (this) {
      case MilestoneStatus.pending:
        return Colors.grey;
      case MilestoneStatus.inProgress:
        return Colors.blue;
      case MilestoneStatus.completed:
        return Colors.green;
      case MilestoneStatus.delayed:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case MilestoneStatus.pending:
        return Icons.schedule;
      case MilestoneStatus.inProgress:
        return Icons.play_circle_outline;
      case MilestoneStatus.completed:
        return Icons.check_circle_outline;
      case MilestoneStatus.delayed:
        return Icons.warning;
    }
  }
}

extension MilestoneTypeExtension on MilestoneType {
  String get displayName {
    switch (this) {
      case MilestoneType.planning:
        return 'Planificación';
      case MilestoneType.execution:
        return 'Ejecución';
      case MilestoneType.review:
        return 'Revisión';
      case MilestoneType.final_:
        return 'Final';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case MilestoneType.planning:
        return 'Planning';
      case MilestoneType.execution:
        return 'Execution';
      case MilestoneType.review:
        return 'Review';
      case MilestoneType.final_:
        return 'Final';
    }
  }

  Color get color {
    switch (this) {
      case MilestoneType.planning:
        return Colors.purple;
      case MilestoneType.execution:
        return Colors.blue;
      case MilestoneType.review:
        return Colors.orange;
      case MilestoneType.final_:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case MilestoneType.planning:
        return Icons.schedule;
      case MilestoneType.execution:
        return Icons.play_circle_outline;
      case MilestoneType.review:
        return Icons.rate_review;
      case MilestoneType.final_:
        return Icons.flag;
    }
  }
}
