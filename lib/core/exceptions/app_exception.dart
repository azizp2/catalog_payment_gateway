class AppException implements Exception {
  final String message;
  final String? prefix;
  final dynamic details;

  AppException(this.message, {this.prefix, this.details});

  @override
  String toString() {
    return prefix != null ? '$prefix: $message' : message;
  }
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.details})
      : super(prefix: 'Network Error');
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.details})
      : super(prefix: 'Validation Error');
}
