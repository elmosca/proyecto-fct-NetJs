import '../entities/project_entity.dart';

abstract class ProjectRepository {
  /// Obtiene todos los proyectos con filtros opcionales
  Future<List<ProjectEntity>> getProjects({
    String? search,
    ProjectStatus? status,
    String? createdBy,
    int? page,
    int? limit,
  });

  /// Obtiene un proyecto por su ID
  Future<ProjectEntity?> getProjectById(String id);

  /// Crea un nuevo proyecto
  Future<ProjectEntity> createProject(ProjectEntity project);

  /// Actualiza un proyecto existente
  Future<ProjectEntity> updateProject(ProjectEntity project);

  /// Elimina un proyecto
  Future<void> deleteProject(String id);

  /// Asigna estudiantes a un proyecto
  Future<ProjectEntity> assignStudents(
      String projectId, List<String> studentIds);

  /// Asigna tutores a un proyecto
  Future<ProjectEntity> assignTutors(String projectId, List<String> tutorIds);

  /// Actualiza el progreso de un proyecto
  Future<ProjectEntity> updateProgress(String projectId, int progress);

  /// Cambia el estado de un proyecto
  Future<ProjectEntity> updateStatus(String projectId, ProjectStatus status);

  /// Añade archivos adjuntos a un proyecto
  Future<ProjectEntity> addAttachments(
      String projectId, List<String> attachmentIds);

  /// Elimina archivos adjuntos de un proyecto
  Future<ProjectEntity> removeAttachments(
      String projectId, List<String> attachmentIds);
}
