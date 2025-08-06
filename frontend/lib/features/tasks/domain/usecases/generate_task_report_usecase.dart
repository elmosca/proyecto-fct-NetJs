import 'package:fct_frontend/features/tasks/domain/entities/task_report_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_report_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_report_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
GenerateTaskReportUseCase generateTaskReportUseCase(Ref ref) {
  // TODO: Implementar provider del repositorio
  throw UnimplementedError('taskReportRepositoryProvider not implemented');
}
