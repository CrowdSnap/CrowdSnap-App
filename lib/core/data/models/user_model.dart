import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String userId,
    required String username,
    required String name,
    required String email,
    required DateTime joinedAt,
    required DateTime birthDate,
    required bool firstTime,
    required int connectionsCount,
    String? fcmToken,
    String? statusString,
    String? avatarUrl,
    String? blurHashImage,
    String? city,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
