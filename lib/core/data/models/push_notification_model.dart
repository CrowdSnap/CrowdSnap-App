import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_model.freezed.dart';
part 'push_notification_model.g.dart';

@freezed
class PushNotificationModel with _$PushNotificationModel {
  const factory PushNotificationModel({
    required String title,
    required String body,
    required String fcmToken,
    required String imageUrl,
    required String userId, 
    required String username,
    required String avatarUrl,
    required String blurHashImage,
  }) = _PushNotificationModel;

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationModelFromJson(json);
}