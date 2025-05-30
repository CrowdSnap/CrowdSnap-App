// lib/core/errors/exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException(this.message, [this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  NetworkException([String message = 'A network error occurred. Please check your connection.']) : super(message);
}

class ServerException extends AppException {
  final int? statusCode;
  ServerException({String message = 'A server error occurred.', this.statusCode}) : super(message);
}

class AuthenticationException extends AppException {
  AuthenticationException([String message = 'Authentication failed.']) : super(message);
}

class CacheException extends AppException {
  CacheException([String message = 'A cache error occurred.']) : super(message);
}

class UnexpectedException extends AppException {
  UnexpectedException([String message = 'An unexpected error occurred.']) : super(message);
}

class PermissionException extends AppException {
  PermissionException([String message = 'Permission denied.']) : super(message);
}
