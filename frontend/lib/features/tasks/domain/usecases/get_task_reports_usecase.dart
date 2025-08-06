import 'package:fct_frontend/features/tasks/domain/entities/task_report_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_report_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_report_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_task_reports_usecase.g.dart';

class GetTaskReportsUseCase {
  final TaskReportRepository _repository;

  GetTaskReportsUseCase(this._repository);

  Future<List<TaskReport>> call(TaskReportFiltersDto filters) async {
    return await _repository.getTaskReports(filters);
  }
}

@riverpod
GetTaskReportsUseCase getTaskReportsUseCase(Ref ref) {
  // TODO: Implementar provider del repositorio
  throw UnimplementedError('taskReportRepositoryProvider not implemented');
}
