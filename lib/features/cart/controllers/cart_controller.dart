import 'package:get/get.dart';
import '../../../app/config/app_config.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../catalog/models/product_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  final RxMap<String, CartItemModel> items = <String, CartItemModel>{}.obs;
  final RxString customerEmail = AppConfig.defaultCustomerEmail.obs;
  final RxString customerId = AppConfig.defaultCustomerId.obs;

  List<CartItemModel> get itemsList => items.values.toList();

  int get itemCount {
    var count = 0;
    for (var item in items.values) {
      count += item.quantity;
    }
    return count;
  }

  double get totalAmount {
    var total = 0.0;
    for (var item in items.values) {
      total += item.subtotal;
    }
    return total;
  }

  String get formattedTotal => CurrencyFormatter.format(totalAmount);

  bool isInCart(String productId) => items.containsKey(productId);

  int getQuantity(String productId) => items[productId]?.quantity ?? 0;

  void setCustomerInfo({required String email, required String id}) {
    customerEmail.value = email;
    customerId.value = id;
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    if (items.containsKey(product.id)) {
      final current = items[product.id]!;
      final newQty = (current.quantity + quantity).clamp(1, product.stock);
      items[product.id] = current.copyWith(quantity: newQty);
    } else {
      items[product.id] = CartItemModel(
        productId: product.id,
        productName: product.name,
        price: product.price,
        currency: product.currency,
        quantity: quantity.clamp(1, product.stock),
        availableStock: product.stock,
      );
    }
    update();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (!items.containsKey(productId)) return;

    if (newQuantity <= 0) {
      items.remove(productId);
    } else {
      final current = items[productId]!;
      if (newQuantity <= current.availableStock) {
        items[productId] = current.copyWith(quantity: newQuantity);
      }
    }
    update();
  }

  void removeFromCart(String productId) {
    items.remove(productId);
    update();
  }

  void clearCart() {
    items.clear();
    update();
  }
}
