import 'package:dio/dio.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';

abstract class AnteprojectRemoteDataSource {
  Future<List<Anteproject>> getAnteprojects({
    String? search,
    AnteprojectStatus? status,
    String? studentId,
    String? tutorId,
    int? page,
    int? limit,
  });

  Future<Anteproject> getAnteprojectById(String id);
  Future<Anteproject> createAnteproject(Anteproject anteproject);
  Future<Anteproject> updateAnteproject(String id, Anteproject anteproject);
  Future<void> deleteAnteproject(String id);
  Future<Anteproject> submitAnteproject(String id);
  Future<Anteproject> approveAnteproject(String id, {String? comments});
  Future<Anteproject> rejectAnteproject(String id, {required String comments});
  Future<Anteproject> scheduleDefense(
      String id, DateTime defenseDate, String defenseLocation);
  Future<Anteproject> completeDefense(String id, {double? grade});
  Future<Map<String, dynamic>> getAnteprojectStats();
  Future<Anteproject> assignTutor(String anteprojectId, String tutorId);
  Future<String> uploadAttachment(String anteprojectId, String filePath);
  Future<void> deleteAttachment(String anteprojectId, String attachmentId);
}

class AnteprojectRemoteDataSourceImpl implements AnteprojectRemoteDataSource {
  final Dio _dio;

  AnteprojectRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Anteproject>> getAnteprojects({
    String? search,
    AnteprojectStatus? status,
    String? studentId,
    String? tutorId,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (status != null) {
        queryParameters['status'] = status.name;
      }
      if (studentId != null && studentId.isNotEmpty) {
        queryParameters['studentId'] = studentId;
      }
      if (tutorId != null && tutorId.isNotEmpty) {
        queryParameters['tutorId'] = tutorId;
      }
      if (page != null) {
        queryParameters['page'] = page;
      }
      if (limit != null) {
        queryParameters['limit'] = limit;
      }

      final response =
          await _dio.get('/anteprojects', queryParameters: queryParameters);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Anteproject.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener anteproyectos: $e');
    }
  }

  @override
  Future<Anteproject> getAnteprojectById(String id) async {
    try {
      final response = await _dio.get('/anteprojects/$id');
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener anteproyecto: $e');
    }
  }

  @override
  Future<Anteproject> createAnteproject(Anteproject anteproject) async {
    try {
      final response =
          await _dio.post('/anteprojects', data: anteproject.toJson());
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear anteproyecto: $e');
    }
  }

  @override
  Future<Anteproject> updateAnteproject(
      String id, Anteproject anteproject) async {
    try {
      final response =
          await _dio.put('/anteprojects/$id', data: anteproject.toJson());
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar anteproyecto: $e');
    }
  }

  @override
  Future<void> deleteAnteproject(String id) async {
    try {
      await _dio.delete('/anteprojects/$id');
    } catch (e) {
      throw Exception('Error al eliminar anteproyecto: $e');
    }
  }

  @override
  Future<Anteproject> submitAnteproject(String id) async {
    try {
      final response = await _dio.post('/anteprojects/$id/submit');
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al enviar anteproyecto: $e');
    }
  }

  @override
  Future<Anteproject> approveAnteproject(String id, {String? comments}) async {
    try {
      final response = await _dio.post('/anteprojects/$id/approve', data: {
        'comments': comments,
      });
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al aprobar anteproyecto: $e');
    }
  }

  @override
  Future<Anteproject> rejectAnteproject(String id,
      {required String comments}) async {
    try {
      final response = await _dio.post('/anteprojects/$id/reject', data: {
        'comments': comments,
      });
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al rechazar anteproyecto: $e');
    }
  }

  @override
  Future<Anteproject> scheduleDefense(
      String id, DateTime defenseDate, String defenseLocation) async {
    try {
      final response =
          await _dio.post('/anteprojects/$id/schedule-defense', data: {
        'defenseDate': defenseDate.toIso8601String(),
        'defenseLocation': defenseLocation,
      });
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al programar defensa: $e');
    }
  }

  @override
  Future<Anteproject> completeDefense(String id, {double? grade}) async {
    try {
      final response =
          await _dio.post('/anteprojects/$id/complete-defense', data: {
        'grade': grade,
      });
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al completar defensa: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAnteprojectStats() async {
    try {
      final response = await _dio.get('/anteprojects/stats');
      return response.data;
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  @override
  Future<Anteproject> assignTutor(String anteprojectId, String tutorId) async {
    try {
      final response =
          await _dio.post('/anteprojects/$anteprojectId/assign-tutor', data: {
        'tutorId': tutorId,
      });
      return Anteproject.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al asignar tutor: $e');
    }
  }

  @override
  Future<String> uploadAttachment(String anteprojectId, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio
          .post('/anteprojects/$anteprojectId/attachments', data: formData);
      return response.data['attachmentId'];
    } catch (e) {
      throw Exception('Error al subir archivo: $e');
    }
  }

  @override
  Future<void> deleteAttachment(
      String anteprojectId, String attachmentId) async {
    try {
      await _dio
          .delete('/anteprojects/$anteprojectId/attachments/$attachmentId');
    } catch (e) {
      throw Exception('Error al eliminar archivo: $e');
    }
  }
}
