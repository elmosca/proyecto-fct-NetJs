import 'package:freezed_annotation/freezed_annotation.dart';

part 'anteproject.freezed.dart';
part 'anteproject.g.dart';

@freezed
class Anteproject with _$Anteproject {
  const factory Anteproject({
    required String id,
    required String title,
    required String description,
    required String studentId,
    required String studentName,
    String? tutorId,
    String? tutorName,
    required AnteprojectStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    DateTime? defenseDate,
    String? defenseLocation,
    double? grade,
    String? reviewComments,
    List<String>? attachments,
    List<String>? tags,
    String? abstract,
    String? keywords,
    int? estimatedDuration,
    String? methodology,
    List<String>? objectives,
    List<String>? deliverables,
  }) = _Anteproject;

  factory Anteproject.fromJson(Map<String, dynamic> json) =>
      _$AnteprojectFromJson(json);
}

enum AnteprojectStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('submitted')
  submitted,
  @JsonValue('under_review')
  underReview,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('defense_scheduled')
  defenseScheduled,
  @JsonValue('defense_completed')
  defenseCompleted,
  @JsonValue('completed')
  completed,
}

extension AnteprojectStatusExtension on AnteprojectStatus {
  String get displayName {
    switch (this) {
      case AnteprojectStatus.draft:
        return 'Borrador';
      case AnteprojectStatus.submitted:
        return 'Enviado';
      case AnteprojectStatus.underReview:
        return 'En Revisión';
      case AnteprojectStatus.approved:
        return 'Aprobado';
      case AnteprojectStatus.rejected:
        return 'Rechazado';
      case AnteprojectStatus.defenseScheduled:
        return 'Defensa Programada';
      case AnteprojectStatus.defenseCompleted:
        return 'Defensa Completada';
      case AnteprojectStatus.completed:
        return 'Completado';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case AnteprojectStatus.draft:
        return 'Draft';
      case AnteprojectStatus.submitted:
        return 'Submitted';
      case AnteprojectStatus.underReview:
        return 'Under Review';
      case AnteprojectStatus.approved:
        return 'Approved';
      case AnteprojectStatus.rejected:
        return 'Rejected';
      case AnteprojectStatus.defenseScheduled:
        return 'Defense Scheduled';
      case AnteprojectStatus.defenseCompleted:
        return 'Defense Completed';
      case AnteprojectStatus.completed:
        return 'Completed';
    }
  }

  bool get canEdit {
    return this == AnteprojectStatus.draft;
  }

  bool get canSubmit {
    return this == AnteprojectStatus.draft;
  }

  bool get canReview {
    return this == AnteprojectStatus.submitted || this == AnteprojectStatus.underReview;
  }

  bool get canScheduleDefense {
    return this == AnteprojectStatus.approved;
  }

  bool get canComplete {
    return this == AnteprojectStatus.defenseCompleted;
  }
} 
