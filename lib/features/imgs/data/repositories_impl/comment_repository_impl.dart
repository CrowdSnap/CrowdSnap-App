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
  Future<CommentModel> getCommentById(String commentId) {
    return _commentDataSource.getCommentById(commentId);
  }

  @override
  Future<void> createComment(CommentModel comment) {
    return _commentDataSource.createComment(comment);
  }

  @override
  Future<void> addLikeToComment(String commentId, String userId) {
    return _commentDataSource.addLikeToComment(commentId, userId);
  }

  @override
  Future<void> removeLikeFromComment(String commentId, String userId) {
    return _commentDataSource.removeLikeFromComment(commentId, userId);
  }
}
