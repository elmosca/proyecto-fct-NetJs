import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/approve_anteproject_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/create_anteproject_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/delete_anteproject_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_anteproject_by_id_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/get_anteprojects_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/reject_anteproject_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/submit_anteproject_usecase.dart';
import 'package:fct_frontend/features/anteprojects/domain/usecases/update_anteproject_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anteproject_providers.g.dart';

// Providers para casos de uso
@riverpod
GetAnteprojectsUseCase getAnteprojectsUseCase(GetAnteprojectsUseCaseRef ref) {
  return GetAnteprojectsUseCase(ref.watch(anteprojectRepositoryProvider));
}

@riverpod
GetAnteprojectByIdUseCase getAnteprojectByIdUseCase(
    GetAnteprojectByIdUseCaseRef ref) {
  return GetAnteprojectByIdUseCase(ref.watch(anteprojectRepositoryProvider));
}

@riverpod
CreateAnteprojectUseCase createAnteprojectUseCase(
    CreateAnteprojectUseCaseRef ref) {
  return CreateAnteprojectUseCase(ref.watch(anteprojectRepositoryProvider));
}

@riverpod
UpdateAnteprojectUseCase updateAnteprojectUseCase(
    UpdateAnteprojectUseCaseRef ref) {
  return UpdateAnteprojectUseCase(ref.watch(anteprojectRepositoryProvider));
}

@riverpod
DeleteAnteprojectUseCase deleteAnteprojectUseCase(
    DeleteAnteprojectUseCaseRef ref) {
  return DeleteAnteprojectUseCase(ref.watch(anteprojectRepositoryProvider));
}

@riverpod
SubmitAnteprojectUseCase submitAnteprojectUseCase(
    SubmitAnteprojectUseCaseRef ref) {
  return SubmitAnteprojectUseCase(ref.watch(anteprojectRepositoryProvider));
}

@riverpod
ApproveAnteprojectUseCase approveAnteprojectUseCase(
    ApproveAnteprojectUseCaseRef ref) {
  return ApproveAnteprojectUseCase(ref.watch(anteprojectRepositoryProvider));
}

@riverpod
RejectAnteprojectUseCase rejectAnteprojectUseCase(
    RejectAnteprojectUseCaseRef ref) {
  return RejectAnteprojectUseCase(ref.watch(anteprojectRepositoryProvider));
}

// Provider para el repositorio (se implementará en la inyección de dependencias)
@riverpod
AnteprojectRepository anteprojectRepository(AnteprojectRepositoryRef ref) {
  throw UnimplementedError(
      'Se debe configurar en la inyección de dependencias');
}

// Providers de estado
@riverpod
class AnteprojectsNotifier extends _$AnteprojectsNotifier {
  @override
  Future<List<Anteproject>> build({
    String? search,
    AnteprojectStatus? status,
    String? studentId,
    String? tutorId,
    int? page,
    int? limit,
  }) async {
    final useCase = ref.read(getAnteprojectsUseCaseProvider);
    return useCase.execute(
      search: search,
      status: status,
      studentId: studentId,
      tutorId: tutorId,
      page: page,
      limit: limit,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> createAnteproject(Anteproject anteproject) async {
    final useCase = ref.read(createAnteprojectUseCaseProvider);
    await useCase.execute(anteproject);
    ref.invalidateSelf();
  }

  Future<void> updateAnteproject(String id, Anteproject anteproject) async {
    final useCase = ref.read(updateAnteprojectUseCaseProvider);
    await useCase.execute(id, anteproject);
    ref.invalidateSelf();
  }

  Future<void> deleteAnteproject(String id) async {
    final useCase = ref.read(deleteAnteprojectUseCaseProvider);
    await useCase.execute(id);
    ref.invalidateSelf();
  }

  Future<void> submitAnteproject(String id) async {
    final useCase = ref.read(submitAnteprojectUseCaseProvider);
    await useCase.execute(id);
    ref.invalidateSelf();
  }

  Future<void> approveAnteproject(String id, {String? comments}) async {
    final useCase = ref.read(approveAnteprojectUseCaseProvider);
    await useCase.execute(id, comments: comments);
    ref.invalidateSelf();
  }

  Future<void> rejectAnteproject(String id, {required String comments}) async {
    final useCase = ref.read(rejectAnteprojectUseCaseProvider);
    await useCase.execute(id, comments: comments);
    ref.invalidateSelf();
  }
}

@riverpod
class AnteprojectDetailNotifier extends _$AnteprojectDetailNotifier {
  @override
  Future<Anteproject?> build(String id) async {
    if (id.isEmpty) return null;

    final useCase = ref.read(getAnteprojectByIdUseCaseProvider);
    return useCase.execute(id);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> updateAnteproject(Anteproject anteproject) async {
    final useCase = ref.read(updateAnteprojectUseCaseProvider);
    await useCase.execute(anteproject.id, anteproject);
    ref.invalidateSelf();
  }

  Future<void> submitAnteproject() async {
    final anteproject = state.value;
    if (anteproject == null) return;

    final useCase = ref.read(submitAnteprojectUseCaseProvider);
    await useCase.execute(anteproject.id);
    ref.invalidateSelf();
  }

  Future<void> approveAnteproject({String? comments}) async {
    final anteproject = state.value;
    if (anteproject == null) return;

    final useCase = ref.read(approveAnteprojectUseCaseProvider);
    await useCase.execute(anteproject.id, comments: comments);
    ref.invalidateSelf();
  }

  Future<void> rejectAnteproject({required String comments}) async {
    final anteproject = state.value;
    if (anteproject == null) return;

    final useCase = ref.read(rejectAnteprojectUseCaseProvider);
    await useCase.execute(anteproject.id, comments: comments);
    ref.invalidateSelf();
  }
}

// Provider para filtros de anteproyectos
@riverpod
class AnteprojectFiltersNotifier extends _$AnteprojectFiltersNotifier {
  @override
  AnteprojectFilters build() {
    return const AnteprojectFilters();
  }

  void updateSearch(String search) {
    state = state.copyWith(search: search);
  }

  void updateStatus(AnteprojectStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateStudentId(String? studentId) {
    state = state.copyWith(studentId: studentId);
  }

  void updateTutorId(String? tutorId) {
    state = state.copyWith(tutorId: tutorId);
  }

  void updatePage(int page) {
    state = state.copyWith(page: page);
  }

  void updateLimit(int limit) {
    state = state.copyWith(limit: limit);
  }

  void clearFilters() {
    state = const AnteprojectFilters();
  }
}

// Modelo para filtros
class AnteprojectFilters {
  final String? search;
  final AnteprojectStatus? status;
  final String? studentId;
  final String? tutorId;
  final int page;
  final int limit;

  const AnteprojectFilters({
    this.search,
    this.status,
    this.studentId,
    this.tutorId,
    this.page = 1,
    this.limit = 20,
  });

  AnteprojectFilters copyWith({
    String? search,
    AnteprojectStatus? status,
    String? studentId,
    String? tutorId,
    int? page,
    int? limit,
  }) {
    return AnteprojectFilters(
      search: search ?? this.search,
      status: status ?? this.status,
      studentId: studentId ?? this.studentId,
      tutorId: tutorId ?? this.tutorId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}
