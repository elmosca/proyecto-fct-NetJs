import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/report_repository.dart';

class ExportDataUseCase {
  final ReportRepository _reportRepository;

  const ExportDataUseCase(this._reportRepository);

  Future<String> call({
    required String dataType,
    required ReportFormat format,
    required Map<String, dynamic> filters,
  }) async {
    // Validaciones de negocio
    if (dataType.trim().isEmpty) {
      throw ArgumentError('El tipo de datos es requerido');
    }

    // Validar tipos de datos soportados
    final supportedDataTypes = [
      'anteprojects',
      'defenses',
      'evaluations',
      'students',
      'tutors',
      'reports',
    ];

    if (!supportedDataTypes.contains(dataType)) {
      throw ArgumentError('Tipo de datos no soportado: $dataType');
    }

    // Validar filtros básicos
    if (filters.isEmpty) {
      throw ArgumentError('Los filtros no pueden estar vacíos');
    }

    return await _reportRepository.exportData(
      dataType: dataType,
      format: format,
      filters: filters,
    );
  }
}
