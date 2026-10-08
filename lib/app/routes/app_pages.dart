import 'package:get/get.dart';
import '../../features/catalog/bindings/add_product_binding.dart';
import '../../features/catalog/pages/add_product_page.dart';
import '../../features/main/bindings/main_binding.dart';
import '../../features/main/pages/main_page.dart';
import '../../features/order/bindings/order_detail_binding.dart';
import '../../features/order/pages/order_detail_page.dart';
import '../../features/payment/bindings/snap_payment_binding.dart';
import '../../features/payment/pages/snap_payment_page.dart';
import '../../features/settings/bindings/settings_binding.dart';
import '../../features/settings/pages/settings_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.main;

  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductPage(),
      binding: AddProductBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailPage(),
      binding: OrderDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.snapPayment,
      page: () => const SnapPaymentPage(),
      binding: SnapPaymentBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
