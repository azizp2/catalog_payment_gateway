import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/add_product_controller.dart';
import '../data_sources/catalog_remote_data_source.dart';
import '../repositories/catalog_repository.dart';

class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CatalogRemoteDataSource>()) {
      Get.lazyPut<CatalogRemoteDataSource>(
        () => CatalogRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      );
    }
    if (!Get.isRegistered<CatalogRepository>()) {
      Get.lazyPut<CatalogRepository>(
        () => CatalogRepositoryImpl(remoteDataSource: Get.find<CatalogRemoteDataSource>()),
      );
    }
    Get.lazyPut<AddProductController>(
      () => AddProductController(repository: Get.find<CatalogRepository>()),
    );
  }
}
