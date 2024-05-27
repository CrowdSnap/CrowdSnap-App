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
      birthDate: DateTime.parse(json['birthDate'] as String),
      firstTime: json['firstTime'] as bool,
      connectionsCount: json['connectionsCount'] as String,
      statusString: json['statusString'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      blurHashImage: json['blurHashImage'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'birthDate': instance.birthDate.toIso8601String(),
      'firstTime': instance.firstTime,
      'connectionsCount': instance.connectionsCount,
      'statusString': instance.statusString,
      'avatarUrl': instance.avatarUrl,
      'blurHashImage': instance.blurHashImage,
      'city': instance.city,
    };
