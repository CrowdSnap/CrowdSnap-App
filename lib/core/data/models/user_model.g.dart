// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      firstTime: json['firstTime'] as bool,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'firstTime': instance.firstTime,
      'avatarUrl': instance.avatarUrl,
    };