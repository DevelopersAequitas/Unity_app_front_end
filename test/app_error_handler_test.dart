import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unity_app/core/network/api_exception.dart';
import 'package:unity_app/core/utils/app_error_handler.dart';

void main() {
  group('AppErrorHandler', () {
    test('extracts clean backend message from DioException response', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/auth/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/auth/register'),
          statusCode: 422,
          data: {
            'success': false,
            'message': 'The email has already been taken.',
          },
        ),
      );

      final msg = AppErrorHandler.toUserFriendlyMessage(dioException);
      expect(msg, 'The email has already been taken.');
    });

    test('extracts nested errors field from validation responses', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/auth/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/auth/register'),
          statusCode: 422,
          data: {
            'success': false,
            'errors': {
              'phone': ['The phone number is invalid.'],
            },
          },
        ),
      );

      final msg = AppErrorHandler.toUserFriendlyMessage(dioException);
      expect(msg, 'The phone number is invalid.');
    });

    test('filters technical developer jargon to friendly message', () {
      const technicalError = 'SQLSTATE[23000]: Integrity constraint violation';
      final msg = AppErrorHandler.toUserFriendlyMessage(
        Exception(technicalError),
      );
      expect(msg, 'Something went wrong. Please try again in a moment.');
    });

    test('maps network connection errors cleanly', () {
      final networkDioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/countries'),
        type: DioExceptionType.connectionTimeout,
      );

      final msg = AppErrorHandler.toUserFriendlyMessage(networkDioException);
      expect(
        msg,
        'Unable to reach the server. Please check your internet connection.',
      );
    });

    test('handles ApiException message correctly', () {
      const apiEx = ApiException(message: 'Invalid verification OTP');
      final msg = AppErrorHandler.toUserFriendlyMessage(apiEx);
      expect(msg, 'Invalid verification OTP');
    });
  });
}
