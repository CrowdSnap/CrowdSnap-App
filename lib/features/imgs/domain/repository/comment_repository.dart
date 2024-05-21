import 'package:crowd_snap/core/data/models/comment_model.dart';

abstract class CommentRepository {
  Future<List<CommentModel>> getCommentsByPost(String postId);
  Future<CommentModel> getCommentById(String postId, String commentId);
  Future<void> createComment(String postId, CommentModel comment);
  Future<void> deleteComment(String postId, String commentId);
}
