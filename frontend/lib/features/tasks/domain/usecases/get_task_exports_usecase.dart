import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/task_export_dto.dart';
import '../entities/task_export_entity.dart';
import '../repositories/task_export_repository.dart';

part 'get_task_exports_usecase.g.dart';

class GetTaskExportsUseCase {
  final TaskExportRepository _repository;

  GetTaskExportsUseCase(this._repository);

  Future<List<TaskExport>> call(TaskExportFiltersDto filters) async {
    return await _repository.getTaskExports(filters);
  }
}

@riverpod
GetTaskExportsUseCase getTaskExportsUseCase(GetTaskExportsUseCaseRef ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
}
