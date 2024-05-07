// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      userId: json['userId'] as String,
      imageUrl: json['imageUrl'] as String,
      taggedUserIds: (json['taggedUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'imageUrl': instance.imageUrl,
      'taggedUserIds': instance.taggedUserIds,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
    };
