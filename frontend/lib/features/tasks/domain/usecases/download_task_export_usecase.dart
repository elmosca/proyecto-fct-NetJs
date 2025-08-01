import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/task_export_dto.dart';
import '../repositories/task_export_repository.dart';

part 'download_task_export_usecase.g.dart';

class DownloadTaskExportUseCase {
  final TaskExportRepository _repository;

  DownloadTaskExportUseCase(this._repository);

  Future<TaskExportDownloadDto> call(String exportId) async {
    return await _repository.downloadExport(exportId);
  }
}

@riverpod
DownloadTaskExportUseCase downloadTaskExportUseCase(
    DownloadTaskExportUseCaseRef ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
}
