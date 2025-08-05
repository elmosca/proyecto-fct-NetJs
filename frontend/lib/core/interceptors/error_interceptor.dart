import 'package:dio/dio.dart';
import 'package:fct_frontend/core/utils/logger.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.error('🚨 Error Interceptor: ${err.type} - ${err.message}');

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        Logger.error('⏰ Timeout Error: ${err.message}');
        break;
      
      case DioExceptionType.badResponse:
        _handleBadResponse(err);
        break;
      
      case DioExceptionType.cancel:
        Logger.warning('❌ Request Cancelled');
        break;
      
      case DioExceptionType.connectionError:
        Logger.error('🌐 Connection Error: No internet connection');
        break;
      
      case DioExceptionType.badCertificate:
        Logger.error('🔒 Certificate Error: Invalid SSL certificate');
        break;
      
      case DioExceptionType.unknown:
        Logger.error('❓ Unknown Error: ${err.message}');
        break;
    }

    handler.next(err);
  }

  void _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    Logger.error('📡 Bad Response: $statusCode - ${data ?? 'No data'}');

    switch (statusCode) {
      case 400:
        Logger.error('🚫 Bad Request: Invalid request data');
        break;
      case 401:
        Logger.error('🔐 Unauthorized: Authentication required');
        break;
      case 403:
        Logger.error('🚫 Forbidden: Access denied');
        break;
      case 404:
        Logger.error('🔍 Not Found: Resource not found');
        break;
      case 422:
        Logger.error('📝 Validation Error: Invalid data format');
        break;
      case 429:
        Logger.error('⏳ Rate Limited: Too many requests');
        break;
      case 500:
        Logger.error('💥 Server Error: Internal server error');
        break;
      case 502:
        Logger.error('🌐 Bad Gateway: Server communication error');
        break;
      case 503:
        Logger.error('🔧 Service Unavailable: Server maintenance');
        break;
      default:
        Logger.error('❓ Unknown Status Code: $statusCode');
    }
  }
} 