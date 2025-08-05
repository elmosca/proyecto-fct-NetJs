import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/defense_repository.dart';

class GetDefensesUseCase {
  final DefenseRepository _defenseRepository;

  const GetDefensesUseCase(this._defenseRepository);

  Future<List<Defense>> call({
    String? anteprojectId,
    String? studentId,
    String? tutorId,
    DefenseStatus? status,
  }) async {
    return await _defenseRepository.getDefenses(
      anteprojectId: anteprojectId,
      studentId: studentId,
      tutorId: tutorId,
      status: status,
    );
  }
} 