import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../cart/controllers/cart_controller.dart';
import '../models/product_model.dart';
import 'product_detail_sheet.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

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
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => showProductDetailSheet(context, product),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual Header with Category Icon & Stock Badge
            Container(
              height: 96,
              width: double.infinity,
              color: const Color(0xFFF1F5F9), // Slate 100
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getProductIcon(product.name),
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: !product.isInStock
                            ? AppColors.errorLight
                            : product.isLowStock
                                ? AppColors.warningLight
                                : AppColors.successLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: (!product.isInStock
                                  ? AppColors.error
                                  : product.isLowStock
                                      ? AppColors.warning
                                      : AppColors.success)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (product.isLowStock) ...[
                            const Icon(
                              Icons.bolt_rounded,
                              size: 11,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 2),
                          ],
                          Text(
                            !product.isInStock
                                ? 'Habis'
                                : product.isLowStock
                                    ? 'Sisa ${product.stock}!'
                                    : 'Stok: ${product.stock}',
                            style: TextStyle(
                              fontSize: 10,
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
                  ),
                ],
              ),
            ),

            // Product Details & Action Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    GetBuilder<CartController>(
                      builder: (cartController) {
                        final inCart = cartController.isInCart(product.id);
                        final qty = cartController.getQuantity(product.id);

                        if (!product.isInStock) {
                          return SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: OutlinedButton(
                              onPressed: null,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Habis', style: TextStyle(fontSize: 11)),
                            ),
                          );
                        }

                        if (inCart) {
                          return Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 14),
                                  onPressed: () => cartController.updateQuantity(product.id, qty - 1),
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  padding: EdgeInsets.zero,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  '$qty',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 14),
                                  onPressed: qty < product.stock
                                      ? () => cartController.addToCart(product)
                                      : null,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  padding: EdgeInsets.zero,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          );
                        }

                        return SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton.icon(
                            onPressed: () => cartController.addToCart(product),
                            icon: const Icon(Icons.add_shopping_cart, size: 14),
                            label: const Text(
                              'Beli',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
