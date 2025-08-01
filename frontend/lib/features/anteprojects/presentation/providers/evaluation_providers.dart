import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation_criteria.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/evaluation_repository.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/create_evaluation_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_evaluation_criteria_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_evaluations_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/submit_evaluation_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'evaluation_providers.g.dart';

// Provider para el repositorio (se implementará en la inyección de dependencias)
@riverpod
EvaluationRepository evaluationRepository(EvaluationRepositoryRef ref) {
  throw UnimplementedError(
      'Se debe configurar en la inyección de dependencias');
}

// Providers para casos de uso
@riverpod
GetEvaluationsUseCase getEvaluationsUseCase(GetEvaluationsUseCaseRef ref) {
  final repository = ref.watch(evaluationRepositoryProvider);
  return GetEvaluationsUseCase(repository);
}

@riverpod
CreateEvaluationUseCase createEvaluationUseCase(
    CreateEvaluationUseCaseRef ref) {
  final repository = ref.watch(evaluationRepositoryProvider);
  return CreateEvaluationUseCase(repository);
}

@riverpod
SubmitEvaluationUseCase submitEvaluationUseCase(
    SubmitEvaluationUseCaseRef ref) {
  final repository = ref.watch(evaluationRepositoryProvider);
  return SubmitEvaluationUseCase(repository);
}

@riverpod
GetEvaluationCriteriaUseCase getEvaluationCriteriaUseCase(
    GetEvaluationCriteriaUseCaseRef ref) {
  final repository = ref.watch(evaluationRepositoryProvider);
  return GetEvaluationCriteriaUseCase(repository);
}

// Notifier para gestionar la lista de evaluaciones
@riverpod
class EvaluationsNotifier extends _$EvaluationsNotifier {
  @override
  Future<List<Evaluation>> build() async {
    final useCase = ref.watch(getEvaluationsUseCaseProvider);
    return await useCase();
  }

  Future<void> loadEvaluations({
    String? defenseId,
    String? evaluatorId,
    EvaluationStatus? status,
  }) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getEvaluationsUseCaseProvider);
      final evaluations = await useCase(
        defenseId: defenseId,
        evaluatorId: evaluatorId,
        status: status,
      );
      state = AsyncValue.data(evaluations);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createEvaluation({
    required String defenseId,
    required String evaluatorId,
    required List<EvaluationScore> scores,
    required String comments,
  }) async {
    try {
      final useCase = ref.read(createEvaluationUseCaseProvider);
      await useCase(
        defenseId: defenseId,
        evaluatorId: evaluatorId,
        scores: scores,
        comments: comments,
      );
      // Recargar la lista después de crear
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> submitEvaluation(String evaluationId) async {
    try {
      final useCase = ref.read(submitEvaluationUseCaseProvider);
      await useCase(evaluationId);
      // Recargar la lista después de enviar
      await loadEvaluations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Notifier para gestionar una evaluación específica
@riverpod
class EvaluationDetailNotifier extends _$EvaluationDetailNotifier {
  @override
  Future<Evaluation?> build(String evaluationId) async {
    if (evaluationId.isEmpty) return null;

    final repository = ref.watch(evaluationRepositoryProvider);
    return await repository.getEvaluationById(evaluationId);
  }

  Future<void> refresh() async {
    if (state.value != null) {
      state = const AsyncValue.loading();
      try {
        final repository = ref.read(evaluationRepositoryProvider);
        final evaluation = await repository.getEvaluationById(state.value!.id);
        state = AsyncValue.data(evaluation);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

// Notifier para gestionar los criterios de evaluación
@riverpod
class EvaluationCriteriaNotifier extends _$EvaluationCriteriaNotifier {
  @override
  Future<List<EvaluationCriteria>> build() async {
    final useCase = ref.watch(getEvaluationCriteriaUseCaseProvider);
    return await useCase();
  }

  Future<void> refresh() async {
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

// Notifier para filtros de evaluaciones
@riverpod
class EvaluationFiltersNotifier extends _$EvaluationFiltersNotifier {
  @override
  EvaluationFilters build() {
    return const EvaluationFilters();
  }

  void updateSearch(String search) {
    state = state.copyWith(search: search);
  }

  void updateStatus(EvaluationStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateDefenseId(String? defenseId) {
    state = state.copyWith(defenseId: defenseId);
  }

  void updateEvaluatorId(String? evaluatorId) {
    state = state.copyWith(evaluatorId: evaluatorId);
  }

  void clearFilters() {
    state = const EvaluationFilters();
  }
}

// Modelo para filtros de evaluaciones
class EvaluationFilters {
  final String search;
  final EvaluationStatus? status;
  final String? defenseId;
  final String? evaluatorId;

  const EvaluationFilters({
    this.search = '',
    this.status,
    this.defenseId,
    this.evaluatorId,
  });

  EvaluationFilters copyWith({
    String? search,
    EvaluationStatus? status,
    String? defenseId,
    String? evaluatorId,
  }) {
    return EvaluationFilters(
      search: search ?? this.search,
      status: status ?? this.status,
      defenseId: defenseId ?? this.defenseId,
      evaluatorId: evaluatorId ?? this.evaluatorId,
    );
  }

  bool get hasFilters =>
      search.isNotEmpty ||
      status != null ||
      defenseId != null ||
      evaluatorId != null;
}
