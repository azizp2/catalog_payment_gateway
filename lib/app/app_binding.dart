import 'package:get/get.dart';
import '../core/network/api_client.dart';
import '../features/cart/controllers/cart_controller.dart';
import '../features/order/data_sources/order_remote_data_source.dart';
import '../features/order/repositories/order_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core Network Client
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Global Cart State
    Get.put<CartController>(CartController(), permanent: true);

    // Global Order Dependencies (needed across tabs and cart checkout)
    Get.lazyPut<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<OrderRepository>(
      () => OrderRepositoryImpl(remoteDataSource: Get.find<OrderRemoteDataSource>()),
      fenix: true,
    );
  }
}
