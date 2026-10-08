import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/order_list_controller.dart';
import '../data_sources/order_remote_data_source.dart';
import '../repositories/order_repository.dart';

class OrderListBinding extends Bindings {
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
    Get.lazyPut<OrderListController>(
      () => OrderListController(repository: Get.find<OrderRepository>()),
    );
  }
}
