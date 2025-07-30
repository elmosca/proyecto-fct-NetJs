import 'package:fct_frontend/features/anteprojects/data/datasources/anteproject_remote_data_source.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/anteproject_repository.dart';

class AnteprojectRepositoryImpl implements AnteprojectRepository {
  final AnteprojectRemoteDataSource _remoteDataSource;

  AnteprojectRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Anteproject>> getAnteprojects({
    String? search,
    AnteprojectStatus? status,
    String? studentId,
    String? tutorId,
    int? page,
    int? limit,
  }) {
    return _remoteDataSource.getAnteprojects(
      search: search,
      status: status,
      studentId: studentId,
      tutorId: tutorId,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Anteproject> getAnteprojectById(String id) {
    return _remoteDataSource.getAnteprojectById(id);
  }

  @override
  Future<Anteproject> createAnteproject(Anteproject anteproject) {
    return _remoteDataSource.createAnteproject(anteproject);
  }

  @override
  Future<Anteproject> updateAnteproject(String id, Anteproject anteproject) {
    return _remoteDataSource.updateAnteproject(id, anteproject);
  }

  @override
  Future<void> deleteAnteproject(String id) {
    return _remoteDataSource.deleteAnteproject(id);
  }

  @override
  Future<Anteproject> submitAnteproject(String id) {
    return _remoteDataSource.submitAnteproject(id);
  }

  @override
  Future<Anteproject> approveAnteproject(String id, {String? comments}) {
    return _remoteDataSource.approveAnteproject(id, comments: comments);
  }

  @override
  Future<Anteproject> rejectAnteproject(String id, {required String comments}) {
    return _remoteDataSource.rejectAnteproject(id, comments: comments);
  }

  @override
  Future<Anteproject> scheduleDefense(
    String id, {
    required DateTime defenseDate,
    required String defenseLocation,
  }) {
    return _remoteDataSource.scheduleDefense(id, defenseDate, defenseLocation);
  }

  @override
  Future<Anteproject> completeDefense(String id, {double? grade}) {
    return _remoteDataSource.completeDefense(id, grade: grade);
  }

  @override
  Future<Map<String, dynamic>> getAnteprojectStats() {
    return _remoteDataSource.getAnteprojectStats();
  }

  @override
  Future<Anteproject> assignTutor(String anteprojectId, String tutorId) {
    return _remoteDataSource.assignTutor(anteprojectId, tutorId);
  }

  @override
  Future<String> uploadAttachment(String anteprojectId, String filePath) {
    return _remoteDataSource.uploadAttachment(anteprojectId, filePath);
  }

  @override
  Future<void> deleteAttachment(String anteprojectId, String attachmentId) {
    return _remoteDataSource.deleteAttachment(anteprojectId, attachmentId);
  }
}
