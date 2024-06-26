import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:crowd_snap/features/imgs/data/data_source/comment_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/repository/comment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_repository_impl.g.dart';

@Riverpod(keepAlive: true)
CommentRepositoryImpl commentRepository(CommentRepositoryRef ref) {
  final commentDataSource = ref.watch(commentDataSourceProvider);
  return CommentRepositoryImpl(commentDataSource);
}

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource _commentDataSource;

  CommentRepositoryImpl(this._commentDataSource);

  @override
  Future<List<CommentModel>> getCommentsByPost(String postId) {
    return _commentDataSource.getCommentsByPost(postId);
  }

  @override
  Future<CommentModel> getCommentById(String postId, String commentId) {
    return _commentDataSource.getCommentById(postId, commentId);
  }

  @override
  Future<void> createComment(String postId, CommentModel comment) {
    return _commentDataSource.createComment(postId, comment);
  }

  @override
  Future<void> deleteComment(String postId, String commentId) {
    return _commentDataSource.deleteComment(postId, commentId);
  }
}
