import 'package:get/get.dart';
import '../../cart/bindings/cart_binding.dart';
import '../../catalog/bindings/catalog_binding.dart';
import '../../order/bindings/order_list_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());

    // Register tab dependencies
    CatalogBinding().dependencies();
    CartBinding().dependencies();
    OrderListBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
