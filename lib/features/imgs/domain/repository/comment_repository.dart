import 'package:crowd_snap/core/data/models/comment_model.dart';

abstract class CommentRepository {
  Future<List<CommentModel>> getCommentsByPost(String postId);
  Future<CommentModel> getCommentById(String commentId);
  Future<void> createComment(CommentModel comment);
  Future<void> addLikeToComment(String commentId, String userId);
  Future<void> removeLikeFromComment(String commentId, String userId);
}
