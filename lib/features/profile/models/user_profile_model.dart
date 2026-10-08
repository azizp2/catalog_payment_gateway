import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    @Default('Budi Santoso') String name,
    @Default('pelanggan@tokomini.com') String email,
    @Default('3fa85f64-5717-4562-b3fc-2c963f66afa6') String customerId,
    @Default('Jl. Sudirman No. 45, Jakarta') String address,
    @Default('+62 812-3456-7890') String phone,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}
