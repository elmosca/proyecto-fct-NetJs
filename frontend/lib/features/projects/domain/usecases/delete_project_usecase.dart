import '../repositories/project_repository.dart';

class DeleteProjectUseCase {
  final ProjectRepository _repository;

  const DeleteProjectUseCase(this._repository);

  Future<void> execute(String projectId) {
    return _repository.deleteProject(projectId);
  }
}
