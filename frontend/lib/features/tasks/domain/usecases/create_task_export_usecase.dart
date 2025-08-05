import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/task_export_dto.dart';
import '../entities/task_export_entity.dart';
import '../repositories/task_export_repository.dart';

part 'create_task_export_usecase.g.dart';

class CreateTaskExportUseCase {
  final TaskExportRepository _repository;

  CreateTaskExportUseCase(this._repository);

  Future<TaskExport> call(CreateTaskExportDto dto) async {
    return await _repository.createTaskExport(dto);
  }
}

@riverpod
CreateTaskExportUseCase createTaskExportUseCase(
    CreateTaskExportUseCaseRef ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
}
