import 'app_exception.dart';

class ApiException extends AppException {
  final int? statusCode;

  ApiException(
    super.message, {
    this.statusCode,
    super.details,
  }) : super(prefix: 'API Error [${statusCode ?? 'Unknown'}]');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'Unauthorized access'])
      : super(statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = 'Resource not found'])
      : super(statusCode: 404);
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.details})
      : super(statusCode: 400);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Internal server error occurred'])
      : super(statusCode: 500);
}
