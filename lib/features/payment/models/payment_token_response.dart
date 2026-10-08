import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_token_response.freezed.dart';
part 'payment_token_response.g.dart';

@freezed
abstract class PaymentTokenResponse with _$PaymentTokenResponse {
  const factory PaymentTokenResponse({
    @Default('') String token,
    @Default('') String redirectUrl,
  }) = _PaymentTokenResponse;

  factory PaymentTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentTokenResponseFromJson(json);
}
