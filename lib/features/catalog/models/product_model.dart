import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/currency_formatter.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    @Default('') String id,
    @Default('') String name,
    @Default(0.0) double price,
    @Default('IDR') String currency,
    @Default(0) int stock,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  String get formattedPrice => CurrencyFormatter.format(price);
  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 5;
}
