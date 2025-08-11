import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class GetAnteprojectsUseCase {
  final AnteprojectRepository _repository;

  GetAnteprojectsUseCase(this._repository);

  Future<List<Anteproject>> execute({
    String? search,
    AnteprojectStatus? status,
    String? studentId,
    String? tutorId,
    int? page,
    int? limit,
  }) {
    return _repository.getAnteprojects(
      search: search,
      status: status,
      studentId: studentId,
      tutorId: tutorId,
      page: page,
      limit: limit,
    );
  }
} 
