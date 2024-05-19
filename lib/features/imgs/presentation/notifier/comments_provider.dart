import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_provider.g.dart';

@Riverpod(keepAlive: true)
class CommentsNotifier extends _$CommentsNotifier {
  @override
  List<CommentModel> build() {
    return [];
  }

  void addComment(CommentModel comment) {
    state = [...state, comment];
  }

  void removeComment(String commentId) {
    state = state.where((comment) => comment.commentId != commentId).toList();
  }

  void setComments(List<CommentModel> comments) {
    state = comments;
  }
}