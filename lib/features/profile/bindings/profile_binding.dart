import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../order/data_sources/order_remote_data_source.dart';
import '../../order/repositories/order_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
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
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        orderRepository: Get.find<OrderRepository>(),
      ),
    );
  }
}
