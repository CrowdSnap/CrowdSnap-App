import 'package:crowd_snap/features/imgs/data/repositories_impl/comment_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/comment_repository.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/comments_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_delete_use_case.g.dart';

class DeleteCommentUseCase {
  final CommentRepository _commentRepository;
  final CommentsNotifier _commentsNotifier;

  DeleteCommentUseCase(this._commentRepository, this._commentsNotifier);

  Future<void> execute(String commentId, String postId) async {
    _commentsNotifier.removeComment(commentId);
    await _commentRepository.deleteComment(postId, commentId);
  }
}

@riverpod
DeleteCommentUseCase deleteCommentUseCase(DeleteCommentUseCaseRef ref, String postId) {
  final commentRepository = ref.watch(commentRepositoryProvider);
  final commentsNotifier = ref.watch(commentsNotifierProvider(postId).notifier);
  return DeleteCommentUseCase(commentRepository, commentsNotifier);
}