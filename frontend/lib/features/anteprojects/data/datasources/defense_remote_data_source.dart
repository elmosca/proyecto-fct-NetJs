import 'package:dio/dio.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';

abstract class DefenseRemoteDataSource {
  Future<List<Defense>> getDefenses({
    String? anteprojectId,
    String? studentId,
    String? tutorId,
    DefenseStatus? status,
  });

  Future<Defense> getDefenseById(String id);
  Future<Defense> createDefense(Defense defense);
  Future<Defense> updateDefense(Defense defense);
  Future<void> deleteDefense(String id);
  Future<Defense> scheduleDefense({
    required String anteprojectId,
    required String studentId,
    required String tutorId,
    required DateTime scheduledDate,
    String? location,
    String? notes,
  });
  Future<Defense> startDefense(String id);
  Future<Defense> completeDefense({
    required String id,
    required String evaluationComments,
    required double score,
  });
  Future<Defense> cancelDefense(String id, String reason);
  Future<List<Defense>> getStudentDefenses(String studentId);
  Future<List<Defense>> getTutorDefenses(String tutorId);
}

class DefenseRemoteDataSourceImpl implements DefenseRemoteDataSource {
  final Dio _dio;

  const DefenseRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Defense>> getDefenses({
    String? anteprojectId,
    String? studentId,
    String? tutorId,
    DefenseStatus? status,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (anteprojectId != null) queryParameters['anteprojectId'] = anteprojectId;
    if (studentId != null) queryParameters['studentId'] = studentId;
    if (tutorId != null) queryParameters['tutorId'] = tutorId;
    if (status != null) queryParameters['status'] = status.name;

    final response = await _dio.get('/defenses', queryParameters: queryParameters);
    final List<dynamic> data = response.data;
    return data.map((json) => Defense.fromJson(json)).toList();
  }

  @override
  Future<Defense> getDefenseById(String id) async {
    final response = await _dio.get('/defenses/$id');
    return Defense.fromJson(response.data);
  }

  @override
  Future<Defense> createDefense(Defense defense) async {
    final response = await _dio.post('/defenses', data: defense.toJson());
    return Defense.fromJson(response.data);
  }

  @override
  Future<Defense> updateDefense(Defense defense) async {
    final response = await _dio.put('/defenses/${defense.id}', data: defense.toJson());
    return Defense.fromJson(response.data);
  }

  @override
  Future<void> deleteDefense(String id) async {
    await _dio.delete('/defenses/$id');
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
    final data = {
      'anteprojectId': anteprojectId,
      'studentId': studentId,
      'tutorId': tutorId,
      'scheduledDate': scheduledDate.toIso8601String(),
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
    };

    final response = await _dio.post('/defenses/schedule', data: data);
    return Defense.fromJson(response.data);
  }

  @override
  Future<Defense> startDefense(String id) async {
    final response = await _dio.post('/defenses/$id/start');
    return Defense.fromJson(response.data);
  }

  @override
  Future<Defense> completeDefense({
    required String id,
    required String evaluationComments,
    required double score,
  }) async {
    final data = {
      'evaluationComments': evaluationComments,
      'score': score,
    };

    final response = await _dio.post('/defenses/$id/complete', data: data);
    return Defense.fromJson(response.data);
  }

  @override
  Future<Defense> cancelDefense(String id, String reason) async {
    final data = {'reason': reason};
    final response = await _dio.post('/defenses/$id/cancel', data: data);
    return Defense.fromJson(response.data);
  }

  @override
  Future<List<Defense>> getStudentDefenses(String studentId) async {
    final response = await _dio.get('/defenses/student/$studentId');
    final List<dynamic> data = response.data;
    return data.map((json) => Defense.fromJson(json)).toList();
  }

  @override
  Future<List<Defense>> getTutorDefenses(String tutorId) async {
    final response = await _dio.get('/defenses/tutor/$tutorId');
    final List<dynamic> data = response.data;
    return data.map((json) => Defense.fromJson(json)).toList();
  }
} 
