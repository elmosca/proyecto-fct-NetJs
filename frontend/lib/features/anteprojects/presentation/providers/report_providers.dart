import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/report_filters.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/statistics.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/report_repository.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/create_report_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/export_data_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_dashboard_metrics_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_providers.g.dart';

// Provider para el repositorio (placeholder para inyección de dependencias)
@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) {
  // TODO: Implementar con GetIt o similar
  throw UnimplementedError('Implementar con inyección de dependencias');
}

// Providers para casos de uso
@riverpod
GetDashboardMetricsUseCase getDashboardMetricsUseCase(
    GetDashboardMetricsUseCaseRef ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return GetDashboardMetricsUseCase(repository);
}

@riverpod
CreateReportUseCase createReportUseCase(CreateReportUseCaseRef ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return CreateReportUseCase(repository);
}

@riverpod
ExportDataUseCase exportDataUseCase(ExportDataUseCaseRef ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return ExportDataUseCase(repository);
}

// Notifier para métricas del dashboard
@riverpod
class DashboardMetricsNotifier extends _$DashboardMetricsNotifier {
  @override
  Future<DashboardMetrics?> build() async {
    return null;
  }

  Future<void> loadMetrics({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    state = const AsyncValue.loading();

    try {
      final useCase = ref.read(getDashboardMetricsUseCaseProvider);
      final metrics = await useCase(
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(metrics);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadMetrics();
  }
}

// Notifier para reportes
@riverpod
class ReportsNotifier extends _$ReportsNotifier {
  @override
  Future<List<Report>> build() async {
    return [];
  }

  Future<void> loadReports({
    String? userId,
    ReportType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(reportRepositoryProvider);
      final reports = await repository.getReports(
        userId: userId,
        type: type,
        fromDate: fromDate,
        toDate: toDate,
      );
      state = AsyncValue.data(reports);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createReport({
    required String title,
    required String description,
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    required String userId,
  }) async {
    try {
      final useCase = ref.read(createReportUseCaseProvider);
      final newReport = await useCase(
        title: title,
        description: description,
        type: type,
        format: format,
        parameters: parameters,
        userId: userId,
      );

      // Actualizar la lista de reportes
      final currentReports = state.value ?? [];
      state = AsyncValue.data([newReport, ...currentReports]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      final repository = ref.read(reportRepositoryProvider);
      await repository.deleteReport(reportId);

      // Actualizar la lista de reportes
      final currentReports = state.value ?? [];
      final updatedReports =
          currentReports.where((report) => report.id != reportId).toList();
      state = AsyncValue.data(updatedReports);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadReports();
  }
}

// Notifier para estadísticas
@riverpod
class StatisticsNotifier extends _$StatisticsNotifier {
  @override
  Future<List<Statistics>> build() async {
    return [];
  }

  Future<void> loadStatistics({
    required List<StatisticsType> types,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(reportRepositoryProvider);
      final statistics = await repository.getStatistics(
        types: types,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );
      state = AsyncValue.data(statistics);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    // Recargar con los últimos parámetros
    final currentState = state.value;
    if (currentState != null && currentState.isNotEmpty) {
      final firstStat = currentState.first;
      await loadStatistics(
        types: currentState.map((s) => s.type).toList(),
        periodStart: firstStat.periodStart,
        periodEnd: firstStat.periodEnd,
      );
    }
  }
}

// Notifier para exportación de datos
@riverpod
class ExportNotifier extends _$ExportNotifier {
  @override
  Future<String?> build() async {
    return null;
  }

  Future<void> exportData({
    required String dataType,
    required ReportFormat format,
    required Map<String, dynamic> filters,
  }) async {
    state = const AsyncValue.loading();

    try {
      final useCase = ref.read(exportDataUseCaseProvider);
      final downloadUrl = await useCase(
        dataType: dataType,
        format: format,
        filters: filters,
      );
      state = AsyncValue.data(downloadUrl);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearExport() {
    state = const AsyncValue.data(null);
  }
}

// Los modelos de filtros están definidos en report_filters.dart

// Notifier para filtros de reportes
@riverpod
class ReportFiltersNotifier extends _$ReportFiltersNotifier {
  @override
  ReportFilters build() {
    return const ReportFilters();
  }

  void updateFilters(ReportFilters filters) {
    state = filters;
  }

  void clearFilters() {
    state = const ReportFilters();
  }
}

// Notifier para filtros de estadísticas
@riverpod
class StatisticsFiltersNotifier extends _$StatisticsFiltersNotifier {
  @override
  StatisticsFilters build() {
    return StatisticsFilters(
      types: StatisticsType.values,
      periodStart: DateTime.now().subtract(const Duration(days: 30)),
      periodEnd: DateTime.now(),
    );
  }

  void updateFilters(StatisticsFilters filters) {
    state = filters;
  }

  void updatePeriod(DateTime start, DateTime end) {
    state = state.copyWith(
      periodStart: start,
      periodEnd: end,
    );
  }

  void updateTypes(List<StatisticsType> types) {
    state = state.copyWith(types: types);
  }
}
