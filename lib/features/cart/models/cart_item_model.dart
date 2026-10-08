import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/currency_formatter.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
abstract class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required String productId,
    required String productName,
    required double price,
    @Default('IDR') String currency,
    required int quantity,
    required int availableStock,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  double get subtotal => price * quantity;
  String get formattedPrice => CurrencyFormatter.format(price);
  String get formattedSubtotal => CurrencyFormatter.format(subtotal);
}
