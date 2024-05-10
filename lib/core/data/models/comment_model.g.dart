// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: (json['likes'] as num).toInt(),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'userId': instance.userId,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'likes': instance.likes,
    };
