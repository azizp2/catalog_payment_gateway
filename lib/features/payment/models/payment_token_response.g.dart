// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentTokenResponse _$PaymentTokenResponseFromJson(
  Map<String, dynamic> json,
) => _PaymentTokenResponse(
  token: json['token'] as String? ?? '',
  redirectUrl: json['redirectUrl'] as String? ?? '',
);

Map<String, dynamic> _$PaymentTokenResponseToJson(
  _PaymentTokenResponse instance,
) => <String, dynamic>{
  'token': instance.token,
  'redirectUrl': instance.redirectUrl,
};
