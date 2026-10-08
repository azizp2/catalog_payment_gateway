import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../repositories/catalog_repository.dart';

class CatalogController extends GetxController {
  final CatalogRepository repository;

  CatalogController({required this.repository});

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  // Search, Filter & Sort State
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'all'.obs; // 'all', 'in_stock', 'low_stock'
  final RxString selectedSort = 'default'.obs; // 'default', 'price_low', 'price_high', 'name'

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await repository.getProducts();
      products.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Gagal memuat produk: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void setSort(String sort) {
    selectedSort.value = sort;
  }

  void resetFilters() {
    clearSearch();
    selectedFilter.value = 'all';
    selectedSort.value = 'default';
  }

  bool get isFiltered =>
      searchQuery.value.trim().isNotEmpty ||
      selectedFilter.value != 'all' ||
      selectedSort.value != 'default';

  List<ProductModel> get filteredProducts {
    var list = products.toList();

    // 1. Search Query Filter
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((p) => p.name.toLowerCase().contains(query)).toList();
    }

    // 2. Stock Filter
    if (selectedFilter.value == 'in_stock') {
      list = list.where((p) => p.isInStock).toList();
    } else if (selectedFilter.value == 'low_stock') {
      list = list.where((p) => p.isLowStock).toList();
    }

    // 3. Sorting
    switch (selectedSort.value) {
      case 'price_low':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      default:
        // default order from API
        break;
    }

    return list;
  }
}

