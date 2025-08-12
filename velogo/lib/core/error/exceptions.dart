import 'package:equatable/equatable.dart';

abstract class Exception extends Equatable {
  final String message;

  const Exception(this.message);

  @override
  List<Object> get props => [message];
}

class ServerException extends Exception {
  const ServerException([String message = 'Server error occurred']) : super(message);
}

class CacheException extends Exception {
  const CacheException([String message = 'Cache error occurred']) : super(message);
}

class NetworkException extends Exception {
  const NetworkException([String message = 'Network error occurred']) : super(message);
}

class AuthException extends Exception {
  const AuthException([String message = 'Authentication failed']) : super(message);
}

class ValidationException extends Exception {
  const ValidationException([String message = 'Validation failed']) : super(message);
}

class PermissionException extends Exception {
  const PermissionException([String message = 'Permission denied']) : super(message);
}
