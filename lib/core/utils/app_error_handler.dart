import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/api_exception.dart';

class AppErrorHandler {
  AppErrorHandler._();

  static const List<String> _developerJargon = [
    'sqlstate',
    'pdoexception',
    'syntaxerror',
    'dioexception',
    'socketexception',
    'formatexception',
    'typeerror',
    'nullcheck',
    'nosuchmethoderror',
    'httpexception',
    'stack trace',
    'unhandled exception',
    'instance of',
    'connection refused',
    'bad response',
    'bad certificate',
  ];

  static String getDisplayMessage(dynamic error, [StackTrace? stackTrace]) =>
      toUserFriendlyMessage(error, stackTrace);

  static String toUserFriendlyMessage(dynamic error, [StackTrace? stackTrace]) {
    // 1. Log real error & stacktrace for developers
    _logRealError(error, stackTrace);

    // 2. Extract and sanitize message for UI
    if (error is DioException) {
      return _extractFromDioException(error);
    }
    if (error is ApiException) {
      return _sanitizeMessage(error.message);
    }
    if (error is Exception) {
      final raw = error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return _sanitizeMessage(raw);
    }
    if (error is String) {
      return _sanitizeMessage(error);
    }

    return 'Something went wrong. Please try again.';
  }

  static void _logRealError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      final logBuffer = StringBuffer();
      logBuffer.writeln('[DEV_ERROR_LOG] ================================');
      logBuffer.writeln('Type: ${error.runtimeType}');
      logBuffer.writeln('Details: $error');
      if (error is DioException) {
        logBuffer.writeln('URL: ${error.requestOptions.uri}');
        logBuffer.writeln('Method: ${error.requestOptions.method}');
        logBuffer.writeln('Status Code: ${error.response?.statusCode}');
        logBuffer.writeln('Response Data: ${error.response?.data}');
      }
      if (stackTrace != null) {
        logBuffer.writeln('StackTrace:\n$stackTrace');
      }
      logBuffer.writeln('================================================');
      dev.log(logBuffer.toString(), name: 'AppErrorHandler');
      debugPrint(logBuffer.toString());
    }
  }

  static String _extractFromDioException(DioException error) {
    if (error.error is ApiException) {
      return _sanitizeMessage((error.error as ApiException).message);
    }

    final response = error.response;
    if (response != null && response.data != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['errors'] is Map<String, dynamic>) {
          final errorsMap = data['errors'] as Map<String, dynamic>;
          for (final key in errorsMap.keys) {
            final val = errorsMap[key];
            if (val is List && val.isNotEmpty) {
              return _sanitizeMessage(val.first.toString());
            }
            if (val is String && val.isNotEmpty) {
              return _sanitizeMessage(val);
            }
          }
        }
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          return _sanitizeMessage(data['message'].toString());
        }
        if (data['error'] != null && data['error'].toString().isNotEmpty) {
          return _sanitizeMessage(data['error'].toString());
        }
      }
    }

    final status = response?.statusCode;
    if (status == 401) {
      return 'Session expired. Please log in again.';
    }
    if (status == 403) {
      return 'Access denied. You do not have permission.';
    }
    if (status == 404) {
      return 'Requested resource could not be found.';
    }
    if (status != null && status >= 500) {
      return 'Our servers are experiencing issues. Please try again later.';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Unable to reach the server. Please check your internet connection.';
    }

    return 'Network connection error. Please try again.';
  }

  static String _sanitizeMessage(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    final lower = trimmed.toLowerCase();
    for (final jargon in _developerJargon) {
      if (lower.contains(jargon)) {
        return 'Something went wrong. Please try again in a moment.';
      }
    }

    return trimmed;
  }
}
