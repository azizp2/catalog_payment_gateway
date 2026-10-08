import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/widgets/empty_state.dart';
import '../../main/controllers/main_controller.dart';
import '../../order/models/create_order_request.dart';
import '../../order/repositories/order_repository.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartController = Get.find<CartController>();
  late final TextEditingController emailController;
  late final TextEditingController customerIdController;
  final isCheckingOut = false.obs;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: cartController.customerEmail.value,
    );
    customerIdController = TextEditingController(
      text: cartController.customerId.value,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    customerIdController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckout() async {
    if (cartController.items.isEmpty) {
      SnackbarHelper.showError(
        title: 'Keranjang Kosong',
        message: 'Keranjang belanja masih kosong!',
      );
      return;
    }

    final email = emailController.text.trim();
    final customerId = customerIdController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      SnackbarHelper.showError(
        title: 'Validasi Gagal',
        message: 'Masukkan alamat email yang valid!',
      );
      return;
    }

    if (customerId.isEmpty) {
      SnackbarHelper.showError(
        title: 'Validasi Gagal',
        message: 'Customer ID tidak boleh kosong!',
      );
      return;
    }

    isCheckingOut.value = true;

    try {
      final orderRepository = Get.find<OrderRepository>();
      final req = CreateOrderRequest(
        customerId: customerId,
        customerEmail: email,
        items: cartController.itemsList
            .map(
              (item) => CreateOrderItemRequest(
                productId: item.productId,
                quantity: item.quantity,
              ),
            )
            .toList(),
      );

      final order = await orderRepository.createOrder(req);
      isCheckingOut.value = false;

      // Update stored customer info
      cartController.setCustomerInfo(email: email, id: customerId);
      cartController.clearCart();

      SnackbarHelper.showSuccess(
        title: 'Pesanan Dibuat',
        message: 'Pesanan #${order.id.substring(0, 8)} berhasil dibuat!',
      );

      // Navigate to order detail
      Get.toNamed(
        AppRoutes.orderDetail,
        arguments: order.id,
        parameters: {'id': order.id},
      );
    } catch (e) {
      isCheckingOut.value = false;
      SnackbarHelper.showError(title: 'Gagal Checkout', message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          Obx(() {
            if (cartController.items.isEmpty) return const SizedBox.shrink();
            return TextButton(
              onPressed: cartController.clearCart,
              child: const Text(
                'Kosongkan',
                style: TextStyle(color: AppColors.error),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return EmptyState(
            icon: Icons.remove_shopping_cart_outlined,
            title: 'Keranjang Masih Kosong',
            description: 'Pilih produk dari katalog untuk mulai belanja.',
            buttonText: 'Lihat Katalog',
            onButtonPressed: () {
              if (Get.isRegistered<MainController>()) {
                Get.find<MainController>().changeTab(0);
              }
            },
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Customer Info Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pembeli',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppInput(
                      controller: emailController,
                      label: 'Email Pembeli',
                      hint: 'pembeli@example.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    AppInput(
                      controller: customerIdController,
                      label: 'ID Pelanggan',
                      hint: 'Biarkan default / ID unik akun',
                      prefixIcon: Icons.person_outline,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cart Items List
            const Text(
              'Daftar Belanja',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            ...cartController.itemsList.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.formattedPrice,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 14),
                              onPressed: () => cartController.updateQuantity(
                                item.productId,
                                item.quantity - 1,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 14),
                              onPressed: item.quantity < item.availableStock
                                  ? () => cartController.updateQuantity(
                                      item.productId,
                                      item.quantity + 1,
                                    )
                                  : null,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.error,
                        ),
                        onPressed: () =>
                            cartController.removeFromCart(item.productId),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.items.isEmpty) return const SizedBox.shrink();

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total (${cartController.itemCount} barang):',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        cartController.formattedTotal,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AppButton(
                    text: 'Checkout',
                    icon: Icons.shopping_bag_outlined,
                    isLoading: isCheckingOut.value,
                    onPressed: _handleCheckout,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
