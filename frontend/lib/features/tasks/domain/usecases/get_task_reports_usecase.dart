import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/task_report_dto.dart';
import '../entities/task_report_entity.dart';
import '../repositories/task_report_repository.dart';

part 'get_task_reports_usecase.g.dart';

class GetTaskReportsUseCase {
  final TaskReportRepository _repository;

  GetTaskReportsUseCase(this._repository);

  Future<List<TaskReport>> call(TaskReportFiltersDto filters) async {
    return await _repository.getTaskReports(filters);
  }
}

@riverpod
GetTaskReportsUseCase getTaskReportsUseCase(GetTaskReportsUseCaseRef ref) {
  final repository = ref.watch(taskReportRepositoryProvider);
  return GetTaskReportsUseCase(repository);
}
