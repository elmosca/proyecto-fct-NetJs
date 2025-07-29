import 'package:dio/dio.dart';
import 'package:fct_frontend/core/constants/app_constants.dart';
import 'package:fct_frontend/core/services/auth_service.dart';
import 'package:fct_frontend/core/services/http_service.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/core/services/websocket_service.dart';
import 'package:fct_frontend/core/utils/logger.dart';
import 'package:fct_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:fct_frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:fct_frontend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fct_frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core Services
  getIt.registerLazySingleton<HttpService>(
    () => HttpService(
      dio: getIt<Dio>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerLazySingleton<WebSocketService>(
    () => WebSocketService(
      channel: getIt<WebSocketChannel>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerLazySingleton<StorageService>(
    () => StorageService(),
  );

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      httpService: getIt<HttpService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  // HTTP Client
  getIt.registerLazySingleton<Dio>(
    () {
      final dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
          connectTimeout: AppConstants.connectionTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Add interceptors
      dio.interceptors.addAll([
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => Logger.debug(obj.toString()),
        ),
      ]);

      return dio;
    },
  );

  // WebSocket Channel
  getIt.registerLazySingleton<WebSocketChannel>(
    () => WebSocketChannel.connect(
      Uri.parse(AppConstants.wsUrl),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      httpService: getIt<HttpService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );
}
