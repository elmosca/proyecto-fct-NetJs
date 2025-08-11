import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics.freezed.dart';
part 'statistics.g.dart';

@freezed
class Statistics with _$Statistics {
  const factory Statistics({
    required String id,
    required StatisticsType type,
    required Map<String, dynamic> data,
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime createdAt,
  }) = _Statistics;

  factory Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);
}

enum StatisticsType {
  anteprojectCount,
  defenseCount,
  evaluationCount,
  studentCount,
  tutorCount,
  averageScores,
  completionRates,
  workloadDistribution;

  String get displayName {
    switch (this) {
      case StatisticsType.anteprojectCount:
        return 'Total de Anteproyectos';
      case StatisticsType.defenseCount:
        return 'Total de Defensas';
      case StatisticsType.evaluationCount:
        return 'Total de Evaluaciones';
      case StatisticsType.studentCount:
        return 'Total de Estudiantes';
      case StatisticsType.tutorCount:
        return 'Total de Tutores';
      case StatisticsType.averageScores:
        return 'Promedio de Calificaciones';
      case StatisticsType.completionRates:
        return 'Tasas de Finalización';
      case StatisticsType.workloadDistribution:
        return 'Distribución de Carga de Trabajo';
    }
  }

  String get icon {
    switch (this) {
      case StatisticsType.anteprojectCount:
        return '📋';
      case StatisticsType.defenseCount:
        return '🎯';
      case StatisticsType.evaluationCount:
        return '📊';
      case StatisticsType.studentCount:
        return '👥';
      case StatisticsType.tutorCount:
        return '👨‍🏫';
      case StatisticsType.averageScores:
        return '⭐';
      case StatisticsType.completionRates:
        return '✅';
      case StatisticsType.workloadDistribution:
        return '⚖️';
    }
  }
}

@freezed
class DashboardMetrics with _$DashboardMetrics {
  const factory DashboardMetrics({
    required int totalAnteprojects,
    required int activeAnteprojects,
    required int completedAnteprojects,
    required int totalDefenses,
    required int scheduledDefenses,
    required int completedDefenses,
    required int totalStudents,
    required int totalTutors,
    required double averageScore,
    required double completionRate,
    required Map<String, int> anteprojectsByStatus,
    required Map<String, int> defensesByStatus,
    required Map<String, double> scoresDistribution,
  }) = _DashboardMetrics;

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) => _$DashboardMetricsFromJson(json);
} 
