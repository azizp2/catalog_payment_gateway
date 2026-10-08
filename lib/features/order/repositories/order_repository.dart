import '../data_sources/order_remote_data_source.dart';
import '../models/create_order_request.dart';
import '../models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> createOrder(CreateOrderRequest request);
  Future<bool> cancelOrder(String id);
  Future<bool> payOrder(String id);
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderModel>> getOrders() => remoteDataSource.getOrders();

  @override
  Future<OrderModel> getOrderById(String id) => remoteDataSource.getOrderById(id);

  @override
  Future<OrderModel> createOrder(CreateOrderRequest request) =>
      remoteDataSource.createOrder(request);

  @override
  Future<bool> cancelOrder(String id) => remoteDataSource.cancelOrder(id);

  @override
  Future<bool> payOrder(String id) => remoteDataSource.payOrder(id);
}
