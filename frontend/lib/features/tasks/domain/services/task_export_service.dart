import 'package:fct_frontend/features/tasks/domain/entities/task_export_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_export_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_export_repository.dart';

/// Servicio para manejar la lógica de negocio de exportación de tareas
class TaskExportService {
  final TaskExportRepository _repository;

  TaskExportService(this._repository);

  /// Crear exportación con validaciones
  Future<TaskExport> createExport(CreateTaskExportDto dto) async {
    // Validar que el título no esté vacío
    if (dto.title.trim().isEmpty) {
      throw ArgumentError('El título de la exportación no puede estar vacío');
    }

    // Validar que se hayan seleccionado columnas
    if (dto.columns.isEmpty) {
      throw ArgumentError(
          'Debe seleccionar al menos una columna para exportar');
    }

    // Validar que los filtros sean válidos
    _validateFilters(dto.filters);

    return await _repository.createTaskExport(dto);
  }

  /// Obtener vista previa antes de exportar
  Future<TaskExportPreviewDto> getPreview(CreateTaskExportDto dto) async {
    return await _repository.getExportPreview(dto);
  }

  /// Exportación rápida con configuración por defecto
  Future<TaskExport> quickExport({
    required TaskExportFormat format,
    required TaskExportFilters filters,
    List<String>? columns,
  }) async {
    // Usar columnas por defecto si no se especifican
    final defaultColumns = columns ?? await _getDefaultColumns();

    return await _repository.quickExport(
      format: format,
      filters: filters,
      columns: defaultColumns,
    );
  }

  /// Exportar tareas de un proyecto específico
  Future<TaskExport> exportProjectTasks({
    required String projectId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    final filters = TaskExportFilters(
      projectId: projectId,
      fromDate: additionalFilters?.fromDate,
      toDate: additionalFilters?.toDate,
      statuses: additionalFilters?.statuses,
      priorities: additionalFilters?.priorities,
    );

    return await _repository.exportProjectTasks(
      projectId: projectId,
      format: format,
      additionalFilters: filters,
    );
  }

  /// Exportar tareas de un milestone específico
  Future<TaskExport> exportMilestoneTasks({
    required String milestoneId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    final filters = TaskExportFilters(
      milestoneId: milestoneId,
      fromDate: additionalFilters?.fromDate,
      toDate: additionalFilters?.toDate,
      statuses: additionalFilters?.statuses,
    );

    return await _repository.exportMilestoneTasks(
      milestoneId: milestoneId,
      format: format,
      additionalFilters: filters,
    );
  }

  /// Exportar tareas asignadas a un usuario
  Future<TaskExport> exportUserTasks({
    required String userId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    final filters = TaskExportFilters(
      assignees: [userId],
      fromDate: additionalFilters?.fromDate,
      toDate: additionalFilters?.toDate,
      statuses: additionalFilters?.statuses,
      priorities: additionalFilters?.priorities,
    );

    return await _repository.exportUserTasks(
      userId: userId,
      format: format,
      additionalFilters: filters,
    );
  }

  /// Exportar tareas vencidas
  Future<TaskExport> exportOverdueTasks({
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    final filters = TaskExportFilters(
      includeOverdue: true,
      fromDate: additionalFilters?.fromDate,
      toDate: additionalFilters?.toDate,
      assignees: additionalFilters?.assignees,
      projectId: additionalFilters?.projectId,
    );

    return await _repository.exportOverdueTasks(
      format: format,
      additionalFilters: filters,
    );
  }

  /// Exportar tareas completadas en un rango de fechas
  Future<TaskExport> exportCompletedTasks({
    required TaskExportFormat format,
    DateTime? fromDate,
    DateTime? toDate,
    TaskExportFilters? additionalFilters,
  }) async {
    final filters = TaskExportFilters(
      statuses: ['completed'],
      fromDate: fromDate ?? additionalFilters?.fromDate,
      toDate: toDate ?? additionalFilters?.toDate,
      assignees: additionalFilters?.assignees,
      projectId: additionalFilters?.projectId,
    );

    return await _repository.exportCompletedTasks(
      format: format,
      fromDate: fromDate,
      toDate: toDate,
      additionalFilters: filters,
    );
  }

  /// Crear plantilla de exportación
  Future<TaskExportTemplate> createTemplate(
      CreateTaskExportTemplateDto dto) async {
    // Validar nombre de plantilla
    if (dto.name.trim().isEmpty) {
      throw ArgumentError('El nombre de la plantilla no puede estar vacío');
    }

    // Validar columnas
    if (dto.columns.isEmpty) {
      throw ArgumentError('Debe seleccionar al menos una columna');
    }

    return await _repository.createExportTemplate(dto);
  }

  /// Programar exportación automática
  Future<TaskExport> scheduleExport(TaskExportScheduleDto dto) async {
    // Validar fecha de programación
    if (dto.scheduledAt.isBefore(DateTime.now())) {
      throw ArgumentError('La fecha de programación debe ser futura');
    }

    // Validar expresión cron si se proporciona
    if (dto.cronExpression != null) {
      _validateCronExpression(dto.cronExpression!);
    }

    return await _repository.scheduleExport(dto);
  }

  /// Obtener exportaciones con filtros inteligentes
  Future<List<TaskExport>> getExports({
    TaskExportStatus? status,
    TaskExportFormat? format,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchTerm,
    int? limit,
    int? offset,
  }) async {
    final filters = TaskExportFiltersDto(
      fromDate: fromDate,
      toDate: toDate,
      searchTerm: searchTerm,
      limit: limit,
      offset: offset,
    );

    final exports = await _repository.getTaskExports(filters);

    // Filtrar por estado si se especifica
    if (status != null) {
      return exports.where((export) => export.status == status).toList();
    }

    // Filtrar por formato si se especifica
    if (format != null) {
      return exports.where((export) => export.format == format).toList();
    }

    return exports;
  }

  /// Descargar archivo de exportación con validaciones
  Future<TaskExportDownloadDto> downloadExport(String exportId) async {
    // Verificar que la exportación existe y está completada
    final export = await _repository.getTaskExportById(exportId);
    if (export == null) {
      throw ArgumentError('Exportación no encontrada');
    }

    if (!export.status.isCompleted) {
      throw StateError('La exportación no está completada');
    }

    if (export.downloadUrl == null) {
      throw StateError('URL de descarga no disponible');
    }

    return await _repository.downloadExport(exportId);
  }

  /// Obtener columnas por defecto para exportación
  Future<List<String>> _getDefaultColumns() async {
    final availableColumns = await _repository.getAvailableColumns();
    return availableColumns
        .where((column) => column.enabled)
        .take(10) // Limitar a 10 columnas por defecto
        .map((column) => column.key)
        .toList();
  }

  /// Validar filtros de exportación
  void _validateFilters(TaskExportFilters filters) {
    // Validar rango de fechas
    if (filters.fromDate != null && filters.toDate != null) {
      if (filters.fromDate!.isAfter(filters.toDate!)) {
        throw ArgumentError(
            'La fecha de inicio debe ser anterior a la fecha de fin');
      }
    }

    // Validar fechas de vencimiento
    if (filters.dueDateFrom != null && filters.dueDateTo != null) {
      if (filters.dueDateFrom!.isAfter(filters.dueDateTo!)) {
        throw ArgumentError(
            'La fecha de vencimiento inicial debe ser anterior a la final');
      }
    }

    // Validar que al menos un filtro esté presente
    final hasFilters = filters.projectId != null ||
        filters.milestoneId != null ||
        filters.statuses != null ||
        filters.priorities != null ||
        filters.assignees != null ||
        filters.fromDate != null ||
        filters.toDate != null;

    if (!hasFilters) {
      throw ArgumentError(
          'Debe especificar al menos un filtro para la exportación');
    }
  }

  /// Validar expresión cron
  void _validateCronExpression(String cronExpression) {
    // Validación básica de formato cron (5 campos: minuto hora día mes día_semana)
    final parts = cronExpression.split(' ');
    if (parts.length != 5) {
      throw ArgumentError(
          'Expresión cron inválida. Debe tener 5 campos: minuto hora día mes día_semana');
    }

    // Validaciones adicionales según el campo
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];

      // Validar que no esté vacío
      if (part.isEmpty) {
        throw ArgumentError('Campo cron vacío en posición $i');
      }

      // Validar formato básico (números, *, /, -, ,)
      if (!RegExp(r'^[\d*/,\-]+$').hasMatch(part)) {
        throw ArgumentError('Formato cron inválido en posición $i: $part');
      }
    }
  }

  /// Obtener estadísticas de exportaciones
  Future<Map<String, dynamic>> getStatistics() async {
    return await _repository.getExportStatistics();
  }

  /// Limpiar exportaciones antiguas
  Future<void> cleanupOldExports({int daysToKeep = 30}) async {
    if (daysToKeep < 1) {
      throw ArgumentError('El número de días debe ser mayor a 0');
    }

    await _repository.cleanupOldExports(daysToKeep);
  }

  /// Cancelar exportación si está en proceso
  Future<void> cancelExport(String exportId) async {
    final status = await _repository.getExportStatus(exportId);

    if (status.isCompleted || status.isFailed) {
      throw StateError(
          'No se puede cancelar una exportación que ya está completada o fallida');
    }

    await _repository.cancelExport(exportId);
  }
}
