import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ecommerce_flutter/features/catalog/controllers/catalog_controller.dart';
import 'package:mini_ecommerce_flutter/features/catalog/models/create_product_request.dart';
import 'package:mini_ecommerce_flutter/features/catalog/models/product_model.dart';
import 'package:mini_ecommerce_flutter/features/catalog/repositories/catalog_repository.dart';

class FakeCatalogRepository implements CatalogRepository {
  final List<ProductModel> items;

  FakeCatalogRepository(this.items);

  @override
  Future<List<ProductModel>> getProducts() async => items;

  @override
  Future<ProductModel> getProductById(String id) async =>
      items.firstWhere((p) => p.id == id);

  @override
  Future<ProductModel> createProduct(CreateProductRequest request) async =>
      ProductModel(
        id: 'new-id',
        name: request.name,
        price: request.price,
        stock: request.stock,
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CatalogController Search, Filter & Sort Unit Tests', () {
    late CatalogController controller;
    final testProducts = [
      const ProductModel(id: '1', name: 'Laptop Gaming ASUS ROG', price: 15000000, stock: 10),
      const ProductModel(id: '2', name: 'Mouse Wireless Logitech', price: 250000, stock: 3),
      const ProductModel(id: '3', name: 'Mechanical Keyboard RGB', price: 750000, stock: 0),
      const ProductModel(id: '4', name: 'Headphone Bluetooth Sony', price: 2000000, stock: 15),
    ];

    setUp(() async {
      controller = CatalogController(
        repository: FakeCatalogRepository(testProducts),
      );
      await controller.fetchProducts();
    });

    tearDown(() {
      controller.onClose();
    });

    test('should load all products initially', () {
      expect(controller.products.length, 4);
      expect(controller.filteredProducts.length, 4);
      expect(controller.isFiltered, false);
    });

    test('should filter products by search query', () {
      controller.onSearchChanged('mouse');
      expect(controller.filteredProducts.length, 1);
      expect(controller.filteredProducts.first.name, 'Mouse Wireless Logitech');
      expect(controller.isFiltered, true);

      controller.clearSearch();
      expect(controller.filteredProducts.length, 4);
    });

    test('should filter products by in_stock', () {
      controller.setFilter('in_stock');
      expect(controller.filteredProducts.length, 3);
      expect(controller.filteredProducts.every((p) => p.isInStock), true);
    });

    test('should filter products by low_stock', () {
      controller.setFilter('low_stock');
      expect(controller.filteredProducts.length, 1);
      expect(controller.filteredProducts.first.name, 'Mouse Wireless Logitech');
    });

    test('should sort products by price ascending', () {
      controller.setSort('price_low');
      final prices = controller.filteredProducts.map((p) => p.price).toList();
      expect(prices, [250000, 750000, 2000000, 15000000]);
    });

    test('should sort products by price descending', () {
      controller.setSort('price_high');
      final prices = controller.filteredProducts.map((p) => p.price).toList();
      expect(prices, [15000000, 2000000, 750000, 250000]);
    });

    test('should reset all filters and sorts correctly', () {
      controller.onSearchChanged('sony');
      controller.setFilter('in_stock');
      controller.setSort('price_high');
      expect(controller.isFiltered, true);

      controller.resetFilters();
      expect(controller.isFiltered, false);
      expect(controller.searchQuery.value, '');
      expect(controller.selectedFilter.value, 'all');
      expect(controller.selectedSort.value, 'default');
      expect(controller.filteredProducts.length, 4);
    });
  });
}
