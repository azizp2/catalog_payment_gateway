import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/catalog_controller.dart';
import '../data_sources/catalog_remote_data_source.dart';
import '../repositories/catalog_repository.dart';

class CatalogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CatalogRemoteDataSource>(
      () => CatalogRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<CatalogRepository>(
      () => CatalogRepositoryImpl(remoteDataSource: Get.find<CatalogRemoteDataSource>()),
    );
    Get.lazyPut<CatalogController>(
      () => CatalogController(repository: Get.find<CatalogRepository>()),
    );
  }
}
