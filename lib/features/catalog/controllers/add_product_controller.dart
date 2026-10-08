import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../models/create_product_request.dart';
import '../repositories/catalog_repository.dart';
import 'catalog_controller.dart';

class AddProductController extends GetxController {
  final CatalogRepository repository;

  AddProductController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }

  Future<void> submitProduct() async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(stockController.text.trim()) ?? 0;

    isSubmitting.value = true;

    try {
      final req = CreateProductRequest(
        name: name,
        price: price,
        stock: stock,
      );

      final product = await repository.createProduct(req);
      SnackbarHelper.showSuccess(
        title: 'Berhasil',
        message: 'Produk "${product.name}" berhasil ditambahkan!',
      );

      // Refresh catalog list if CatalogController is registered
      if (Get.isRegistered<CatalogController>()) {
        Get.find<CatalogController>().fetchProducts();
      }

      Get.back(result: true);
    } catch (e) {
      SnackbarHelper.showError(
        title: 'Gagal Menambah Produk',
        message: e.toString(),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
