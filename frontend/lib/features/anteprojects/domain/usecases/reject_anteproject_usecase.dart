import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class RejectAnteprojectUseCase {
  final AnteprojectRepository _repository;

  RejectAnteprojectUseCase(this._repository);

  Future<Anteproject> execute(String id, {required String comments}) {
    if (id.isEmpty) {
      throw ArgumentError('El ID del anteproyecto es obligatorio');
    }

    if (comments.trim().isEmpty) {
      throw ArgumentError('Los comentarios de rechazo son obligatorios');
    }

    return _repository.rejectAnteproject(id, comments: comments);
  }
}
