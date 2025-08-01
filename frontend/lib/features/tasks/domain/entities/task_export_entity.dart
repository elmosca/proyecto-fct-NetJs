import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_export_entity.freezed.dart';
part 'task_export_entity.g.dart';

enum TaskExportFormat {
  @JsonValue('pdf')
  pdf,
  @JsonValue('excel')
  excel,
  @JsonValue('csv')
  csv,
  @JsonValue('json')
  json,
}

enum TaskExportStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

@freezed
class TaskExport with _$TaskExport {
  const factory TaskExport({
    required String id,
    required String title,
    required String description,
    required TaskExportFormat format,
    required TaskExportStatus status,
    required TaskExportFilters filters,
    required List<String> columns,
    required String createdById,
    required DateTime createdAt,
    DateTime? completedAt,
    String? downloadUrl,
    String? errorMessage,
    int? totalRecords,
    String? fileSize,
  }) = _TaskExport;

  factory TaskExport.fromJson(Map<String, dynamic> json) =>
      _$TaskExportFromJson(json);
}

@freezed
class TaskExportFilters with _$TaskExportFilters {
  const factory TaskExportFilters({
    String? projectId,
    String? milestoneId,
    List<String>? statuses,
    List<String>? priorities,
    List<String>? complexities,
    List<String>? assignees,
    List<String>? tags,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
    bool? includeCompleted,
    bool? includeOverdue,
    String? searchTerm,
  }) = _TaskExportFilters;

  factory TaskExportFilters.fromJson(Map<String, dynamic> json) =>
      _$TaskExportFiltersFromJson(json);
}

@freezed
class TaskExportColumn with _$TaskExportColumn {
  const factory TaskExportColumn({
    required String key,
    required String label,
    required bool enabled,
    int? order,
  }) = _TaskExportColumn;

  factory TaskExportColumn.fromJson(Map<String, dynamic> json) =>
      _$TaskExportColumnFromJson(json);
}

@freezed
class TaskExportTemplate with _$TaskExportTemplate {
  const factory TaskExportTemplate({
    required String id,
    required String name,
    required String description,
    required TaskExportFormat format,
    required List<String> columns,
    required TaskExportFilters defaultFilters,
    required String createdById,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(false) bool isDefault,
  }) = _TaskExportTemplate;

  factory TaskExportTemplate.fromJson(Map<String, dynamic> json) =>
      _$TaskExportTemplateFromJson(json);
}

// Extensiones para mejor UX
extension TaskExportFormatExtension on TaskExportFormat {
  String get displayName {
    switch (this) {
      case TaskExportFormat.pdf:
        return 'PDF';
      case TaskExportFormat.excel:
        return 'Excel';
      case TaskExportFormat.csv:
        return 'CSV';
      case TaskExportFormat.json:
        return 'JSON';
    }
  }

  String get fileExtension {
    switch (this) {
      case TaskExportFormat.pdf:
        return 'pdf';
      case TaskExportFormat.excel:
        return 'xlsx';
      case TaskExportFormat.csv:
        return 'csv';
      case TaskExportFormat.json:
        return 'json';
    }
  }

  String get mimeType {
    switch (this) {
      case TaskExportFormat.pdf:
        return 'application/pdf';
      case TaskExportFormat.excel:
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case TaskExportFormat.csv:
        return 'text/csv';
      case TaskExportFormat.json:
        return 'application/json';
    }
  }
}

extension TaskExportStatusExtension on TaskExportStatus {
  String get displayName {
    switch (this) {
      case TaskExportStatus.pending:
        return 'Pendiente';
      case TaskExportStatus.processing:
        return 'Procesando';
      case TaskExportStatus.completed:
        return 'Completado';
      case TaskExportStatus.failed:
        return 'Fallido';
    }
  }

  bool get isCompleted => this == TaskExportStatus.completed;
  bool get isFailed => this == TaskExportStatus.failed;
  bool get isProcessing => this == TaskExportStatus.processing;
  bool get isPending => this == TaskExportStatus.pending;
}
