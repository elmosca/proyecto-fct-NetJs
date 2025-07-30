import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class CreateAnteprojectUseCase {
  final AnteprojectRepository _repository;

  CreateAnteprojectUseCase(this._repository);

  Future<Anteproject> execute(Anteproject anteproject) {
    // Validaciones de negocio
    if (anteproject.title.trim().isEmpty) {
      throw ArgumentError('El título del anteproyecto es obligatorio');
    }
    
    if (anteproject.description.trim().isEmpty) {
      throw ArgumentError('La descripción del anteproyecto es obligatoria');
    }
    
    if (anteproject.studentId.isEmpty) {
      throw ArgumentError('El ID del estudiante es obligatorio');
    }

    // Asegurar que el estado inicial sea draft
    final anteprojectWithDraftStatus = anteproject.copyWith(
      status: AnteprojectStatus.draft,
      createdAt: DateTime.now(),
    );

    return _repository.createAnteproject(anteprojectWithDraftStatus);
  }
} 