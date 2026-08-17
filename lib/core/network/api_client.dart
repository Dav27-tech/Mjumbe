import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mjumbe/core/network/auth_interceptor.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    required FirebaseAuth firebaseAuth,
  }) : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  ) {
    _dio.interceptors.addAll([
      AuthInterceptor(firebaseAuth),
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