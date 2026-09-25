import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../cache/app_cache_keys.dart';
import '../cache/cache_store.dart';
import '../cache/hive_cache_store.dart';
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
      if (kDebugMode)
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final p = options.path;
            final isMuted = p.contains('/chats') ||
                p.contains('/members/online-heartbeat') ||
                p.contains('/me/connection-requests');
            if (!isMuted) {
              debugPrint('[HTTP] -> ${options.method} ${options.uri}');
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
            final p = response.requestOptions.path;
            final isMuted = p.contains('/chats') ||
                p.contains('/members/online-heartbeat') ||
                p.contains('/me/connection-requests');
            if (!isMuted) {
              debugPrint('[HTTP] <- ${response.statusCode} ${response.requestOptions.uri}');
            }
            return handler.next(response);
          },
          onError: (DioException error, handler) {
            final p = error.requestOptions.path;
            final isMuted = p.contains('/chats') ||
                p.contains('/members/online-heartbeat') ||
                p.contains('/me/connection-requests');
            if (!isMuted) {
              debugPrint('[HTTP] ERR ${error.response?.statusCode ?? '---'} ${error.requestOptions.uri} (${error.message})');
            }
            return handler.next(error);
          },
        ),
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final store = cacheStore ?? HiveCacheStore();
            final token = await store.get<String>(
              AppCacheBoxes.authBox,
              AppCacheKeys.authToken,
            );
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (_) {}
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
    ]);
  }

  static String _extractErrorMessage(DioException error) {
    if (error.type == DioExceptionType.sendTimeout) {
      return 'Upload timed out. Please check your connection and try again.';
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please try again.';
    }
    if (error.response?.data is Map<String, dynamic>) {
      final map = error.response!.data as Map<String, dynamic>;
      if (map['errors'] is Map && (map['errors'] as Map).isNotEmpty) {
        final errMap = map['errors'] as Map;
        final firstVal = errMap.values.first;
        if (firstVal is List && firstVal.isNotEmpty) {
          return firstVal.first.toString();
        } else if (firstVal is String) {
          return firstVal;
        }
      }
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
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkException(message);
    }
    return ApiException(message: message, statusCode: status);
  }
}
