import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class UpdateAnteprojectUseCase {
  final AnteprojectRepository _repository;

  UpdateAnteprojectUseCase(this._repository);

  Future<Anteproject> execute(String id, Anteproject anteproject) {
    // Validaciones de negocio
    if (anteproject.title.trim().isEmpty) {
      throw ArgumentError('El título del anteproyecto es obligatorio');
    }

    if (anteproject.description.trim().isEmpty) {
      throw ArgumentError('La descripción del anteproyecto es obligatoria');
    }

    // Solo se puede editar si está en estado draft
    if (anteproject.status != AnteprojectStatus.draft) {
      throw ArgumentError(
          'Solo se pueden editar anteproyectos en estado borrador');
    }

    final updatedAnteproject = anteproject.copyWith(
      updatedAt: DateTime.now(),
    );

    return _repository.updateAnteproject(id, updatedAnteproject);
  }
}
