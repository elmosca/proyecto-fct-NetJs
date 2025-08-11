import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetProjectsUseCase {
  final ProjectRepository _repository;

  const GetProjectsUseCase(this._repository);

  Future<List<ProjectEntity>> execute({
    String? search,
    ProjectStatus? status,
    String? createdBy,
    int? page,
    int? limit,
  }) {
    return _repository.getProjects(
      search: search,
      status: status,
      createdBy: createdBy,
      page: page,
      limit: limit,
    );
  }
}
