import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/task_report_remote_datasource.dart';
import '../../data/repositories/task_report_repository_impl.dart';
import '../../domain/entities/task_report_dto.dart';
import '../../domain/entities/task_report_entity.dart';
import '../../domain/repositories/task_report_repository.dart';
import '../../domain/services/task_report_service.dart';
import '../../domain/usecases/generate_task_report_usecase.dart';

part 'task_report_providers.g.dart';

// Data Source Provider
@riverpod
TaskReportRemoteDataSource taskReportRemoteDataSource(
    TaskReportRemoteDataSourceRef ref) {
  final dio = GetIt.instance<Dio>();
  return TaskReportRemoteDataSourceImpl(dio);
}

// Repository Provider
@riverpod
TaskReportRepository taskReportRepository(TaskReportRepositoryRef ref) {
  final remoteDataSource = ref.watch(taskReportRemoteDataSourceProvider);
  return TaskReportRepositoryImpl(remoteDataSource);
}

// Service Provider
@riverpod
TaskReportService taskReportService(TaskReportServiceRef ref) {
  final repository = ref.watch(taskReportRepositoryProvider);
  return TaskReportService(repository);
}

// Use Cases Providers
@riverpod
GenerateTaskReportUseCase generateTaskReportUseCase(
    GenerateTaskReportUseCaseRef ref) {
  final repository = ref.watch(taskReportRepositoryProvider);
  return GenerateTaskReportUseCase(repository);
}

// Notifier para gestionar el estado de los reportes
@riverpod
class TaskReportsNotifier extends _$TaskReportsNotifier {
  @override
  Future<List<TaskReport>> build() async {
    final repository = ref.read(taskReportRepositoryProvider);
    final filters = TaskReportFiltersDto();
    return await repository.getTaskReports(filters);
  }

  Future<void> generateReport(CreateTaskReportDto dto) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskReportRepositoryProvider);
      final newReport = await repository.createTaskReport(dto);

      // Actualizar la lista de reportes
      final currentReports = state.value ?? [];
      state = AsyncValue.data([newReport, ...currentReports]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshReports([TaskReportFiltersDto? filters]) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(taskReportRepositoryProvider);
      final reports =
          await repository.getTaskReports(filters ?? TaskReportFiltersDto());
      state = AsyncValue.data(reports);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      final repository = ref.read(taskReportRepositoryProvider);
      await repository.deleteTaskReport(id);

      // Remover el reporte de la lista
      final currentReports = state.value ?? [];
      final updatedReports =
          currentReports.where((report) => report.id != id).toList();
      state = AsyncValue.data(updatedReports);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> exportReport(String id, TaskReportExportDto dto) async {
    try {
      final repository = ref.read(taskReportRepositoryProvider);
      await repository.exportReport(dto);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> scheduleReport(String id, String schedule) async {
    try {
      final repository = ref.read(taskReportRepositoryProvider);
      await repository.scheduleReport(id, schedule);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> cancelScheduledReport(String id) async {
    try {
      final repository = ref.read(taskReportRepositoryProvider);
      await repository.cancelScheduledReport(id);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Provider para reportes específicos por ID
@riverpod
Future<TaskReport?> taskReportById(TaskReportByIdRef ref, String id) async {
  final repository = ref.watch(taskReportRepositoryProvider);
  return await repository.getTaskReportById(id);
}

// Provider para estadísticas de reportes
@riverpod
Future<Map<String, dynamic>> taskReportStatistics(
  TaskReportStatisticsRef ref, {
  String? projectId,
  DateTime? fromDate,
  DateTime? toDate,
}) async {
  final repository = ref.watch(taskReportRepositoryProvider);
  return await repository.getReportStatistics(
    projectId: projectId,
    fromDate: fromDate,
    toDate: toDate,
  );
}

// Provider para reportes programados
@riverpod
Future<List<TaskReportScheduleDto>> scheduledTaskReports(
    ScheduledTaskReportsRef ref) async {
  final repository = ref.watch(taskReportRepositoryProvider);
  return await repository.getScheduledReports();
}

// Provider para reportes expirados
@riverpod
Future<List<TaskReport>> expiredTaskReports(ExpiredTaskReportsRef ref) async {
  final repository = ref.watch(taskReportRepositoryProvider);
  return await repository.getExpiredReports();
}
