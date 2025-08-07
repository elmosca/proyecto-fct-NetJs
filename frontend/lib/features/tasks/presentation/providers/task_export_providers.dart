import 'package:fct_frontend/features/tasks/domain/entities/task_export_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_export_entity.dart';
import 'package:fct_frontend/features/tasks/domain/services/task_export_service.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/create_task_export_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/download_task_export_usecase.dart';
import 'package:fct_frontend/features/tasks/domain/usecases/get_task_exports_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers para use cases
final createTaskExportUseCaseProvider =
    Provider<CreateTaskExportUseCase>((ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
});

final getTaskExportsUseCaseProvider = Provider<GetTaskExportsUseCase>((ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
});

final downloadTaskExportUseCaseProvider =
    Provider<DownloadTaskExportUseCase>((ref) {
  // TODO: Implementar cuando tengamos el repository configurado
  throw UnimplementedError('Repository not configured yet');
});

// Notifier para gestionar el estado de las exportaciones
class TaskExportsNotifier extends StateNotifier<AsyncValue<List<TaskExport>>> {
  final TaskExportService _service;

  TaskExportsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadExports(TaskExportFiltersDto filters) async {
    state = const AsyncValue.loading();
    try {
      final exports = await _service.getExports(
        fromDate: filters.fromDate,
        toDate: filters.toDate,
        searchTerm: filters.searchTerm,
        limit: filters.limit,
        offset: filters.offset,
      );
      state = AsyncValue.data(exports);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh(TaskExportFiltersDto filters) async {
    if (state.hasValue) {
      try {
        final exports = await _service.getExports(
          fromDate: filters.fromDate,
          toDate: filters.toDate,
          searchTerm: filters.searchTerm,
          limit: filters.limit,
          offset: filters.offset,
        );
        state = AsyncValue.data(exports);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> createExport(CreateTaskExportDto dto) async {
    try {
      final export = await _service..(dto);
      if (state.hasValue) {
        final exports = state.value!;
        state = AsyncValue.data([export, ...exports]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteExport(String exportId) async {
    // TODO: Implementar cuando tengamos el repository configurado
    if (state.hasValue) {
      final exports = state.value!;
      final updatedExports = exports.where((e) => e.id != exportId).toList();
      state = AsyncValue.data(updatedExports);
    }
  }

  Future<void> cancelExport(String exportId) async {
    try {
      await _service.cancelExport(exportId);
      // Actualizar el estado de la exportación en la lista
      if (state.hasValue) {
        final exports = state.value!;
        final updatedExports = exports.map((export) {
          if (export.id == exportId) {
            return export.copyWith(status: TaskExportStatus.failed);
          }
          return export;
        }).toList();
        state = AsyncValue.data(updatedExports);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> downloadExport(String exportId) async {
    try {
      await _service.downloadExport(exportId);
      // La descarga se maneja externamente, no necesitamos actualizar el estado
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> quickExport({
    required TaskExportFormat format,
    required TaskExportFilters filters,
    List<String>? columns,
  }) async {
    try {
      final export = await _service.quickExport(
        format: format,
        filters: filters,
        columns: columns,
      );
      if (state.hasValue) {
        final exports = state.value!;
        state = AsyncValue.data([export, ...exports]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> exportProjectTasks({
    required String projectId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    try {
      final export = await _service.exportProjectTasks(
        projectId: projectId,
        format: format,
        additionalFilters: additionalFilters,
      );
      if (state.hasValue) {
        final exports = state.value!;
        state = AsyncValue.data([export, ...exports]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> exportMilestoneTasks({
    required String milestoneId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    try {
      final export = await _service.exportMilestoneTasks(
        milestoneId: milestoneId,
        format: format,
        additionalFilters: additionalFilters,
      );
      if (state.hasValue) {
        final exports = state.value!;
        state = AsyncValue.data([export, ...exports]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> exportUserTasks({
    required String userId,
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    try {
      final export = await _service.exportUserTasks(
        userId: userId,
        format: format,
        additionalFilters: additionalFilters,
      );
      if (state.hasValue) {
        final exports = state.value!;
        state = AsyncValue.data([export, ...exports]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> exportOverdueTasks({
    required TaskExportFormat format,
    TaskExportFilters? additionalFilters,
  }) async {
    try {
      final export = await _service.exportOverdueTasks(
        format: format,
        additionalFilters: additionalFilters,
      );
      if (state.hasValue) {
        final exports = state.value!;
        state = AsyncValue.data([export, ...exports]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> exportCompletedTasks({
    required TaskExportFormat format,
    DateTime? fromDate,
    DateTime? toDate,
    TaskExportFilters? additionalFilters,
  }) async {
    try {
      final export = await _service.exportCompletedTasks(
        format: format,
        fromDate: fromDate,
        toDate: toDate,
        additionalFilters: additionalFilters,
      );
      if (state.hasValue) {
        final exports = state.value!;
        state = AsyncValue.data([export, ...exports]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Provider para el notifier
final taskExportsNotifierProvider =
    StateNotifierProvider<TaskExportsNotifier, AsyncValue<List<TaskExport>>>(
        (ref) {
  // TODO: Implementar cuando tengamos el service configurado
  throw UnimplementedError('Service not configured yet');
});

// Providers para exportaciones específicas
final taskExportByIdProvider =
    FutureProvider.family<TaskExport?, String>((ref, id) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return null;
});

final exportStatisticsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  // TODO: Implementar cuando tengamos el service configurado
  return {};
});

final availableColumnsProvider =
    FutureProvider<List<TaskExportColumn>>((ref) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

final exportTemplatesProvider =
    FutureProvider<List<TaskExportTemplate>>((ref) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

// Providers para filtros de exportación
final exportFiltersProvider = StateProvider<TaskExportFiltersDto>((ref) {
  return const TaskExportFiltersDto();
});

final exportFormatProvider = StateProvider<TaskExportFormat>((ref) {
  return TaskExportFormat.excel;
});

final selectedColumnsProvider = StateProvider<List<String>>((ref) {
  return [
    'id',
    'title',
    'description',
    'status',
    'priority',
    'assignees',
    'dueDate',
    'createdAt',
  ];
});

// Providers para exportaciones por tipo
final projectExportsProvider =
    FutureProvider.family<List<TaskExport>, String>((ref, projectId) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

final userExportsProvider =
    FutureProvider.family<List<TaskExport>, String>((ref, userId) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

final milestoneExportsProvider =
    FutureProvider.family<List<TaskExport>, String>((ref, milestoneId) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

// Providers para exportaciones por estado
final pendingExportsProvider = FutureProvider<List<TaskExport>>((ref) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

final completedExportsProvider = FutureProvider<List<TaskExport>>((ref) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});

final failedExportsProvider = FutureProvider<List<TaskExport>>((ref) async {
  // TODO: Implementar cuando tengamos el repository configurado
  return [];
});
