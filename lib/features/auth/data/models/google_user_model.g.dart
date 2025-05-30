// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoogleUserModelImpl _$$GoogleUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GoogleUserModelImpl(
      userId: json['userId'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      firstTime: json['firstTime'] as bool?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$GoogleUserModelImplToJson(
        _$GoogleUserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'firstTime': instance.firstTime,
      'avatarUrl': instance.avatarUrl,
    };
