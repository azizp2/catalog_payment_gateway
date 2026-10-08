import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_button.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../main/controllers/main_controller.dart';
import '../models/product_model.dart';

void showProductDetailSheet(BuildContext context, ProductModel product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => ProductDetailSheet(product: product),
  );
}

class ProductDetailSheet extends StatefulWidget {
  final ProductModel product;

  const ProductDetailSheet({super.key, required this.product});

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  int quantity = 1;

  IconData _getProductIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('laptop') || lower.contains('macbook') || lower.contains('pc')) {
      return Icons.laptop_mac_rounded;
    }
    if (lower.contains('hp') || lower.contains('phone') || lower.contains('smartphone') || lower.contains('iphone')) {
      return Icons.phone_android_rounded;
    }
    if (lower.contains('headphone') || lower.contains('audio') || lower.contains('tws') || lower.contains('earphone')) {
      return Icons.headphones_rounded;
    }
    if (lower.contains('keyboard') || lower.contains('mouse')) {
      return Icons.keyboard_rounded;
    }
    if (lower.contains('baju') || lower.contains('kaos') || lower.contains('jaket')) {
      return Icons.checkroom_rounded;
    }
    if (lower.contains('kopi') || lower.contains('makan') || lower.contains('snack')) {
      return Icons.restaurant_rounded;
    }
    return Icons.inventory_2_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final product = widget.product;
    final maxAvailable = product.stock;
    final canBuy = product.isInStock;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top drag indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header bar with Close
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rincian Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Product Hero Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(
                        _getProductIcon(product.name),
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product.formattedPrice,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Stock status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: !product.isInStock
                                  ? AppColors.errorLight
                                  : product.isLowStock
                                      ? AppColors.warningLight
                                      : AppColors.successLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  !product.isInStock
                                      ? Icons.cancel_outlined
                                      : product.isLowStock
                                          ? Icons.warning_amber_rounded
                                          : Icons.check_circle_outline,
                                  size: 14,
                                  color: !product.isInStock
                                      ? AppColors.error
                                      : product.isLowStock
                                          ? AppColors.warning
                                          : AppColors.success,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  !product.isInStock
                                      ? 'Stok Habis'
                                      : product.isLowStock
                                          ? 'Sisa ${product.stock} unit (Hampir Habis!)'
                                          : 'Stok Tersedia (${product.stock} unit)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: !product.isInStock
                                        ? AppColors.error
                                        : product.isLowStock
                                            ? AppColors.warning
                                            : AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Trust Badges
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFeatureItem(Icons.verified_outlined, 'Produk Asli', '100% Original'),
                    _buildFeatureItem(Icons.local_shipping_outlined, 'Pengiriman', 'Aman & Cepat'),
                    _buildFeatureItem(Icons.credit_card_outlined, 'Multi-Bayar', 'QRIS & VA Bank'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Quantity Selector (if in stock)
              if (canBuy)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jumlah Pesanan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Pilih jumlah unit yang ingin dibeli',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 36),
                              alignment: Alignment.center,
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: quantity < maxAvailable
                                  ? () => setState(() => quantity++)
                                  : null,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: canBuy
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                cartController.addToCart(product, quantity: quantity);
                                Navigator.of(context).pop();
                                SnackbarHelper.showSuccess(
                                  title: 'Keranjang',
                                  message: '$quantity ${product.name} dimasukkan ke keranjang.',
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart, size: 18),
                              label: const Text('Ke Keranjang'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              text: 'Beli Sekarang',
                              icon: Icons.flash_on_rounded,
                              onPressed: () {
                                cartController.addToCart(product, quantity: quantity);
                                Navigator.of(context).pop();
                                // Switch to Cart tab
                                if (Get.isRegistered<MainController>()) {
                                  Get.find<MainController>().changeTab(1);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Stok Produk Sedang Habis'),
                      ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
