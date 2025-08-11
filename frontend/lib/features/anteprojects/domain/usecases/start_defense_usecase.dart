import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/defense_repository.dart';

class StartDefenseUseCase {
  final DefenseRepository _defenseRepository;

  const StartDefenseUseCase(this._defenseRepository);

  Future<Defense> call(String defenseId) async {
    if (defenseId.isEmpty) {
      throw ArgumentError('El ID de la defensa no puede estar vacío');
    }

    return await _defenseRepository.startDefense(defenseId);
  }
} 
