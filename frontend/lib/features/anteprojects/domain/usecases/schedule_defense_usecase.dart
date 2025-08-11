import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/defense_repository.dart';

class ScheduleDefenseUseCase {
  final DefenseRepository _defenseRepository;

  const ScheduleDefenseUseCase(this._defenseRepository);

  Future<Defense> call({
    required String anteprojectId,
    required String studentId,
    required String tutorId,
    required DateTime scheduledDate,
    String? location,
    String? notes,
  }) async {
    // Validaciones de negocio
    if (anteprojectId.isEmpty) {
      throw ArgumentError('El ID del anteproyecto no puede estar vacío');
    }
    if (studentId.isEmpty) {
      throw ArgumentError('El ID del estudiante no puede estar vacío');
    }
    if (tutorId.isEmpty) {
      throw ArgumentError('El ID del tutor no puede estar vacío');
    }
    if (scheduledDate.isBefore(DateTime.now())) {
      throw ArgumentError('La fecha de programación no puede ser en el pasado');
    }

    return await _defenseRepository.scheduleDefense(
      anteprojectId: anteprojectId,
      studentId: studentId,
      tutorId: tutorId,
      scheduledDate: scheduledDate,
      location: location,
      notes: notes,
    );
  }
} 
