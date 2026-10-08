import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../order/repositories/order_repository.dart';
import '../models/user_profile_model.dart';

class ProfileController extends GetxController {
  final OrderRepository orderRepository;

  ProfileController({
    required this.orderRepository,
  });

  final Rx<UserProfileModel> profile = const UserProfileModel().obs;

  final RxInt totalOrders = 0.obs;
  final RxInt pendingOrders = 0.obs;
  final RxInt paidOrders = 0.obs;
  final RxDouble totalSpent = 0.0.obs;
  final RxBool isLoadingStats = false.obs;

  String get formattedTotalSpent => CurrencyFormatter.format(totalSpent.value);

  @override
  void onInit() {
    super.onInit();
    _syncWithCart();
    loadOrderStats();
  }

  void _syncWithCart() {
    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();
      profile.value = profile.value.copyWith(
        email: cart.customerEmail.value,
        customerId: cart.customerId.value,
      );
    }
  }

  Future<void> loadOrderStats() async {
    isLoadingStats.value = true;
    try {
      final orders = await orderRepository.getOrders();
      totalOrders.value = orders.length;
      pendingOrders.value = orders.where((o) => o.isPending).length;
      paidOrders.value = orders.where((o) => o.isPaid).length;

      var spent = 0.0;
      for (final order in orders) {
        if (order.isPaid) {
          spent += order.totalAmount;
        }
      }
      totalSpent.value = spent;
    } catch (_) {
      // Keep default values if network fails
    } finally {
      isLoadingStats.value = false;
    }
  }

  void updateProfile({
    required String name,
    required String email,
    required String address,
    required String phone,
  }) {
    profile.value = profile.value.copyWith(
      name: name,
      email: email,
      address: address,
      phone: phone,
    );

    // Sync email back to cart
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().setCustomerInfo(
        email: email,
        id: profile.value.customerId,
      );
    }

    SnackbarHelper.showSuccess(
      title: 'Profil Diperbarui',
      message: 'Informasi akun pelanggan berhasil disimpan.',
    );
  }

  void showEditDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: profile.value.name);
    final emailCtrl = TextEditingController(text: profile.value.email);
    final phoneCtrl = TextEditingController(text: profile.value.phone);
    final addressCtrl = TextEditingController(text: profile.value.address);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profil Pelanggan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Alamat Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Alamat Pengiriman',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              updateProfile(
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
