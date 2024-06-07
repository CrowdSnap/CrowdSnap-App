// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PushNotificationModelImpl _$$PushNotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PushNotificationModelImpl(
      title: json['title'] as String,
      body: json['body'] as String,
      fcmToken: json['fcmToken'] as String?,
      imageUrl: json['imageUrl'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String,
      blurHashImage: json['blurHashImage'] as String,
    );

Map<String, dynamic> _$$PushNotificationModelImplToJson(
        _$PushNotificationModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'fcmToken': instance.fcmToken,
      'imageUrl': instance.imageUrl,
      'userId': instance.userId,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'blurHashImage': instance.blurHashImage,
    };
