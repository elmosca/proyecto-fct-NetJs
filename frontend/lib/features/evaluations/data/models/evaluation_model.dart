import 'package:fct_frontend/features/evaluations/domain/entities/evaluation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluation_model.freezed.dart';
part 'evaluation_model.g.dart';

@freezed
class EvaluationModel with _$EvaluationModel {
  const factory EvaluationModel({
    required String id,
    required String anteprojectId,
    required String evaluatorId,
    required List<EvaluationScoreModel> scores,
    required double totalScore,
    required String comments,
    required String status,
    DateTime? submittedAt,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? evaluatorName,
    String? anteprojectTitle,
  }) = _EvaluationModel;

  factory EvaluationModel.fromJson(Map<String, dynamic> json) =>
      _$EvaluationModelFromJson(json);
}

extension EvaluationModelExtension on EvaluationModel {
  Evaluation toEntity() {
    return Evaluation(
      id: id,
      anteprojectId: anteprojectId,
      evaluatorId: evaluatorId,
      scores: scores.map((s) => s.toEntity()).toList(),
      totalScore: totalScore,
      comments: comments,
      status: EvaluationStatus.values.firstWhere((e) => e.name == status),
      submittedAt: submittedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      evaluatorName: evaluatorName,
      anteprojectTitle: anteprojectTitle,
    );
  }
}

extension EvaluationModelStaticExtension on EvaluationModel {
  static EvaluationModel fromEntity(Evaluation entity) {
    return EvaluationModel(
      id: entity.id,
      anteprojectId: entity.anteprojectId,
      evaluatorId: entity.evaluatorId,
      scores: entity.scores
          .map((s) => EvaluationScoreModelStaticExtension.fromEntity(s))
          .toList(),
      totalScore: entity.totalScore,
      comments: entity.comments,
      status: entity.status.name,
      submittedAt: entity.submittedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      evaluatorName: entity.evaluatorName,
      anteprojectTitle: entity.anteprojectTitle,
    );
  }
}

@freezed
class EvaluationScoreModel with _$EvaluationScoreModel {
  const factory EvaluationScoreModel({
    required String criteriaId,
    required String criteriaName,
    required double score,
    required double maxScore,
    String? comments,
  }) = _EvaluationScoreModel;

  factory EvaluationScoreModel.fromJson(Map<String, dynamic> json) =>
      _$EvaluationScoreModelFromJson(json);
}

extension EvaluationScoreModelExtension on EvaluationScoreModel {
  EvaluationScore toEntity() {
    return EvaluationScore(
      criteriaId: criteriaId,
      criteriaName: criteriaName,
      score: score,
      maxScore: maxScore,
      comments: comments,
    );
  }
}

extension EvaluationScoreModelStaticExtension on EvaluationScoreModel {
  static EvaluationScoreModel fromEntity(EvaluationScore entity) {
    return EvaluationScoreModel(
      criteriaId: entity.criteriaId,
      criteriaName: entity.criteriaName,
      score: entity.score,
      maxScore: entity.maxScore,
      comments: entity.comments,
    );
  }
}
