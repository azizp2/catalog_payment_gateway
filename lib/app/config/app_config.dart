class AppConfig {
  AppConfig._();

  static const String appName = 'Mini E-Commerce';
  static const String defaultAndroidEmulatorUrl = 'http://10.0.2.2:5164';
  static const String defaultLocalhostUrl = 'http://localhost:5164';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static const String defaultCustomerId = '3fa85f64-5717-4562-b3fc-2c963f66afa6';
  static const String defaultCustomerEmail = 'pelanggan@tokomini.com';
}
