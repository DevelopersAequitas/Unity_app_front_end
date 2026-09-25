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
    var text = raw.trim();
    if (text.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    // Try extracting JSON message if whole string or part is JSON-like
    if (text.contains('{"') || text.contains("{'")) {
      final jsonMsgMatch = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(text);
      if (jsonMsgMatch != null && jsonMsgMatch.group(1) != null) {
        return _sanitizeMessage(jsonMsgMatch.group(1)!);
      }
      final jsonErrorMatch = RegExp(r'"error"\s*:\s*"([^"]+)"').firstMatch(text);
      if (jsonErrorMatch != null && jsonErrorMatch.group(1) != null) {
        return _sanitizeMessage(jsonErrorMatch.group(1)!);
      }
    }

    // Strip common Exception prefixes
    text = text.replaceFirst(RegExp(r'^Exception:\s*', caseSensitive: false), '');
    text = text.replaceFirst(RegExp(r'^FormatException:\s*', caseSensitive: false), '');
    text = text.replaceFirst(RegExp(r'^ClientException:\s*', caseSensitive: false), '');

    // Handle DioException text representations
    if (text.toLowerCase().contains('dioexception')) {
      final lower = text.toLowerCase();
      if (lower.contains('connection timeout') ||
          lower.contains('receive timeout') ||
          lower.contains('send timeout') ||
          lower.contains('connection error') ||
          lower.contains('socketexception') ||
          lower.contains('failed host lookup') ||
          lower.contains('network is unreachable')) {
        return 'Network connection error. Please check your internet and try again.';
      }
      if (lower.contains('401') || lower.contains('unauthorized')) {
        return 'Session expired. Please log in again.';
      }
      if (lower.contains('403') || lower.contains('forbidden')) {
        return 'Access denied. You do not have permission.';
      }
      if (lower.contains('404') || lower.contains('not found')) {
        return 'Requested information could not be found.';
      }
      if (lower.contains('500') ||
          lower.contains('502') ||
          lower.contains('503') ||
          lower.contains('internal server error')) {
        return 'Server is temporarily unavailable. Please try again later.';
      }
      if (lower.contains('method is not supported') || lower.contains('method not allowed')) {
        return 'Action cannot be completed at this time.';
      }

      // Try extracting human message after colon if present
      final colonIndex = text.lastIndexOf(':');
      if (colonIndex != -1 && colonIndex < text.length - 1) {
        final candidate = text.substring(colonIndex + 1).trim();
        if (candidate.isNotEmpty &&
            !candidate.toLowerCase().startsWith('null') &&
            candidate.length > 3 &&
            !candidate.toLowerCase().contains('dioexception')) {
          text = candidate;
        } else {
          return 'Something went wrong. Please try again.';
        }
      } else {
        return 'Something went wrong. Please try again.';
      }
    }

    final lower = text.toLowerCase();
    if (lower.contains('socketexception') ||
        lower.contains('handshakeexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (lower.contains('formatexception') || lower.contains('unexpected character')) {
      return 'Something went wrong while processing data. Please try again.';
    }

    if (lower.contains('null check operator') ||
        lower.contains('nosuchmethoderror') ||
        lower.contains('typeerror') ||
        lower.contains('rangeerror')) {
      return 'An unexpected error occurred. Please try again.';
    }

    for (final jargon in _developerJargon) {
      if (lower.contains(jargon)) {
        return 'Something went wrong. Please try again in a moment.';
      }
    }

    // If message is too long (like an HTML dump), return fallback
    if (text.length > 150) {
      if (text.contains('<html') || text.contains('<!doctype') || text.contains('stack trace:')) {
        return 'Server error occurred. Please try again.';
      }
      return '${text.substring(0, 147)}...';
    }

    return text;
  }
}
