import 'package:dio/dio.dart';
import 'package:fct_frontend/features/evaluations/data/datasources/evaluation_local_data_source.dart';
import 'package:fct_frontend/features/evaluations/data/datasources/evaluation_remote_data_source.dart';
import 'package:fct_frontend/features/evaluations/data/repositories/evaluation_repository_impl.dart';
import 'package:fct_frontend/features/evaluations/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/evaluations/domain/entities/evaluation_criteria.dart';
import 'package:fct_frontend/features/evaluations/domain/repositories/evaluation_repository.dart';
import 'package:fct_frontend/features/evaluations/domain/usecases/calculate_evaluation_score_usecase.dart';
import 'package:fct_frontend/features/evaluations/domain/usecases/create_evaluation_usecase.dart';
import 'package:fct_frontend/features/evaluations/domain/usecases/delete_evaluation_usecase.dart';
import 'package:fct_frontend/features/evaluations/domain/usecases/get_evaluation_criteria_usecase.dart';
import 'package:fct_frontend/features/evaluations/domain/usecases/get_evaluation_statistics_usecase.dart';
import 'package:fct_frontend/features/evaluations/domain/usecases/get_evaluations_usecase.dart';
import 'package:fct_frontend/features/evaluations/domain/usecases/update_evaluation_usecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'evaluation_providers.g.dart';

// Providers de inyección de dependencias
@riverpod
EvaluationRemoteDataSource evaluationRemoteDataSource(Ref ref) {
  return EvaluationRemoteDataSourceImpl(Dio());
}

@riverpod
EvaluationLocalDataSource evaluationLocalDataSource(Ref ref) {
  // Crear una instancia síncrona - esto es temporal hasta que se inicialice SharedPreferences
  return EvaluationLocalDataSourceImpl(null as dynamic);
}

@riverpod
EvaluationRepository evaluationRepository(Ref ref) {
  return EvaluationRepositoryImpl(
    ref.read(evaluationRemoteDataSourceProvider),
    ref.read(evaluationLocalDataSourceProvider),
  );
}

// Providers de casos de uso
@riverpod
GetEvaluationsUseCase getEvaluationsUseCase(Ref ref) {
  return GetEvaluationsUseCase(ref.read(evaluationRepositoryProvider));
}

@riverpod
CreateEvaluationUseCase createEvaluationUseCase(Ref ref) {
  return CreateEvaluationUseCase(ref.read(evaluationRepositoryProvider));
}

@riverpod
UpdateEvaluationUseCase updateEvaluationUseCase(Ref ref) {
  return UpdateEvaluationUseCase(ref.read(evaluationRepositoryProvider));
}

@riverpod
DeleteEvaluationUseCase deleteEvaluationUseCase(Ref ref) {
  return DeleteEvaluationUseCase(ref.read(evaluationRepositoryProvider));
}

@riverpod
GetEvaluationCriteriaUseCase getEvaluationCriteriaUseCase(Ref ref) {
  return GetEvaluationCriteriaUseCase(ref.read(evaluationRepositoryProvider));
}

@riverpod
CalculateEvaluationScoreUseCase calculateEvaluationScoreUseCase(Ref ref) {
  return const CalculateEvaluationScoreUseCase();
}

@riverpod
GetEvaluationStatisticsUseCase getEvaluationStatisticsUseCase(Ref ref) {
  return GetEvaluationStatisticsUseCase(ref.read(evaluationRepositoryProvider));
}

// Notifiers para gestión de estado
@riverpod
class EvaluationsNotifier extends _$EvaluationsNotifier {
  @override
  Future<List<Evaluation>> build() async {
    final useCase = ref.watch(getEvaluationsUseCaseProvider);
    return await useCase();
  }

  Future<void> loadEvaluations({
    String? anteprojectId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getEvaluationsUseCaseProvider);
      final evaluations = await useCase(
        anteprojectId: anteprojectId,
        evaluatorId: evaluatorId,
        status: status,
      );
      state = AsyncValue.data(evaluations);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createEvaluation(Evaluation evaluation) async {
    try {
      final useCase = ref.read(createEvaluationUseCaseProvider);
      await useCase(evaluation);
      // Recargar la lista después de crear
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateEvaluation(Evaluation evaluation) async {
    try {
      final useCase = ref.read(updateEvaluationUseCaseProvider);
      await useCase(evaluation);
      // Recargar la lista después de actualizar
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteEvaluation(String id) async {
    try {
      final useCase = ref.read(deleteEvaluationUseCaseProvider);
      await useCase(id);
      // Recargar la lista después de eliminar
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> submitEvaluation(String id) async {
    try {
      final repository = ref.read(evaluationRepositoryProvider);
      await repository.submitEvaluation(id);
      // Recargar la lista después de enviar
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> approveEvaluation(String id, String? comments) async {
    try {
      final repository = ref.read(evaluationRepositoryProvider);
      await repository.approveEvaluation(id, comments);
      // Recargar la lista después de aprobar
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> rejectEvaluation(String id, String reason) async {
    try {
      final repository = ref.read(evaluationRepositoryProvider);
      await repository.rejectEvaluation(id, reason);
      // Recargar la lista después de rechazar
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@riverpod
class EvaluationCriteriaNotifier extends _$EvaluationCriteriaNotifier {
  @override
  Future<List<EvaluationCriteria>> build() async {
    final useCase = ref.watch(getEvaluationCriteriaUseCaseProvider);
    return await useCase();
  }

  Future<void> loadCriteria() async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getEvaluationCriteriaUseCaseProvider);
      final criteria = await useCase();
      state = AsyncValue.data(criteria);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@riverpod
class EvaluationDetailNotifier extends _$EvaluationDetailNotifier {
  @override
  Future<Evaluation?> build(String id) async {
    final repository = ref.read(evaluationRepositoryProvider);
    return await repository.getEvaluationById(id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(evaluationRepositoryProvider);
      final evaluation = await repository.getEvaluationById(id);
      state = AsyncValue.data(evaluation);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@riverpod
class EvaluationStatisticsNotifier extends _$EvaluationStatisticsNotifier {
  @override
  Future<EvaluationStatistics?> build({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final useCase = ref.watch(getEvaluationStatisticsUseCaseProvider);
    return await useCase(
      evaluatorId: evaluatorId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> loadStatistics({
    String? evaluatorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getEvaluationStatisticsUseCaseProvider);
      final statistics = await useCase(
        evaluatorId: evaluatorId,
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncValue.data(statistics);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
