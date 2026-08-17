import 'package:dio/dio.dart';
import 'package:mjumbe/core/network/auth_interceptor.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    required AuthRepository authRepository,
  }) : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  ) {
    _dio.interceptors.addAll([
      AuthInterceptor(authRepository),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  Dio get client => _dio;
}
