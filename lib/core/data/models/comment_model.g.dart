// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: (json['likes'] as num).toInt(),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'userId': instance.userId,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'likes': instance.likes,
    };
