import 'package:freezed_annotation/freezed_annotation.dart';

part 'defense.freezed.dart';
part 'defense.g.dart';

@freezed
class Defense with _$Defense {
  const factory Defense({
    required String id,
    required String anteprojectId,
    required String studentId,
    required String tutorId,
    required DateTime scheduledDate,
    required DefenseStatus status,
    String? location,
    String? notes,
    String? evaluationComments,
    double? score,
    DateTime? completedDate,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Defense;

  factory Defense.fromJson(Map<String, dynamic> json) =>
      _$DefenseFromJson(json);
}

enum DefenseStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

extension DefenseStatusExtension on DefenseStatus {
  String get displayName {
    switch (this) {
      case DefenseStatus.scheduled:
        return 'Programada';
      case DefenseStatus.inProgress:
        return 'En Progreso';
      case DefenseStatus.completed:
        return 'Completada';
      case DefenseStatus.cancelled:
        return 'Cancelada';
    }
  }

  bool get canEdit => this == DefenseStatus.scheduled;
  bool get canStart => this == DefenseStatus.scheduled;
  bool get canComplete => this == DefenseStatus.inProgress;
  bool get canCancel =>
      this == DefenseStatus.scheduled || this == DefenseStatus.inProgress;
}
