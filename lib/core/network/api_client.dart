import 'package:dio/dio.dart';
import '../../app/config/app_config.dart';
import '../exceptions/api_exception.dart';
import '../exceptions/app_exception.dart';
import 'interceptor/logging_interceptor.dart';

class ApiClient {
  late Dio _dio;
  String _baseUrl = AppConfig.defaultAndroidEmulatorUrl;

  String get baseUrl => _baseUrl;

  ApiClient({String? initialBaseUrl}) {
    if (initialBaseUrl != null && initialBaseUrl.isNotEmpty) {
      _baseUrl = initialBaseUrl;
    }
    _initDio();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(LoggingInterceptor());
  }

  void setBaseUrl(String newUrl) {
    var trimmed = newUrl.trim();
    if (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    _baseUrl = trimmed;
    _dio.options.baseUrl = _baseUrl;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  AppException _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException(
        'Gagal terhubung ke server. Pastikan Backend API berjalan.',
        details: e.message,
      );
    }

    final statusCode = e.response?.statusCode;
    final dynamic responseData = e.response?.data;
    String message = 'Terjadi kesalahan pada server';

    if (responseData is Map && responseData.containsKey('message')) {
      message = responseData['message'].toString();
    } else if (responseData is String && responseData.isNotEmpty) {
      message = responseData;
    } else if (e.message != null && e.message!.isNotEmpty) {
      message = e.message!;
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message, details: responseData);
      case 401:
        return UnauthorizedException(message);
      case 404:
        return NotFoundException(message);
      case 500:
        return ServerException(message);
      default:
        return ApiException(message, statusCode: statusCode, details: responseData);
    }
  }
}
