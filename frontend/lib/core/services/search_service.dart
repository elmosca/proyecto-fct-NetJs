import 'package:dio/dio.dart';
import 'package:fct_frontend/core/exceptions/app_exception.dart';
import 'package:fct_frontend/core/utils/logger.dart';
import 'package:fct_frontend/shared/models/models.dart';

/// Servicio para búsqueda global en el sistema
class SearchService {
  final Dio _dio;

  SearchService(this._dio);

  /// Realiza una búsqueda global en el sistema
  ///
  /// [query] - Término de búsqueda
  /// [filters] - Filtros opcionales para refinar la búsqueda
  /// [limit] - Límite de resultados por categoría
  Future<GlobalSearchResult> searchGlobal({
    required String query,
    Map<String, dynamic>? filters,
    int limit = 10,
  }) async {
    try {
      Logger.info('Realizando búsqueda global: $query');

      final response = await _dio.get(
        '/api/search/global',
        queryParameters: {
          'q': query,
          'limit': limit,
          if (filters != null) ...filters,
        },
      );

      return GlobalSearchResult.fromJson(response.data);
    } on DioException catch (e) {
      Logger.error('Error en búsqueda global: ${e.message}');
      throw NetworkException.fromDioError(e);
    } catch (e) {
      Logger.error('Error inesperado en búsqueda global: $e');
      throw NetworkException(
        message: 'Error inesperado en la búsqueda',
        code: 'SEARCH_ERROR',
      );
    }
  }

  /// Busca proyectos específicamente
  Future<List<Project>> searchProjects({
    required String query,
    Map<String, dynamic>? filters,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/api/search/projects',
        queryParameters: {
          'q': query,
          'limit': limit,
          if (filters != null) ...filters,
        },
      );

      return (response.data['data'] as List)
          .map((json) => Project.fromJson(json))
          .toList();
    } on DioException catch (e) {
      Logger.error('Error en búsqueda de proyectos: ${e.message}');
      throw NetworkException.fromDioError(e);
    }
  }

  /// Busca usuarios específicamente
  Future<List<User>> searchUsers({
    required String query,
    Map<String, dynamic>? filters,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/api/search/users',
        queryParameters: {
          'q': query,
          'limit': limit,
          if (filters != null) ...filters,
        },
      );

      return (response.data['data'] as List)
          .map((json) => User.fromJson(json))
          .toList();
    } on DioException catch (e) {
      Logger.error('Error en búsqueda de usuarios: ${e.message}');
      throw NetworkException.fromDioError(e);
    }
  }

  /// Busca tareas específicamente
  Future<List<Task>> searchTasks({
    required String query,
    Map<String, dynamic>? filters,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/api/search/tasks',
        queryParameters: {
          'q': query,
          'limit': limit,
          if (filters != null) ...filters,
        },
      );

      return (response.data['data'] as List)
          .map((json) => Task.fromJson(json))
          .toList();
    } on DioException catch (e) {
      Logger.error('Error en búsqueda de tareas: ${e.message}');
      throw NetworkException.fromDioError(e);
    }
  }

  /// Obtiene sugerencias de búsqueda basadas en el historial
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response = await _dio.get(
        '/api/search/suggestions',
        queryParameters: {'q': query},
      );

      return (response.data['suggestions'] as List)
          .map((suggestion) => suggestion.toString())
          .toList();
    } on DioException catch (e) {
      Logger.error('Error obteniendo sugerencias: ${e.message}');
      return [];
    }
  }

  /// Guarda una búsqueda en el historial
  Future<void> saveSearchHistory(String query) async {
    try {
      await _dio.post(
        '/api/search/history',
        data: {'query': query},
      );
    } on DioException catch (e) {
      Logger.error('Error guardando historial de búsqueda: ${e.message}');
    }
  }

  /// Obtiene el historial de búsquedas del usuario
  Future<List<String>> getSearchHistory() async {
    try {
      final response = await _dio.get('/api/search/history');

      return (response.data['history'] as List)
          .map((item) => item['query'].toString())
          .toList();
    } on DioException catch (e) {
      Logger.error('Error obteniendo historial de búsqueda: ${e.message}');
      return [];
    }
  }
}
