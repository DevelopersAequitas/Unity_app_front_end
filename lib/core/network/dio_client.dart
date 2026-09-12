import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../cache/app_cache_keys.dart';
import '../cache/cache_store.dart';
import '../constants/app_environment.dart';
import 'api_exception.dart';

class DioClient {
  late final Dio dio;
  final CacheStore? cacheStore;

  DioClient({this.cacheStore, Dio? customDio}) {
    dio =
        customDio ??
        Dio(
          BaseOptions(
            baseUrl: AppEnvironment.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    dio.interceptors.addAll([
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (cacheStore != null) {
            final token = await cacheStore!.get<String>(
              AppCacheBoxes.authBox,
              AppCacheKeys.authToken,
            );
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          final message = _extractErrorMessage(error);
          final customError = _mapDioException(error, message);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: customError,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
      if (kDebugMode)
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
        ),
    ]);
  }

  static String _extractErrorMessage(DioException error) {
    if (error.response?.data is Map<String, dynamic>) {
      final map = error.response!.data as Map<String, dynamic>;
      return (map['message'] ?? map['error'] ?? 'An error occurred').toString();
    }
    return error.message ?? 'Network connection error';
  }

  static ApiException _mapDioException(DioException error, String message) {
    final status = error.response?.statusCode;
    if (status == 401 || status == 403) {
      return UnauthorizedException(message);
    }
    if (status != null && status >= 500) {
      return ServerException(message, status);
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkException(message);
    }
    return ApiException(message: message, statusCode: status);
  }
}
