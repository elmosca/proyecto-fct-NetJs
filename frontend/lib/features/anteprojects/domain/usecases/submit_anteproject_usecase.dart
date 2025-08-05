import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class SubmitAnteprojectUseCase {
  final AnteprojectRepository _repository;

  SubmitAnteprojectUseCase(this._repository);

  Future<Anteproject> execute(String id) {
    if (id.isEmpty) {
      throw ArgumentError('El ID del anteproyecto es obligatorio');
    }

    return _repository.submitAnteproject(id);
  }
}
