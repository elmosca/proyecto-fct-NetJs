import 'package:fct_frontend/features/anteprojects/domain/entities/report.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/report_repository.dart';

class CreateReportUseCase {
  final ReportRepository _reportRepository;

  const CreateReportUseCase(this._reportRepository);

  Future<Report> call({
    required String title,
    required String description,
    required ReportType type,
    required ReportFormat format,
    required Map<String, dynamic> parameters,
    required String userId,
  }) async {
    // Validaciones de negocio
    if (title.trim().isEmpty) {
      throw ArgumentError('El título del reporte no puede estar vacío');
    }

    if (description.trim().isEmpty) {
      throw ArgumentError('La descripción del reporte no puede estar vacía');
    }

    if (userId.trim().isEmpty) {
      throw ArgumentError('El ID del usuario es requerido');
    }

    if (parameters.isEmpty) {
      throw ArgumentError('Los parámetros del reporte no pueden estar vacíos');
    }

    return await _reportRepository.createReport(
      title: title.trim(),
      description: description.trim(),
      type: type,
      format: format,
      parameters: parameters,
      userId: userId,
    );
  }
}
