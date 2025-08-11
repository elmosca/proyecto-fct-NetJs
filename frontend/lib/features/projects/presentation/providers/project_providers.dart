import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/project_repository_impl.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/assign_students_usecase.dart';
import '../../domain/usecases/assign_tutors_usecase.dart';
import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/delete_project_usecase.dart';
import '../../domain/usecases/get_projects_usecase.dart';
import '../../domain/usecases/update_project_usecase.dart';

part 'project_providers.freezed.dart';
part 'project_providers.g.dart';

// Estados de los proyectos
@freezed
class ProjectsState with _$ProjectsState {
  const factory ProjectsState({
    @Default([]) List<ProjectEntity> projects,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
    @Default(1) int currentPage,
    @Default(false) bool hasMorePages,
    @Default('') String searchQuery,
    ProjectStatus? selectedStatus,
  }) = _ProjectsState;
}

@freezed
class ProjectDetailState with _$ProjectDetailState {
  const factory ProjectDetailState({
    ProjectEntity? project,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _ProjectDetailState;
}

// Providers de casos de uso
@riverpod
GetProjectsUseCase getProjectsUseCase(GetProjectsUseCaseRef ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return GetProjectsUseCase(repository);
}

@riverpod
CreateProjectUseCase createProjectUseCase(CreateProjectUseCaseRef ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return CreateProjectUseCase(repository);
}

@riverpod
UpdateProjectUseCase updateProjectUseCase(UpdateProjectUseCaseRef ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return UpdateProjectUseCase(repository);
}

@riverpod
DeleteProjectUseCase deleteProjectUseCase(DeleteProjectUseCaseRef ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return DeleteProjectUseCase(repository);
}

@riverpod
AssignStudentsUseCase assignStudentsUseCase(AssignStudentsUseCaseRef ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return AssignStudentsUseCase(repository);
}

@riverpod
AssignTutorsUseCase assignTutorsUseCase(AssignTutorsUseCaseRef ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return AssignTutorsUseCase(repository);
}

// Provider del repositorio (implementación mock)
@riverpod
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  return ProjectRepositoryImpl();
}

// Provider principal de la lista de proyectos
@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  FutureOr<ProjectsState> build() {
    return _loadProjects();
  }

  Future<ProjectsState> _loadProjects({
    String? search,
    ProjectStatus? status,
    int? page,
  }) async {
    try {
      state = const AsyncValue.loading();

      final useCase = ref.read(getProjectsUseCaseProvider);
      final projects = await useCase.execute(
        search: search,
        status: status,
        page: page ?? 1,
        limit: 20,
      );

      final currentState = state.value ?? const ProjectsState();

      return currentState.copyWith(
        projects:
            page == 1 ? projects : [...currentState.projects, ...projects],
        isLoading: false,
        hasError: false,
        errorMessage: null,
        currentPage: page ?? 1,
        hasMorePages: projects.length == 20,
        searchQuery: search ?? currentState.searchQuery,
        selectedStatus: status ?? currentState.selectedStatus,
      );
    } catch (e) {
      return const ProjectsState(
        hasError: true,
        errorMessage: 'Error al cargar los proyectos',
      );
    }
  }

  Future<void> loadProjects({
    String? search,
    ProjectStatus? status,
  }) async {
    final newState = await _loadProjects(
      search: search,
      status: status,
      page: 1,
    );
    state = AsyncValue.data(newState);
  }

  Future<void> loadMoreProjects() async {
    final currentState = state.value;
    if (currentState == null ||
        currentState.isLoading ||
        !currentState.hasMorePages) {
      return;
    }

    final newState = await _loadProjects(
      search: currentState.searchQuery,
      status: currentState.selectedStatus,
      page: currentState.currentPage + 1,
    );
    state = AsyncValue.data(newState);
  }

  Future<void> createProject(ProjectEntity project) async {
    try {
      state = const AsyncValue.loading();

      final useCase = ref.read(createProjectUseCaseProvider);
      await useCase.execute(project);

      // Recargar la lista de proyectos
      await loadProjects();
    } catch (e) {
      final currentState = state.value ?? const ProjectsState();
      state = AsyncValue.data(currentState.copyWith(
        hasError: true,
        errorMessage: 'Error al crear el proyecto',
      ));
    }
  }

  Future<void> updateProject(ProjectEntity project) async {
    try {
      state = const AsyncValue.loading();

      final useCase = ref.read(updateProjectUseCaseProvider);
      await useCase.execute(project);

      // Actualizar el proyecto en la lista
      final currentState = state.value ?? const ProjectsState();
      final updatedProjects = currentState.projects.map((p) {
        return p.id == project.id ? project : p;
      }).toList();

      state = AsyncValue.data(currentState.copyWith(
        projects: updatedProjects,
        isLoading: false,
        hasError: false,
        errorMessage: null,
      ));
    } catch (e) {
      final currentState = state.value ?? const ProjectsState();
      state = AsyncValue.data(currentState.copyWith(
        hasError: true,
        errorMessage: 'Error al actualizar el proyecto',
      ));
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      state = const AsyncValue.loading();

      final useCase = ref.read(deleteProjectUseCaseProvider);
      await useCase.execute(projectId);

      // Remover el proyecto de la lista
      final currentState = state.value ?? const ProjectsState();
      final updatedProjects =
          currentState.projects.where((p) => p.id != projectId).toList();

      state = AsyncValue.data(currentState.copyWith(
        projects: updatedProjects,
        isLoading: false,
        hasError: false,
        errorMessage: null,
      ));
    } catch (e) {
      final currentState = state.value ?? const ProjectsState();
      state = AsyncValue.data(currentState.copyWith(
        hasError: true,
        errorMessage: 'Error al eliminar el proyecto',
      ));
    }
  }

  Future<void> assignStudents(String projectId, List<String> studentIds) async {
    try {
      final useCase = ref.read(assignStudentsUseCaseProvider);
      final updatedProject = await useCase.execute(projectId, studentIds);

      // Actualizar el proyecto en la lista
      final currentState = state.value ?? const ProjectsState();
      final updatedProjects = currentState.projects.map((p) {
        return p.id == projectId ? updatedProject : p;
      }).toList();

      state = AsyncValue.data(currentState.copyWith(
        projects: updatedProjects,
        hasError: false,
        errorMessage: null,
      ));
    } catch (e) {
      final currentState = state.value ?? const ProjectsState();
      state = AsyncValue.data(currentState.copyWith(
        hasError: true,
        errorMessage: 'Error al asignar estudiantes',
      ));
    }
  }

  Future<void> assignTutors(String projectId, List<String> tutorIds) async {
    try {
      final useCase = ref.read(assignTutorsUseCaseProvider);
      final updatedProject = await useCase.execute(projectId, tutorIds);

      // Actualizar el proyecto en la lista
      final currentState = state.value ?? const ProjectsState();
      final updatedProjects = currentState.projects.map((p) {
        return p.id == projectId ? updatedProject : p;
      }).toList();

      state = AsyncValue.data(currentState.copyWith(
        projects: updatedProjects,
        hasError: false,
        errorMessage: null,
      ));
    } catch (e) {
      final currentState = state.value ?? const ProjectsState();
      state = AsyncValue.data(currentState.copyWith(
        hasError: true,
        errorMessage: 'Error al asignar tutores',
      ));
    }
  }

  void clearError() {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(
        hasError: false,
        errorMessage: null,
      ));
    }
  }
}

// Provider para el detalle de un proyecto específico
@riverpod
class ProjectDetailNotifier extends _$ProjectDetailNotifier {
  @override
  FutureOr<ProjectDetailState> build(String projectId) {
    return _loadProject(projectId);
  }

  Future<ProjectDetailState> _loadProject(String projectId) async {
    try {
      final repository = ref.read(projectRepositoryProvider);
      final project = await repository.getProjectById(projectId);

      if (project == null) {
        return const ProjectDetailState(
          hasError: true,
          errorMessage: 'Proyecto no encontrado',
        );
      }

      return ProjectDetailState(
        project: project,
        isLoading: false,
        hasError: false,
      );
    } catch (e) {
      return const ProjectDetailState(
        hasError: true,
        errorMessage: 'Error al cargar el proyecto',
      );
    }
  }

  Future<void> refreshProject() async {
    final projectId = state.value?.project?.id;
    if (projectId != null) {
      final newState = await _loadProject(projectId);
      state = AsyncValue.data(newState);
    }
  }
}
