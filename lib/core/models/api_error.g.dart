// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => _ApiError(
  message: json['message'] as String? ?? '',
  statusCode: (json['statusCode'] as num?)?.toInt(),
  details: json['details'],
);

Map<String, dynamic> _$ApiErrorToJson(_ApiError instance) => <String, dynamic>{
  'message': instance.message,
  'statusCode': instance.statusCode,
  'details': instance.details,
};
