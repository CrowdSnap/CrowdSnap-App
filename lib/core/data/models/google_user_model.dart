import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_user_model.freezed.dart';
part 'google_user_model.g.dart';

@freezed
class GoogleUserModel with _$GoogleUserModel {
  const factory GoogleUserModel({
    required String userId,
    String? name,
    String? email,
    required DateTime joinedAt,
    bool? firstTime,
    String? avatarUrl,
  }) = _GoogleUserModel;

  factory GoogleUserModel.fromJson(Map<String, dynamic> json) => _$GoogleUserModelFromJson(json);
}