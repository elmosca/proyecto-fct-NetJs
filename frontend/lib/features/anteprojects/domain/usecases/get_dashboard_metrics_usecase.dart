import 'package:fct_frontend/features/anteprojects/domain/entities/statistics.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/report_repository.dart';

class GetDashboardMetricsUseCase {
  final ReportRepository _reportRepository;

  const GetDashboardMetricsUseCase(this._reportRepository);

  Future<DashboardMetrics> call({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    // Validaciones básicas
    if (fromDate != null && toDate != null && fromDate.isAfter(toDate)) {
      throw ArgumentError(
          'La fecha de inicio no puede ser posterior a la fecha de fin');
    }

    return await _reportRepository.getDashboardMetrics(
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
