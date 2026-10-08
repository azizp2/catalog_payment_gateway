// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateOrderItemRequest _$CreateOrderItemRequestFromJson(
  Map<String, dynamic> json,
) => _CreateOrderItemRequest(
  productId: json['productId'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CreateOrderItemRequestToJson(
  _CreateOrderItemRequest instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'quantity': instance.quantity,
};

_CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    _CreateOrderRequest(
      customerId: json['customerId'] as String,
      customerEmail: json['customerEmail'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => CreateOrderItemRequest.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$CreateOrderRequestToJson(_CreateOrderRequest instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'customerEmail': instance.customerEmail,
      'items': instance.items,
    };
