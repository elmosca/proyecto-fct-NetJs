import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';

abstract class DefenseRepository {
  /// Obtiene todas las defensas con filtros opcionales
  Future<List<Defense>> getDefenses({
    String? anteprojectId,
    String? studentId,
    String? tutorId,
    DefenseStatus? status,
  });

  /// Obtiene una defensa por su ID
  Future<Defense> getDefenseById(String id);

  /// Crea una nueva defensa
  Future<Defense> createDefense(Defense defense);

  /// Actualiza una defensa existente
  Future<Defense> updateDefense(Defense defense);

  /// Elimina una defensa
  Future<void> deleteDefense(String id);

  /// Programa una defensa para un anteproyecto
  Future<Defense> scheduleDefense({
    required String anteprojectId,
    required String studentId,
    required String tutorId,
    required DateTime scheduledDate,
    String? location,
    String? notes,
  });

  /// Inicia una defensa (cambia estado a in_progress)
  Future<Defense> startDefense(String id);

  /// Completa una defensa con evaluación
  Future<Defense> completeDefense({
    required String id,
    required String evaluationComments,
    required double score,
  });

  /// Cancela una defensa
  Future<Defense> cancelDefense(String id, String reason);

  /// Obtiene las defensas de un estudiante específico
  Future<List<Defense>> getStudentDefenses(String studentId);

  /// Obtiene las defensas que debe evaluar un tutor
  Future<List<Defense>> getTutorDefenses(String tutorId);
}
