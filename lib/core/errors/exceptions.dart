class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class AuthExceptionWrapper extends AppException {
  const AuthExceptionWrapper(super.message, {super.code, super.details});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.details});
}

class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.details});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.details});
}
