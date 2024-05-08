// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      mongoId: json['mongoId'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      taggedUserIds: (json['taggedUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likedUserIds: (json['likedUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'mongoId': instance.mongoId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'imageUrl': instance.imageUrl,
      'taggedUserIds': instance.taggedUserIds,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
      'likedUserIds': instance.likedUserIds,
      'description': instance.description,
    };
