import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
class Report with _$Report {
  const factory Report({
    required String id,
    required String title,
    required String description,
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    required String userId,
    String? filePath,
    String? downloadUrl,
    DateTime? generatedAt,
    DateTime? expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}

enum ReportType {
  anteprojectSummary,
  defenseSchedule,
  evaluationResults,
  studentPerformance,
  tutorWorkload,
  custom;

  String get displayName {
    switch (this) {
      case ReportType.anteprojectSummary:
        return 'Resumen de Anteproyectos';
      case ReportType.defenseSchedule:
        return 'Calendario de Defensas';
      case ReportType.evaluationResults:
        return 'Resultados de Evaluación';
      case ReportType.studentPerformance:
        return 'Rendimiento de Estudiantes';
      case ReportType.tutorWorkload:
        return 'Carga de Trabajo de Tutores';
      case ReportType.custom:
        return 'Reporte Personalizado';
    }
  }

  String get icon {
    switch (this) {
      case ReportType.anteprojectSummary:
        return '📊';
      case ReportType.defenseSchedule:
        return '📅';
      case ReportType.evaluationResults:
        return '📈';
      case ReportType.studentPerformance:
        return '🎓';
      case ReportType.tutorWorkload:
        return '👨‍🏫';
      case ReportType.custom:
        return '📋';
    }
  }
}

enum ReportFormat {
  pdf,
  excel,
  csv,
  json;

  String get displayName {
    switch (this) {
      case ReportFormat.pdf:
        return 'PDF';
      case ReportFormat.excel:
        return 'Excel';
      case ReportFormat.csv:
        return 'CSV';
      case ReportFormat.json:
        return 'JSON';
    }
  }

  String get extension {
    switch (this) {
      case ReportFormat.pdf:
        return '.pdf';
      case ReportFormat.excel:
        return '.xlsx';
      case ReportFormat.csv:
        return '.csv';
      case ReportFormat.json:
        return '.json';
    }
  }
} 
