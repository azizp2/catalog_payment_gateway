import 'package:get/get.dart';
import '../controllers/snap_payment_controller.dart';

class SnapPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnapPaymentController>(() => SnapPaymentController());
  }
}
