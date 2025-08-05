import 'package:freezed_annotation/freezed_annotation.dart';
import 'evaluation_criteria.dart';

part 'evaluation.freezed.dart';
part 'evaluation.g.dart';

@freezed
class Evaluation with _$Evaluation {
  const factory Evaluation({
    required String id,
    required String anteprojectId,
    required String evaluatorId,
    required List<EvaluationScore> scores,
    required double totalScore,
    required String comments,
    required EvaluationStatus status,
    DateTime? submittedAt,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? evaluatorName,
    String? anteprojectTitle,
  }) = _Evaluation;

  factory Evaluation.fromJson(Map<String, dynamic> json) =>
      _$EvaluationFromJson(json);
}

@freezed
class EvaluationScore with _$EvaluationScore {
  const factory EvaluationScore({
    required String criteriaId,
    required String criteriaName,
    required double score,
    required double maxScore,
    String? comments,
  }) = _EvaluationScore;

  factory EvaluationScore.fromJson(Map<String, dynamic> json) =>
      _$EvaluationScoreFromJson(json);
}

enum EvaluationStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('submitted')
  submitted,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
}

extension EvaluationStatusExtension on EvaluationStatus {
  String get displayName {
    switch (this) {
      case EvaluationStatus.draft:
        return 'Borrador';
      case EvaluationStatus.submitted:
        return 'Enviada';
      case EvaluationStatus.approved:
        return 'Aprobada';
      case EvaluationStatus.rejected:
        return 'Rechazada';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case EvaluationStatus.draft:
        return 'Draft';
      case EvaluationStatus.submitted:
        return 'Submitted';
      case EvaluationStatus.approved:
        return 'Approved';
      case EvaluationStatus.rejected:
        return 'Rejected';
    }
  }

  bool get canEdit => this == EvaluationStatus.draft;
  bool get canSubmit => this == EvaluationStatus.draft;
  bool get canApprove => this == EvaluationStatus.submitted;
  bool get canReject => this == EvaluationStatus.submitted;
  
  String get color {
    switch (this) {
      case EvaluationStatus.draft:
        return '#FFA726'; // Orange
      case EvaluationStatus.submitted:
        return '#42A5F5'; // Blue
      case EvaluationStatus.approved:
        return '#66BB6A'; // Green
      case EvaluationStatus.rejected:
        return '#EF5350'; // Red
    }
  }
} 