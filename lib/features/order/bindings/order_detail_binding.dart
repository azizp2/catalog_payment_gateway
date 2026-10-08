import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../payment/data_sources/payment_remote_data_source.dart';
import '../../payment/repositories/payment_repository.dart';
import '../controllers/order_detail_controller.dart';
import '../data_sources/order_remote_data_source.dart';
import '../repositories/order_repository.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OrderRemoteDataSource>()) {
      Get.lazyPut<OrderRemoteDataSource>(
        () => OrderRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      );
    }
    if (!Get.isRegistered<OrderRepository>()) {
      Get.lazyPut<OrderRepository>(
        () => OrderRepositoryImpl(remoteDataSource: Get.find<OrderRemoteDataSource>()),
      );
    }
    if (!Get.isRegistered<PaymentRemoteDataSource>()) {
      Get.lazyPut<PaymentRemoteDataSource>(
        () => PaymentRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      );
    }
    if (!Get.isRegistered<PaymentRepository>()) {
      Get.lazyPut<PaymentRepository>(
        () => PaymentRepositoryImpl(remoteDataSource: Get.find<PaymentRemoteDataSource>()),
      );
    }
    Get.lazyPut<OrderDetailController>(
      () => OrderDetailController(
        orderRepository: Get.find<OrderRepository>(),
        paymentRepository: Get.find<PaymentRepository>(),
      ),
    );
  }
}
