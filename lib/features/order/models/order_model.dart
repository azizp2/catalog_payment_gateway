import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/currency_formatter.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    @Default('') String productId,
    @Default(0) int quantity,
    @Default(0.0) double unitPrice,
    @Default('IDR') String currency,
    @Default(0.0) double subtotal,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  String get formattedUnitPrice => CurrencyFormatter.format(unitPrice);
  String get formattedSubtotal => CurrencyFormatter.format(subtotal);
}

@freezed
abstract class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    @Default('') String id,
    @Default('') String customerId,
    @Default('') String customerEmail,
    @Default('Pending') String status,
    @Default(0.0) double totalAmount,
    @Default('IDR') String currency,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<OrderItemModel> items,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  String get formattedTotal => CurrencyFormatter.format(totalAmount);

  String get formattedCreatedAt {
    if (createdAt == null) return '-';
    return DateFormat('dd MMM yyyy, HH:mm').format(createdAt!.toLocal());
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
}
