// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProductRequest _$CreateProductRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProductRequest(
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'IDR',
  stock: (json['stock'] as num).toInt(),
);

Map<String, dynamic> _$CreateProductRequestToJson(
  _CreateProductRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'price': instance.price,
  'currency': instance.currency,
  'stock': instance.stock,
};
