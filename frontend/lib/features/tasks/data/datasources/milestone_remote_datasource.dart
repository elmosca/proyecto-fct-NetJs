import 'package:dio/dio.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';

abstract class MilestoneRemoteDataSource {
  Future<List<MilestoneEntity>> getMilestones(MilestoneFiltersDto filters);
  Future<MilestoneEntity> getMilestoneById(String milestoneId);
  Future<MilestoneEntity> createMilestone(
      CreateMilestoneDto createMilestoneDto);
  Future<MilestoneEntity> updateMilestone(
      String milestoneId, UpdateMilestoneDto updateMilestoneDto);
  Future<void> deleteMilestone(String milestoneId);
  Future<List<MilestoneEntity>> getMilestonesByProject(String projectId);
  Future<MilestoneEntity> updateMilestoneStatus(
      String milestoneId, MilestoneStatus status);
  Future<MilestoneEntity> completeMilestone(String milestoneId);
  Future<Map<String, dynamic>> getMilestoneStatistics(String? projectId);
  Future<MilestoneEntity?> getNextPendingMilestone(String projectId);
  Future<List<MilestoneEntity>> getDelayedMilestones(String? projectId);
}

class MilestoneRemoteDataSourceImpl implements MilestoneRemoteDataSource {
  final Dio _dio;

  MilestoneRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MilestoneEntity>> getMilestones(
      MilestoneFiltersDto filters) async {
    try {
      final response =
          await _dio.get('/milestones', queryParameters: filters.toJson());
      final List<dynamic> data = response.data['data'];
      return data.map((json) => MilestoneEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener milestones: $e');
    }
  }

  @override
  Future<MilestoneEntity> getMilestoneById(String milestoneId) async {
    try {
      final response = await _dio.get('/milestones/$milestoneId');
      return MilestoneEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener milestone: $e');
    }
  }

  @override
  Future<MilestoneEntity> createMilestone(
      CreateMilestoneDto createMilestoneDto) async {
    try {
      final response =
          await _dio.post('/milestones', data: createMilestoneDto.toJson());
      return MilestoneEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear milestone: $e');
    }
  }

  @override
  Future<MilestoneEntity> updateMilestone(
      String milestoneId, UpdateMilestoneDto updateMilestoneDto) async {
    try {
      final response = await _dio.patch('/milestones/$milestoneId',
          data: updateMilestoneDto.toJson());
      return MilestoneEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar milestone: $e');
    }
  }

  @override
  Future<void> deleteMilestone(String milestoneId) async {
    try {
      await _dio.delete('/milestones/$milestoneId');
    } catch (e) {
      throw Exception('Error al eliminar milestone: $e');
    }
  }

  @override
  Future<List<MilestoneEntity>> getMilestonesByProject(String projectId) async {
    try {
      final response = await _dio
          .get('/milestones', queryParameters: {'projectId': projectId});
      final List<dynamic> data = response.data['data'];
      return data.map((json) => MilestoneEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener milestones del proyecto: $e');
    }
  }

  @override
  Future<MilestoneEntity> updateMilestoneStatus(
      String milestoneId, MilestoneStatus status) async {
    try {
      final response = await _dio.patch('/milestones/$milestoneId/status',
          data: {'status': status.name});
      return MilestoneEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar estado de milestone: $e');
    }
  }

  @override
  Future<MilestoneEntity> completeMilestone(String milestoneId) async {
    try {
      final response = await _dio.patch('/milestones/$milestoneId/complete');
      return MilestoneEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al completar milestone: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMilestoneStatistics(String? projectId) async {
    try {
      final response = await _dio.get('/milestones/statistics',
          queryParameters: projectId != null ? {'projectId': projectId} : null);
      return response.data;
    } catch (e) {
      throw Exception('Error al obtener estadísticas de milestones: $e');
    }
  }

  @override
  Future<MilestoneEntity?> getNextPendingMilestone(String projectId) async {
    try {
      final response = await _dio.get('/milestones/next-pending',
          queryParameters: {'projectId': projectId});
      if (response.data == null) return null;
      return MilestoneEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener próximo milestone pendiente: $e');
    }
  }

  @override
  Future<List<MilestoneEntity>> getDelayedMilestones(String? projectId) async {
    try {
      final response = await _dio.get('/milestones/delayed',
          queryParameters: projectId != null ? {'projectId': projectId} : null);
      final List<dynamic> data = response.data['data'];
      return data.map((json) => MilestoneEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener milestones retrasados: $e');
    }
  }
}
