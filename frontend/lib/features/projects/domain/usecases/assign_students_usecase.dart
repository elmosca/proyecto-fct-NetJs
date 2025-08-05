import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class AssignStudentsUseCase {
  final ProjectRepository _repository;

  const AssignStudentsUseCase(this._repository);

  Future<ProjectEntity> execute(String projectId, List<String> studentIds) {
    return _repository.assignStudents(projectId, studentIds);
  }
}
