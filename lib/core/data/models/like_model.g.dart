// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LikeModelImpl _$$LikeModelImplFromJson(Map<String, dynamic> json) =>
    _$LikeModelImpl(
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$LikeModelImplToJson(_$LikeModelImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
