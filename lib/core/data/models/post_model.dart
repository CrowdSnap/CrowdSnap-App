import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    String? mongoId,
    required String userId,
    required String userName,
    required String userAvatarUrl,
    required String imageUrl,
    required List<String> taggedUserIds,
    required String location,
    required DateTime createdAt,
    required int likeCount,
    required int commentCount,
    required List<String> likedUserIds,
    String? description,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
