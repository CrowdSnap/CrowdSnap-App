import 'package:freezed_annotation/freezed_annotation.dart';

part 'comments_model.freezed.dart';
part 'comments_model.g.dart';

@freezed
class CommentsModel with _$CommentsModel {
  const factory CommentsModel({
    required String commentId,
    required String userId,
    required String comment,
    required DateTime createdAt,
    int? likes,
  }) = _CommentsModel;

  factory CommentsModel.fromJson(Map<String, dynamic> json) => _$CommentsModelFromJson(json);
}