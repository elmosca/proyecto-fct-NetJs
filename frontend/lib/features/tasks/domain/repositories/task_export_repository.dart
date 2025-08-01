import 'package:fct_frontend/features/tasks/domain/entities/task_export_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_export_entity.dart';

abstract class TaskExportRepository {
  /// Crear una nueva exportación de tareas
  Future<TaskExport> createTaskExport(CreateTaskExportDto dto);

  /// Obtener exportaciones con filtros
  Future<List<TaskExport>> getTaskExports(TaskExportFiltersDto filters);

  /// Obtener una exportación por ID
  Future<TaskExport?> getTaskExportById(String id);

  /// Actualizar una exportación existente
  Future<TaskExport> updateTaskExport(String id, UpdateTaskExportDto dto);

  /// Eliminar una exportación
  Future<void> deleteTaskExport(String id);

  /// Obtener vista previa de la exportación
  Future<TaskExportPreviewDto> getExportPreview(CreateTaskExportDto dto);

  /// Descargar archivo de exportación
  Future<TaskExportDownloadDto> downloadExport(String exportId);

  /// Obtener estado de una exportación
  Future<TaskExportStatus> getExportStatus(String exportId);

  /// Cancelar una exportación en proceso
  Future<void> cancelExport(String exportId);

  /// Crear plantilla de exportación
  Future<TaskExportTemplate> createExportTemplate(
      CreateTaskExportTemplateDto dto);

  /// Obtener plantillas de exportación
  Future<List<TaskExportTemplate>> getExportTemplates();

  /// Obtener plantilla por ID
  Future<TaskExportTemplate?> getExportTemplateById(String id);

  /// Actualizar plantilla de exportación
  Future<TaskExportTemplate> updateExportTemplate(
      String id, UpdateTaskExportTemplateDto dto);

  /// Eliminar plantilla de exportación
  Future<void> deleteExportTemplate(String id);

  /// Programar exportación automática
  Future<TaskExport> scheduleExport(TaskExportScheduleDto dto);

  /// Obtener exportaciones programadas
  Future<List<TaskExport>> getScheduledExports();

  /// Cancelar exportación programada
  Future<void> cancelScheduledExport(String exportId);

  /// Obtener columnas disponibles para exportación
  Future<List<TaskExportColumn>> getAvailableColumns();

  /// Obtener estadísticas de exportaciones
  Future<Map<String, dynamic>> getExportStatistics();

  /// Limpiar exportaciones antiguas
  Future<void> cleanupOldExports(int daysToKeep);

  /// Exportar tareas con configuración rápida
  Future<TaskExport> quickExport({
    required TaskExportFormat format,
    required TaskExportFilters filters,
    List<String>? columns,
  });

  /// Exportar tareas por proyecto
  Future<TaskExport> exportProjectTasks({
    required String projectId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  });

  /// Exportar tareas por milestone
  Future<TaskExport> exportMilestoneTasks({
    required String milestoneId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  });

  /// Exportar tareas por usuario asignado
  Future<TaskExport> exportUserTasks({
    required String userId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  });

  /// Exportar tareas vencidas
  Future<TaskExport> exportOverdueTasks({
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  });

  /// Exportar tareas completadas
  Future<TaskExport> exportCompletedTasks({
    required TaskExportFormat format,
    DateTime? fromDate,
    DateTime? toDate,
    TaskExportFilters? additionalFilters,
  });
}
