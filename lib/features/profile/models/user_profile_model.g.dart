// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      name: json['name'] as String? ?? 'Budi Santoso',
      email: json['email'] as String? ?? 'pelanggan@tokomini.com',
      customerId:
          json['customerId'] as String? ??
          '3fa85f64-5717-4562-b3fc-2c963f66afa6',
      address: json['address'] as String? ?? 'Jl. Sudirman No. 45, Jakarta',
      phone: json['phone'] as String? ?? '+62 812-3456-7890',
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'customerId': instance.customerId,
      'address': instance.address,
      'phone': instance.phone,
    };
