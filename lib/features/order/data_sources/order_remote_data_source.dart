import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/create_order_request.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> createOrder(CreateOrderRequest request);
  Future<bool> cancelOrder(String id);
  Future<bool> payOrder(String id);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await apiClient.get<List<dynamic>>(ApiEndpoints.orders);
    final data = response.data ?? [];
    return data.map((json) => OrderModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final response = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.orderById(id));
    return OrderModel.fromJson(response.data!);
  }

  @override
  Future<OrderModel> createOrder(CreateOrderRequest request) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.orders,
      data: request.toJson(),
    );
    return OrderModel.fromJson(response.data!);
  }

  @override
  Future<bool> cancelOrder(String id) async {
    final response = await apiClient.post(ApiEndpoints.cancelOrder(id));
    final status = response.statusCode ?? 0;
    return status >= 200 && status < 300;
  }

  @override
  Future<bool> payOrder(String id) async {
    final response = await apiClient.post(ApiEndpoints.payOrder(id));
    final status = response.statusCode ?? 0;
    return status >= 200 && status < 300;
  }
}
