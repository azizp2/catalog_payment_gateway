import 'package:get/get.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderListController extends GetxController {
  final OrderRepository repository;

  OrderListController({required this.repository});

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await repository.getOrders();
      orders.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Gagal memuat daftar pesanan: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
