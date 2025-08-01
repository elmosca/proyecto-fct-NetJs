import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluation_result.freezed.dart';
part 'evaluation_result.g.dart';

@freezed
class EvaluationResult with _$EvaluationResult {
  const factory EvaluationResult({
    required String id,
    required String evaluationId,
    required double totalScore,
    required double maxPossibleScore,
    required double percentage,
    required String grade,
    required DateTime calculatedAt,
    Map<String, dynamic>? details,
  }) = _EvaluationResult;

  factory EvaluationResult.fromJson(Map<String, dynamic> json) =>
      _$EvaluationResultFromJson(json);
}

enum EvaluationGrade {
  @JsonValue('A')
  excellent,
  @JsonValue('B')
  good,
  @JsonValue('C')
  satisfactory,
  @JsonValue('D')
  needsImprovement,
  @JsonValue('F')
  fail,
}

extension EvaluationGradeExtension on EvaluationGrade {
  String get displayName {
    switch (this) {
      case EvaluationGrade.excellent:
        return 'Excelente';
      case EvaluationGrade.good:
        return 'Bueno';
      case EvaluationGrade.satisfactory:
        return 'Satisfactorio';
      case EvaluationGrade.needsImprovement:
        return 'Necesita Mejora';
      case EvaluationGrade.fail:
        return 'Suspenso';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case EvaluationGrade.excellent:
        return 'Excellent';
      case EvaluationGrade.good:
        return 'Good';
      case EvaluationGrade.satisfactory:
        return 'Satisfactory';
      case EvaluationGrade.needsImprovement:
        return 'Needs Improvement';
      case EvaluationGrade.fail:
        return 'Fail';
    }
  }

  String get color {
    switch (this) {
      case EvaluationGrade.excellent:
        return '#4CAF50'; // Green
      case EvaluationGrade.good:
        return '#8BC34A'; // Light Green
      case EvaluationGrade.satisfactory:
        return '#FFC107'; // Amber
      case EvaluationGrade.needsImprovement:
        return '#FF9800'; // Orange
      case EvaluationGrade.fail:
        return '#F44336'; // Red
    }
  }

  static EvaluationGrade fromPercentage(double percentage) {
    if (percentage >= 90) return EvaluationGrade.excellent;
    if (percentage >= 80) return EvaluationGrade.good;
    if (percentage >= 70) return EvaluationGrade.satisfactory;
    if (percentage >= 60) return EvaluationGrade.needsImprovement;
    return EvaluationGrade.fail;
  }
} 