import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class AssignTutorsUseCase {
  final ProjectRepository _repository;

  const AssignTutorsUseCase(this._repository);

  Future<ProjectEntity> execute(String projectId, List<String> tutorIds) {
    return _repository.assignTutors(projectId, tutorIds);
  }
}
