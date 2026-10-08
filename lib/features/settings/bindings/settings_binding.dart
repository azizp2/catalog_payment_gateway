import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(apiClient: Get.find<ApiClient>()),
    );
  }
}
