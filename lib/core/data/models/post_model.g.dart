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
      taggedPendingUserIds: (json['taggedPendingUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      taggedUserIds: (json['taggedUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      likes: (json['likes'] as List<dynamic>)
          .map((e) => LikeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      blurHashImage: json['blurHashImage'] as String,
      blurHashAvatar: json['blurHashAvatar'] as String,
      aspectRatio: (json['aspectRatio'] as num).toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'mongoId': instance.mongoId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'imageUrl': instance.imageUrl,
      'taggedPendingUserIds': instance.taggedPendingUserIds,
      'taggedUserIds': instance.taggedUserIds,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'likes': instance.likes,
      'comments': instance.comments,
      'blurHashImage': instance.blurHashImage,
      'blurHashAvatar': instance.blurHashAvatar,
      'aspectRatio': instance.aspectRatio,
      'description': instance.description,
    };
