import 'package:dio/dio.dart';
import 'package:fct_frontend/core/interceptors/error_interceptor.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/core/utils/logger.dart';

class HttpService {
  HttpService({
    required Dio dio,
    required StorageService storageService,
  })  : _dio = dio,
        _storageService = storageService {
    _setupInterceptors();
  }
  final Dio _dio;
  final StorageService _storageService;

  void _setupInterceptors() {
    // Add error interceptor first
    _dio.interceptors.add(ErrorInterceptor());

    // Add auth and logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          Logger.info('🌐 HTTP Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.success(
              '✅ HTTP Response: ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401) {
            _handleUnauthorized();
          }

          handler.next(error);
        },
      ),
    );
  }

  void _handleUnauthorized() {
    // Clear token and redirect to login
    _storageService.clearToken();
    // TODO: Navigate to login page
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async =>
      await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
}
