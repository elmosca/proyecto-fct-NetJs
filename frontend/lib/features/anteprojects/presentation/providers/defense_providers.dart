import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/defense_repository.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/complete_defense_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_defenses_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/schedule_defense_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/start_defense_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'defense_providers.g.dart';

// Provider para el repositorio (se implementará en la inyección de dependencias)
@riverpod
DefenseRepository defenseRepository(DefenseRepositoryRef ref) {
  throw UnimplementedError(
      'Se debe configurar en la inyección de dependencias');
}

// Providers para casos de uso
@riverpod
GetDefensesUseCase getDefensesUseCase(GetDefensesUseCaseRef ref) {
  final repository = ref.watch(defenseRepositoryProvider);
  return GetDefensesUseCase(repository);
}

@riverpod
ScheduleDefenseUseCase scheduleDefenseUseCase(ScheduleDefenseUseCaseRef ref) {
  final repository = ref.watch(defenseRepositoryProvider);
  return ScheduleDefenseUseCase(repository);
}

@riverpod
StartDefenseUseCase startDefenseUseCase(StartDefenseUseCaseRef ref) {
  final repository = ref.watch(defenseRepositoryProvider);
  return StartDefenseUseCase(repository);
}

@riverpod
CompleteDefenseUseCase completeDefenseUseCase(CompleteDefenseUseCaseRef ref) {
  final repository = ref.watch(defenseRepositoryProvider);
  return CompleteDefenseUseCase(repository);
}

// Notifier para gestionar la lista de defensas
@riverpod
class DefensesNotifier extends _$DefensesNotifier {
  @override
  Future<List<Defense>> build() async {
    final useCase = ref.watch(getDefensesUseCaseProvider);
    return await useCase();
  }

  Future<void> loadDefenses({
    String? anteprojectId,
    String? studentId,
    String? tutorId,
    DefenseStatus? status,
  }) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getDefensesUseCaseProvider);
      final defenses = await useCase(
        anteprojectId: anteprojectId,
        studentId: studentId,
        tutorId: tutorId,
        status: status,
      );
      state = AsyncValue.data(defenses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> scheduleDefense({
    required String anteprojectId,
    required String studentId,
    required String tutorId,
    required DateTime scheduledDate,
    String? location,
    String? notes,
  }) async {
    try {
      final useCase = ref.read(scheduleDefenseUseCaseProvider);
      await useCase(
        anteprojectId: anteprojectId,
        studentId: studentId,
        tutorId: tutorId,
        scheduledDate: scheduledDate,
        location: location,
        notes: notes,
      );
      // Recargar la lista después de programar
      await loadDefenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> startDefense(String defenseId) async {
    try {
      final useCase = ref.read(startDefenseUseCaseProvider);
      await useCase(defenseId);
      // Recargar la lista después de iniciar
      await loadDefenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> completeDefense({
    required String defenseId,
    required String evaluationComments,
    required double score,
  }) async {
    try {
      final useCase = ref.read(completeDefenseUseCaseProvider);
      await useCase(
        defenseId: defenseId,
        evaluationComments: evaluationComments,
        score: score,
      );
      // Recargar la lista después de completar
      await loadDefenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Notifier para gestionar una defensa específica
@riverpod
class DefenseDetailNotifier extends _$DefenseDetailNotifier {
  @override
  Future<Defense?> build(String defenseId) async {
    if (defenseId.isEmpty) return null;

    final repository = ref.watch(defenseRepositoryProvider);
    return await repository.getDefenseById(defenseId);
  }

  Future<void> refresh() async {
    if (state.value != null) {
      state = const AsyncValue.loading();
      try {
        final repository = ref.read(defenseRepositoryProvider);
        final defense = await repository.getDefenseById(state.value!.id);
        state = AsyncValue.data(defense);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

// Notifier para filtros de defensas
@riverpod
class DefenseFiltersNotifier extends _$DefenseFiltersNotifier {
  @override
  DefenseFilters build() {
    return const DefenseFilters();
  }

  void updateSearch(String search) {
    state = state.copyWith(search: search);
  }

  void updateStatus(DefenseStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateAnteprojectId(String? anteprojectId) {
    state = state.copyWith(anteprojectId: anteprojectId);
  }

  void updateStudentId(String? studentId) {
    state = state.copyWith(studentId: studentId);
  }

  void updateTutorId(String? tutorId) {
    state = state.copyWith(tutorId: tutorId);
  }

  void clearFilters() {
    state = const DefenseFilters();
  }
}

// Modelo para filtros de defensas
class DefenseFilters {
  final String search;
  final DefenseStatus? status;
  final String? anteprojectId;
  final String? studentId;
  final String? tutorId;

  const DefenseFilters({
    this.search = '',
    this.status,
    this.anteprojectId,
    this.studentId,
    this.tutorId,
  });

  DefenseFilters copyWith({
    String? search,
    DefenseStatus? status,
    String? anteprojectId,
    String? studentId,
    String? tutorId,
  }) {
    return DefenseFilters(
      search: search ?? this.search,
      status: status ?? this.status,
      anteprojectId: anteprojectId ?? this.anteprojectId,
      studentId: studentId ?? this.studentId,
      tutorId: tutorId ?? this.tutorId,
    );
  }

  bool get hasFilters =>
      search.isNotEmpty ||
      status != null ||
      anteprojectId != null ||
      studentId != null ||
      tutorId != null;
}
