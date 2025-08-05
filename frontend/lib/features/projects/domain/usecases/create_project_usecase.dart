import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class CreateProjectUseCase {
  final ProjectRepository _repository;

  const CreateProjectUseCase(this._repository);

  Future<ProjectEntity> execute(ProjectEntity project) {
    return _repository.createProject(project);
  }
}
