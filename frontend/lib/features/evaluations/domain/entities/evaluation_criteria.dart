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
    required bool isActive,
    required int displayOrder,
    required DateTime createdAt,
  }) = _EvaluationCriteria;

  factory EvaluationCriteria.fromJson(Map<String, dynamic> json) =>
      _$EvaluationCriteriaFromJson(json);
} 