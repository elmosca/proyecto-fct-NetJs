import 'package:dio/dio.dart';
import 'package:fct_frontend/core/services/token_manager.dart';

/// Interceptor HTTP para manejo automático de tokens JWT
class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  AuthInterceptor(this._tokenManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenManager.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expirado o inválido
      final refreshToken = _tokenManager.refreshToken;
      
      if (refreshToken != null) {
        try {
          // TODO: Implementar refresh token
          // final newToken = await _refreshToken(refreshToken);
          // await _tokenManager.saveTokens(newToken);
          // 
          // // Reintentar la petición original
          // final response = await _retryRequest(err.requestOptions);
          // handler.resolve(response);
          // return;
          
          // Por ahora, simplemente limpiamos los tokens
          await _tokenManager.clearTokens();
        } catch (e) {
          // Refresh falló, limpiar tokens
          await _tokenManager.clearTokens();
        }
      } else {
        // No hay refresh token, limpiar todo
        await _tokenManager.clearTokens();
      }
    }
    handler.next(err);
  }

  /// Reintenta una petición con el nuevo token
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor(_tokenManager));
    
    return await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }
} 