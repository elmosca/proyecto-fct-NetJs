import 'package:dio/dio.dart';
import 'package:fct_frontend/core/interceptors/auth_interceptor.dart';
import 'package:fct_frontend/core/interceptors/error_interceptor.dart';
import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:fct_frontend/core/utils/logger.dart';

class HttpService {
  HttpService({
    required Dio dio,
    required TokenManager tokenManager,
  })  : _dio = dio,
        _tokenManager = tokenManager {
    _setupInterceptors();
  }
  final Dio _dio;
  final TokenManager _tokenManager;

  void _setupInterceptors() {
    // Add auth interceptor (handles JWT tokens automatically)
    _dio.interceptors.add(AuthInterceptor(_tokenManager));
    
    // Add error interceptor
    _dio.interceptors.add(ErrorInterceptor());

    // Add logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.info('🌐 HTTP Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.success(
              '✅ HTTP Response: ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
      ),
    );
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
