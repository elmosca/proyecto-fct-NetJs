import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class UpdateProjectUseCase {
  final ProjectRepository _repository;

  const UpdateProjectUseCase(this._repository);

  Future<ProjectEntity> execute(ProjectEntity project) {
    return _repository.updateProject(project);
  }
}
