import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class DeleteAnteprojectUseCase {
  final AnteprojectRepository _repository;

  DeleteAnteprojectUseCase(this._repository);

  Future<void> execute(String id) {
    // Validaciones de negocio
    if (id.isEmpty) {
      throw ArgumentError('El ID del anteproyecto es obligatorio');
    }

    return _repository.deleteAnteproject(id);
  }
}
