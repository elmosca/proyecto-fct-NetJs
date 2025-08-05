import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_report_entity.freezed.dart';
part 'task_report_entity.g.dart';

@freezed
class TaskReport with _$TaskReport {
  const factory TaskReport({
    required String id,
    required String title,
    required String description,
    required TaskReportType type,
    required TaskReportStatus status,
    required String createdById,
    String? projectId,
    String? milestoneId,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? data,
    DateTime? generatedAt,
    DateTime? expiresAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TaskReport;

  factory TaskReport.fromJson(Map<String, dynamic> json) =>
      _$TaskReportFromJson(json);
}

enum TaskReportType {
  @JsonValue('task_status_summary')
  taskStatusSummary,
  @JsonValue('task_progress_by_user')
  taskProgressByUser,
  @JsonValue('task_progress_by_project')
  taskProgressByProject,
  @JsonValue('task_overdue_summary')
  taskOverdueSummary,
  @JsonValue('task_completion_trends')
  taskCompletionTrends,
  @JsonValue('task_priority_distribution')
  taskPriorityDistribution,
  @JsonValue('task_complexity_analysis')
  taskComplexityAnalysis,
  @JsonValue('task_dependency_analysis')
  taskDependencyAnalysis,
  @JsonValue('task_time_analysis')
  taskTimeAnalysis,
  @JsonValue('task_custom_report')
  taskCustomReport,
}

enum TaskReportStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('generating')
  generating,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('expired')
  expired,
}

extension TaskReportTypeExtension on TaskReportType {
  String get displayName {
    switch (this) {
      case TaskReportType.taskStatusSummary:
        return 'Resumen de Estados de Tareas';
      case TaskReportType.taskProgressByUser:
        return 'Progreso de Tareas por Usuario';
      case TaskReportType.taskProgressByProject:
        return 'Progreso de Tareas por Proyecto';
      case TaskReportType.taskOverdueSummary:
        return 'Resumen de Tareas Vencidas';
      case TaskReportType.taskCompletionTrends:
        return 'Tendencias de Completado';
      case TaskReportType.taskPriorityDistribution:
        return 'Distribución de Prioridades';
      case TaskReportType.taskComplexityAnalysis:
        return 'Análisis de Complejidad';
      case TaskReportType.taskDependencyAnalysis:
        return 'Análisis de Dependencias';
      case TaskReportType.taskTimeAnalysis:
        return 'Análisis de Tiempo';
      case TaskReportType.taskCustomReport:
        return 'Reporte Personalizado';
    }
  }

  String get icon {
    switch (this) {
      case TaskReportType.taskStatusSummary:
        return '📊';
      case TaskReportType.taskProgressByUser:
        return '👥';
      case TaskReportType.taskProgressByProject:
        return '📁';
      case TaskReportType.taskOverdueSummary:
        return '⚠️';
      case TaskReportType.taskCompletionTrends:
        return '📈';
      case TaskReportType.taskPriorityDistribution:
        return '🎯';
      case TaskReportType.taskComplexityAnalysis:
        return '🧩';
      case TaskReportType.taskDependencyAnalysis:
        return '🔗';
      case TaskReportType.taskTimeAnalysis:
        return '⏱️';
      case TaskReportType.taskCustomReport:
        return '📋';
    }
  }

  String get description {
    switch (this) {
      case TaskReportType.taskStatusSummary:
        return 'Muestra la distribución de tareas por estado';
      case TaskReportType.taskProgressByUser:
        return 'Analiza el progreso de tareas por usuario asignado';
      case TaskReportType.taskProgressByProject:
        return 'Evalúa el progreso de tareas por proyecto';
      case TaskReportType.taskOverdueSummary:
        return 'Lista todas las tareas vencidas y su estado';
      case TaskReportType.taskCompletionTrends:
        return 'Muestra tendencias de completado en el tiempo';
      case TaskReportType.taskPriorityDistribution:
        return 'Distribución de tareas por nivel de prioridad';
      case TaskReportType.taskComplexityAnalysis:
        return 'Análisis de complejidad de las tareas';
      case TaskReportType.taskDependencyAnalysis:
        return 'Análisis de dependencias entre tareas';
      case TaskReportType.taskTimeAnalysis:
        return 'Análisis de tiempo estimado vs real';
      case TaskReportType.taskCustomReport:
        return 'Reporte personalizado con filtros específicos';
    }
  }
}

extension TaskReportStatusExtension on TaskReportStatus {
  String get displayName {
    switch (this) {
      case TaskReportStatus.pending:
        return 'Pendiente';
      case TaskReportStatus.generating:
        return 'Generando';
      case TaskReportStatus.completed:
        return 'Completado';
      case TaskReportStatus.failed:
        return 'Fallido';
      case TaskReportStatus.expired:
        return 'Expirado';
    }
  }

  bool get isCompleted => this == TaskReportStatus.completed;
  bool get isPending => this == TaskReportStatus.pending;
  bool get isGenerating => this == TaskReportStatus.generating;
  bool get isFailed => this == TaskReportStatus.failed;
  bool get isExpired => this == TaskReportStatus.expired;
}
