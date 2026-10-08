import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/catalog_controller.dart';
import '../widgets/product_card.dart';

class CatalogPage extends GetView<CatalogController> {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Katalog Produk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Temukan produk belanja terbaik',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          // Quick Cart Badge Shortcut
          if (Get.isRegistered<CartController>())
            GetBuilder<CartController>(
              builder: (cartCtrl) {
                final count = cartCtrl.itemCount;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      tooltip: 'Lihat Keranjang',
                      onPressed: () {
                        if (Get.isRegistered<MainController>()) {
                          Get.find<MainController>().changeTab(1);
                        }
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Katalog',
            onPressed: controller.fetchProducts,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Terjadi Kesalahan',
            description: controller.errorMessage.value!,
            buttonText: 'Coba Lagi',
            onButtonPressed: controller.fetchProducts,
          );
        }

        if (controller.products.isEmpty) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'Belum Ada Produk',
            description: 'Katalog saat ini masih kosong. Silakan tambahkan produk baru.',
            buttonText: 'Tambah Produk',
            onButtonPressed: () => Get.toNamed(AppRoutes.addProduct),
          );
        }

        final filteredList = controller.filteredProducts;

        return RefreshIndicator(
          onRefresh: controller.fetchProducts,
          child: Column(
            children: [
              // Search & Filter Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Cari nama produk...',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: controller.clearSearch,
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Filter & Sort Horizontal Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'Semua (${controller.products.length})',
                            isSelected: controller.selectedFilter.value == 'all' &&
                                controller.selectedSort.value == 'default',
                            onTap: () {
                              controller.setFilter('all');
                              controller.setSort('default');
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Tersedia',
                            icon: Icons.check_circle_outline,
                            isSelected: controller.selectedFilter.value == 'in_stock',
                            onTap: () {
                              controller.setFilter(
                                controller.selectedFilter.value == 'in_stock'
                                    ? 'all'
                                    : 'in_stock',
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Hampir Habis',
                            icon: Icons.bolt_rounded,
                            isSelected: controller.selectedFilter.value == 'low_stock',
                            onTap: () {
                              controller.setFilter(
                                controller.selectedFilter.value == 'low_stock'
                                    ? 'all'
                                    : 'low_stock',
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Harga Terendah',
                            icon: Icons.arrow_downward_rounded,
                            isSelected: controller.selectedSort.value == 'price_low',
                            onTap: () {
                              controller.setSort(
                                controller.selectedSort.value == 'price_low'
                                    ? 'default'
                                    : 'price_low',
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Harga Tertinggi',
                            icon: Icons.arrow_upward_rounded,
                            isSelected: controller.selectedSort.value == 'price_high',
                            onTap: () {
                              controller.setSort(
                                controller.selectedSort.value == 'price_high'
                                    ? 'default'
                                    : 'price_high',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Filter status info banner
              if (controller.isFiltered)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Menampilkan ${filteredList.length} dari ${controller.products.length} produk',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.resetFilters,
                        child: const Text(
                          'Reset Filter',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Products Grid or Empty Filter
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 54,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Produk Tidak Ditemukan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.searchQuery.value.isNotEmpty
                                    ? 'Tidak ada produk yang cocok dengan kata kunci "${controller.searchQuery.value}".'
                                    : 'Tidak ada produk yang sesuai dengan filter yang dipilih.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: controller.resetFilters,
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text('Reset Pencarian'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                          return GridView.builder(
                            padding: const EdgeInsets.only(
                              left: 14,
                              right: 14,
                              top: 14,
                              bottom: 88,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final product = filteredList[index];
                              return ProductCard(product: product);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => Get.toNamed(AppRoutes.addProduct),
        icon: const Icon(Icons.add_business_outlined),
        label: const Text('Tambah Produk'),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
