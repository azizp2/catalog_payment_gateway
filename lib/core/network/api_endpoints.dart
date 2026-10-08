class ApiEndpoints {
  ApiEndpoints._();

  // Products
  static const String products = '/api/products';
  static String productById(String id) => '/api/products/$id';

  // Orders
  static const String orders = '/api/orders';
  static String orderById(String id) => '/api/orders/$id';
  static String cancelOrder(String id) => '/api/orders/$id/cancel';
  static String payOrder(String id) => '/api/orders/$id/pay';

  // Payments
  static String snapToken(String orderId) => '/api/payments/snap-token/$orderId';

  // Logs
  static const String logs = '/api/logs';
  static const String logStats = '/api/logs/stats';
  static const String testLogs = '/api/logs/test';
}
