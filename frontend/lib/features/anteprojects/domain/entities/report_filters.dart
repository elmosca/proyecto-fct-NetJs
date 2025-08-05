import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/statistics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_filters.freezed.dart';
part 'report_filters.g.dart';

@freezed
class ReportFilters with _$ReportFilters {
  const factory ReportFilters({
    String? userId,
    ReportType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) = _ReportFilters;

  factory ReportFilters.fromJson(Map<String, dynamic> json) =>
      _$ReportFiltersFromJson(json);
}

@freezed
class StatisticsFilters with _$StatisticsFilters {
  const factory StatisticsFilters({
    required List<StatisticsType> types,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) = _StatisticsFilters;

  factory StatisticsFilters.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFiltersFromJson(json);
}
