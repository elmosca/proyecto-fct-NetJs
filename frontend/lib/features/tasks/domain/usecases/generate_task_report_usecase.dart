import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/task_report_dto.dart';
import '../entities/task_report_entity.dart';
import '../repositories/task_report_repository.dart';

part 'generate_task_report_usecase.g.dart';

/// Use case para generar reportes de tareas
class GenerateTaskReportUseCase {
  final TaskReportRepository _repository;

  const GenerateTaskReportUseCase(this._repository);

  /// Ejecuta el use case para generar un reporte
  ///
  /// [dto] - DTO con los datos del reporte a generar
  ///
  /// Retorna el reporte generado
  Future<TaskReport> execute(CreateTaskReportDto dto) async {
    return await _repository.createTaskReport(dto);
  }
}

/// Provider para el use case de generar reportes
@riverpod
GenerateTaskReportUseCase generateTaskReportUseCase(
    GenerateTaskReportUseCaseRef ref) {
  final repository = ref.watch(taskReportRepositoryProvider);
  return GenerateTaskReportUseCase(repository);
}
