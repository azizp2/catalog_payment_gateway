// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_token_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentTokenResponse {

 String get token; String get redirectUrl;
/// Create a copy of PaymentTokenResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentTokenResponseCopyWith<PaymentTokenResponse> get copyWith => _$PaymentTokenResponseCopyWithImpl<PaymentTokenResponse>(this as PaymentTokenResponse, _$identity);

  /// Serializes this PaymentTokenResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentTokenResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,redirectUrl);

@override
String toString() {
  return 'PaymentTokenResponse(token: $token, redirectUrl: $redirectUrl)';
}


}

/// @nodoc
abstract mixin class $PaymentTokenResponseCopyWith<$Res>  {
  factory $PaymentTokenResponseCopyWith(PaymentTokenResponse value, $Res Function(PaymentTokenResponse) _then) = _$PaymentTokenResponseCopyWithImpl;
@useResult
$Res call({
 String token, String redirectUrl
});




}
/// @nodoc
class _$PaymentTokenResponseCopyWithImpl<$Res>
    implements $PaymentTokenResponseCopyWith<$Res> {
  _$PaymentTokenResponseCopyWithImpl(this._self, this._then);

  final PaymentTokenResponse _self;
  final $Res Function(PaymentTokenResponse) _then;

/// Create a copy of PaymentTokenResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? redirectUrl = null,}) {
  return _then(PaymentTokenResponse(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,redirectUrl: null == redirectUrl ? _self.redirectUrl : redirectUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentTokenResponse].
extension PaymentTokenResponsePatterns on PaymentTokenResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentTokenResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentTokenResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentTokenResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaymentTokenResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentTokenResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentTokenResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String redirectUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentTokenResponse() when $default != null:
return $default(_that.token,_that.redirectUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String redirectUrl)  $default,) {final _that = this;
switch (_that) {
case _PaymentTokenResponse():
return $default(_that.token,_that.redirectUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String redirectUrl)?  $default,) {final _that = this;
switch (_that) {
case _PaymentTokenResponse() when $default != null:
return $default(_that.token,_that.redirectUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentTokenResponse implements PaymentTokenResponse {
  const _PaymentTokenResponse({this.token = '', this.redirectUrl = ''});
  factory _PaymentTokenResponse.fromJson(Map<String, dynamic> json) => _$PaymentTokenResponseFromJson(json);

@override@JsonKey() final  String token;
@override@JsonKey() final  String redirectUrl;

/// Create a copy of PaymentTokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentTokenResponseCopyWith<_PaymentTokenResponse> get copyWith => __$PaymentTokenResponseCopyWithImpl<_PaymentTokenResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentTokenResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentTokenResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,redirectUrl);

@override
String toString() {
  return 'PaymentTokenResponse(token: $token, redirectUrl: $redirectUrl)';
}


}

/// @nodoc
abstract mixin class _$PaymentTokenResponseCopyWith<$Res> implements $PaymentTokenResponseCopyWith<$Res> {
  factory _$PaymentTokenResponseCopyWith(_PaymentTokenResponse value, $Res Function(_PaymentTokenResponse) _then) = __$PaymentTokenResponseCopyWithImpl;
@override @useResult
$Res call({
 String token, String redirectUrl
});




}
/// @nodoc
class __$PaymentTokenResponseCopyWithImpl<$Res>
    implements _$PaymentTokenResponseCopyWith<$Res> {
  __$PaymentTokenResponseCopyWithImpl(this._self, this._then);

  final _PaymentTokenResponse _self;
  final $Res Function(_PaymentTokenResponse) _then;

/// Create a copy of PaymentTokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? redirectUrl = null,}) {
  return _then(_PaymentTokenResponse(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,redirectUrl: null == redirectUrl ? _self.redirectUrl : redirectUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
