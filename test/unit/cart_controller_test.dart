import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ecommerce_flutter/features/cart/controllers/cart_controller.dart';
import 'package:mini_ecommerce_flutter/features/catalog/models/product_model.dart';
import 'package:mini_ecommerce_flutter/features/order/models/order_model.dart';

void main() {
  group('CartController Unit Tests', () {
    late CartController cartController;

    setUp(() {
      cartController = CartController();
    });

    test('should start with empty cart', () {
      expect(cartController.itemCount, 0);
      expect(cartController.totalAmount, 0.0);
      expect(cartController.items.isEmpty, true);
    });

    test('should add product to cart and calculate totals', () {
      const product = ProductModel(
        id: 'prod-1',
        name: 'Keyboard Mechanical',
        price: 500000,
        currency: 'IDR',
        stock: 10,
      );

      cartController.addToCart(product, quantity: 2);

      expect(cartController.itemCount, 2);
      expect(cartController.totalAmount, 1000000.0);
      expect(cartController.isInCart('prod-1'), true);
      expect(cartController.getQuantity('prod-1'), 2);
    });

    test('should update quantity within available stock', () {
      const product = ProductModel(
        id: 'prod-1',
        name: 'Keyboard Mechanical',
        price: 500000,
        currency: 'IDR',
        stock: 5,
      );

      cartController.addToCart(product, quantity: 1);
      cartController.updateQuantity('prod-1', 4);

      expect(cartController.getQuantity('prod-1'), 4);
      expect(cartController.totalAmount, 2000000.0);
    });

    test('should remove item when quantity set to 0', () {
      const product = ProductModel(
        id: 'prod-1',
        name: 'Keyboard Mechanical',
        price: 500000,
        currency: 'IDR',
        stock: 5,
      );

      cartController.addToCart(product, quantity: 2);
      cartController.updateQuantity('prod-1', 0);

      expect(cartController.isInCart('prod-1'), false);
      expect(cartController.itemCount, 0);
    });

    test('should clear all items in cart', () {
      const product = ProductModel(
        id: 'prod-1',
        name: 'Item 1',
        price: 10000,
        stock: 10,
      );

      cartController.addToCart(product, quantity: 3);
      cartController.clearCart();

      expect(cartController.itemCount, 0);
      expect(cartController.items.isEmpty, true);
    });
  });

  group('Freezed Models Tests', () {
    test('ProductModel JSON serialization', () {
      final json = {
        'id': 'p-1',
        'name': 'Mouse Gaming',
        'price': 250000.0,
        'currency': 'IDR',
        'stock': 15,
      };

      final product = ProductModel.fromJson(json);
      expect(product.id, 'p-1');
      expect(product.name, 'Mouse Gaming');
      expect(product.isInStock, true);
      expect(product.formattedPrice.contains('250.000'), true);
    });

    test('OrderModel status getters', () {
      const pendingOrder = OrderModel(
        id: 'o-1',
        status: 'Pending',
        totalAmount: 100000,
      );
      expect(pendingOrder.isPending, true);
      expect(pendingOrder.isPaid, false);

      final paidOrder = pendingOrder.copyWith(status: 'Paid');
      expect(paidOrder.isPaid, true);
      expect(paidOrder.isPending, false);
    });
  });
}
