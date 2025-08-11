import 'package:fct_frontend/features/anteprojects/data/datasources/defense_remote_data_source.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/domain/repositories/defense_repository.dart';

class DefenseRepositoryImpl implements DefenseRepository {
  final DefenseRemoteDataSource _remoteDataSource;

  const DefenseRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Defense>> getDefenses({
    String? anteprojectId,
    String? studentId,
    String? tutorId,
    DefenseStatus? status,
  }) async {
    return await _remoteDataSource.getDefenses(
      anteprojectId: anteprojectId,
      studentId: studentId,
      tutorId: tutorId,
      status: status,
    );
  }

  @override
  Future<Defense> getDefenseById(String id) async {
    return await _remoteDataSource.getDefenseById(id);
  }

  @override
  Future<Defense> createDefense(Defense defense) async {
    return await _remoteDataSource.createDefense(defense);
  }

  @override
  Future<Defense> updateDefense(Defense defense) async {
    return await _remoteDataSource.updateDefense(defense);
  }

  @override
  Future<void> deleteDefense(String id) async {
    await _remoteDataSource.deleteDefense(id);
  }

  @override
  Future<Defense> scheduleDefense({
    required String anteprojectId,
    required String studentId,
    required String tutorId,
    required DateTime scheduledDate,
    String? location,
    String? notes,
  }) async {
    return await _remoteDataSource.scheduleDefense(
      anteprojectId: anteprojectId,
      studentId: studentId,
      tutorId: tutorId,
      scheduledDate: scheduledDate,
      location: location,
      notes: notes,
    );
  }

  @override
  Future<Defense> startDefense(String id) async {
    return await _remoteDataSource.startDefense(id);
  }

  @override
  Future<Defense> completeDefense({
    required String id,
    required String evaluationComments,
    required double score,
  }) async {
    return await _remoteDataSource.completeDefense(
      id: id,
      evaluationComments: evaluationComments,
      score: score,
    );
  }

  @override
  Future<Defense> cancelDefense(String id, String reason) async {
    return await _remoteDataSource.cancelDefense(id, reason);
  }

  @override
  Future<List<Defense>> getStudentDefenses(String studentId) async {
    return await _remoteDataSource.getStudentDefenses(studentId);
  }

  @override
  Future<List<Defense>> getTutorDefenses(String tutorId) async {
    return await _remoteDataSource.getTutorDefenses(tutorId);
  }
}
