import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsNotifier extends StateNotifier<List<CommentModel>> {
  bool _isFirstLoad = true;

  CommentsNotifier() : super([]);

  void addComment(CommentModel comment) {
    state = [...state, comment];
  }

  void removeComment(String commentId) {
    state = state.where((comment) => comment.commentId != commentId).toList();
  }

  void setComments(List<CommentModel> comments) {
    state = comments;
  }

  bool get isFirstLoad => _isFirstLoad;

  void markAsLoaded() {
    _isFirstLoad = false;
  }
}

final commentsNotifierProvider =
    StateNotifierProvider.family<CommentsNotifier, List<CommentModel>, String>(
        (ref, postId) {
  return CommentsNotifier();
});
