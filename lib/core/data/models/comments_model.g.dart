// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentsModelImpl _$$CommentsModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentsModelImpl(
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: (json['likes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CommentsModelImplToJson(_$CommentsModelImpl instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'userId': instance.userId,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'likes': instance.likes,
    };
