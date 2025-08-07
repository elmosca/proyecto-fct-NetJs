import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/defense_repository.dart';

class CompleteDefenseUseCase {
  final DefenseRepository _defenseRepository;

  const CompleteDefenseUseCase(this._defenseRepository);

  Future<Defense> call({
    required String defenseId,
    required String evaluationComments,
    required double score,
  }) async {
    if (defenseId.isEmpty) {
      throw ArgumentError('El ID de la defensa no puede estar vacío');
    }
    if (evaluationComments.isEmpty) {
      throw ArgumentError('Los comentarios de evaluación no pueden estar vacíos');
    }
    if (score < 0 || score > 10) {
      throw ArgumentError('La puntuación debe estar entre 0 y 10');
    }

    return await _defenseRepository.completeDefense(
      id: defenseId,
      evaluationComments: evaluationComments,
      score: score,
    );
  }
} 
