import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluation_criteria.freezed.dart';
part 'evaluation_criteria.g.dart';

@freezed
class EvaluationCriteria with _$EvaluationCriteria {
  const factory EvaluationCriteria({
    required String id,
    required String name,
    required String description,
    required double maxScore,
    required double weight,
    required EvaluationCategory category,
    String? instructions,
    List<String>? subCriteria,
  }) = _EvaluationCriteria;

  factory EvaluationCriteria.fromJson(Map<String, dynamic> json) =>
      _$EvaluationCriteriaFromJson(json);
}

enum EvaluationCategory {
  @JsonValue('content')
  content,
  @JsonValue('methodology')
  methodology,
  @JsonValue('presentation')
  presentation,
  @JsonValue('originality')
  originality,
  @JsonValue('feasibility')
  feasibility,
}

extension EvaluationCategoryExtension on EvaluationCategory {
  String get displayName {
    switch (this) {
      case EvaluationCategory.content:
        return 'Contenido';
      case EvaluationCategory.methodology:
        return 'Metodología';
      case EvaluationCategory.presentation:
        return 'Presentación';
      case EvaluationCategory.originality:
        return 'Originalidad';
      case EvaluationCategory.feasibility:
        return 'Viabilidad';
    }
  }

  String get englishDisplayName {
    switch (this) {
      case EvaluationCategory.content:
        return 'Content';
      case EvaluationCategory.methodology:
        return 'Methodology';
      case EvaluationCategory.presentation:
        return 'Presentation';
      case EvaluationCategory.originality:
        return 'Originality';
      case EvaluationCategory.feasibility:
        return 'Feasibility';
    }
  }
}
