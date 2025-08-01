import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class ApproveAnteprojectUseCase {
  final AnteprojectRepository _repository;

  ApproveAnteprojectUseCase(this._repository);

  Future<Anteproject> execute(String id, {String? comments}) {
    if (id.isEmpty) {
      throw ArgumentError('El ID del anteproyecto es obligatorio');
    }

    return _repository.approveAnteproject(id, comments: comments);
  }
}
