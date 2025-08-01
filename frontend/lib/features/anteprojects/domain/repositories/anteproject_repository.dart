import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';

abstract class AnteprojectRepository {
  /// Obtiene todos los anteproyectos con filtros opcionales
  Future<List<Anteproject>> getAnteprojects({
    String? search,
    AnteprojectStatus? status,
    String? studentId,
    String? tutorId,
    int? page,
    int? limit,
  });

  /// Obtiene un anteproyecto por su ID
  Future<Anteproject> getAnteprojectById(String id);

  /// Crea un nuevo anteproyecto
  Future<Anteproject> createAnteproject(Anteproject anteproject);

  /// Actualiza un anteproyecto existente
  Future<Anteproject> updateAnteproject(String id, Anteproject anteproject);

  /// Elimina un anteproyecto
  Future<void> deleteAnteproject(String id);

  /// Envía un anteproyecto para revisión
  Future<Anteproject> submitAnteproject(String id);

  /// Aprueba un anteproyecto
  Future<Anteproject> approveAnteproject(String id, {String? comments});

  /// Rechaza un anteproyecto
  Future<Anteproject> rejectAnteproject(String id, {required String comments});

  /// Programa la defensa de un anteproyecto
  Future<Anteproject> scheduleDefense(
    String id, {
    required DateTime defenseDate,
    required String defenseLocation,
  });

  /// Marca la defensa como completada
  Future<Anteproject> completeDefense(String id, {double? grade});

  /// Obtiene estadísticas de anteproyectos
  Future<Map<String, dynamic>> getAnteprojectStats();

  /// Asigna un tutor a un anteproyecto
  Future<Anteproject> assignTutor(String anteprojectId, String tutorId);

  /// Sube un archivo adjunto
  Future<String> uploadAttachment(String anteprojectId, String filePath);

  /// Elimina un archivo adjunto
  Future<void> deleteAttachment(String anteprojectId, String attachmentId);
} 