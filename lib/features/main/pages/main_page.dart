import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/pages/cart_page.dart';
import '../../catalog/pages/catalog_page.dart';
import '../../order/pages/order_list_page.dart';
import '../../profile/pages/profile_page.dart';
import '../controllers/main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  final List<Widget> _pages = const [
    CatalogPage(),
    CartPage(),
    OrderListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: _pages,
          ),
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            cartItemCount: cartController.itemCount,
          ),
        ));
  }
}
