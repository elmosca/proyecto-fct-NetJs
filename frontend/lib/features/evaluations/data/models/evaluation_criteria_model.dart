import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/evaluation_criteria.dart';

part 'evaluation_criteria_model.freezed.dart';
part 'evaluation_criteria_model.g.dart';

@freezed
class EvaluationCriteriaModel with _$EvaluationCriteriaModel {
  const factory EvaluationCriteriaModel({
    required String id,
    required String name,
    required String description,
    required double maxScore,
    required bool isActive,
    required int displayOrder,
    required DateTime createdAt,
  }) = _EvaluationCriteriaModel;

  factory EvaluationCriteriaModel.fromJson(Map<String, dynamic> json) =>
      _$EvaluationCriteriaModelFromJson(json);

  factory EvaluationCriteriaModel.fromEntity(EvaluationCriteria entity) {
    return EvaluationCriteriaModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      maxScore: entity.maxScore,
      isActive: entity.isActive,
      displayOrder: entity.displayOrder,
      createdAt: entity.createdAt,
    );
  }

  EvaluationCriteria toEntity() {
    return EvaluationCriteria(
      id: id,
      name: name,
      description: description,
      maxScore: maxScore,
      isActive: isActive,
      displayOrder: displayOrder,
      createdAt: createdAt,
    );
  }
}
