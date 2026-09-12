class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'Network connection failed'])
    : super(message: message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Unauthorized request'])
    : super(message: message, statusCode: 401);
}

class ServerException extends ApiException {
  const ServerException([String message = 'Internal server error', int? code])
    : super(message: message, statusCode: code ?? 500);
}
