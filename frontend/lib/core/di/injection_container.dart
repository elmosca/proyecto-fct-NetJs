import 'package:dio/dio.dart';
import 'package:fct_frontend/core/constants/app_constants.dart';
import 'package:fct_frontend/core/services/auth_service.dart';
import 'package:fct_frontend/core/services/http_service.dart';
import 'package:fct_frontend/core/services/storage_service.dart';
import 'package:fct_frontend/core/services/token_manager.dart';
import 'package:fct_frontend/core/services/websocket_service.dart';
import 'package:fct_frontend/core/utils/logger.dart';
import 'package:fct_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fct_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:fct_frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:fct_frontend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fct_frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:fct_frontend/features/users/data/repositories/user_repository_impl.dart';
import 'package:fct_frontend/features/users/domain/repositories/user_repository.dart';
import 'package:fct_frontend/features/users/domain/services/authorization_service.dart';
import 'package:fct_frontend/features/users/domain/usecases/usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // SharedPreferences - Inicializar primero
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  // Core Services - Después de SharedPreferences
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<TokenManager>(
    () => TokenManager(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<HttpService>(
    () => HttpService(
      dio: getIt<Dio>(),
      tokenManager: getIt<TokenManager>(),
    ),
  );

  getIt.registerLazySingleton<WebSocketService>(
    () => WebSocketService(
      channel: getIt<WebSocketChannel>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      httpService: getIt<HttpService>(),
      storageService: getIt<StorageService>(),
      tokenManager: getIt<TokenManager>(),
    ),
  );

  // Authorization Service
  getIt.registerLazySingleton<AuthorizationService>(
    () => AuthorizationServiceImpl(),
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

  // Auth Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthService>(), getIt<TokenManager>()),
  );

  // Users Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<HttpService>()),
  );

  // Auth Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );

  // Users Use Cases
  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<DeleteUserUseCase>(
    () => DeleteUserUseCase(getIt<UserRepository>()),
  );
}
