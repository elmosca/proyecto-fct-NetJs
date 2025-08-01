import 'package:fct_frontend/features/tasks/domain/entities/milestone.dart';

abstract class MilestoneRepository {
  /// Obtener todos los milestones con filtros opcionales
  Future<List<Milestone>> getMilestones({
    String? projectId,
    String? anteprojectId,
    String? assignedUserId,
    MilestoneStatus? status,
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// Obtener un milestone por ID
  Future<Milestone?> getMilestoneById(String id);

  /// Crear un nuevo milestone
  Future<Milestone> createMilestone(Milestone milestone);

  /// Actualizar un milestone existente
  Future<Milestone> updateMilestone(Milestone milestone);

  /// Eliminar un milestone
  Future<void> deleteMilestone(String id);

  /// Cambiar el estado de un milestone
  Future<Milestone> updateMilestoneStatus(String id, MilestoneStatus status);

  /// Asignar un milestone a un usuario
  Future<Milestone> assignMilestone(String milestoneId, String userId);

  /// Obtener milestones próximos a vencer
  Future<List<Milestone>> getUpcomingMilestones({
    int days = 30,
    String? userId,
  });

  /// Obtener milestones vencidos
  Future<List<Milestone>> getOverdueMilestones({
    String? userId,
  });

  /// Obtener estadísticas de milestones
  Future<Map<String, dynamic>> getMilestoneStatistics({
    String? projectId,
    String? anteprojectId,
    String? userId,
  });

  /// Buscar milestones por texto
  Future<List<Milestone>> searchMilestones(
    String query, {
    String? projectId,
    String? anteprojectId,
    int? limit,
  });

  /// Obtener milestones dependientes
  Future<List<Milestone>> getDependentMilestones(String milestoneId);

  /// Marcar milestone como completado
  Future<Milestone> completeMilestone(String id, {String? notes});

  /// Obtener tareas asociadas a un milestone
  Future<List<String>> getMilestoneTasks(String milestoneId);

  /// Agregar tarea a un milestone
  Future<Milestone> addTaskToMilestone(String milestoneId, String taskId);

  /// Remover tarea de un milestone
  Future<Milestone> removeTaskFromMilestone(String milestoneId, String taskId);

  /// Obtener historial de cambios de un milestone
  Future<List<Map<String, dynamic>>> getMilestoneHistory(String milestoneId);
}
