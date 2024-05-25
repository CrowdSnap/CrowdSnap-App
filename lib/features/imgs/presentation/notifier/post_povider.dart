import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostNotifier extends StateNotifier<List<CommentModel>> {
  bool _isDeleted = false;
  bool _isLongPressed = false;

  PostNotifier() : super([]);

  bool get isDeleted => _isDeleted;
  bool get isLongPressed => _isLongPressed;

  void markAsDeleted() {
    _isDeleted = true;
    state = [...state]; // Notificar a los oyentes sobre el cambio
    print('Deleted');
  }

  void markAsLongPressed() {
    _isLongPressed = true;
    state = [...state]; // Notificar a los oyentes sobre el cambio
    print('Long pressed');
  }

  void resetLongPress() {
    _isLongPressed = false;
    state = [...state]; // Notificar a los oyentes sobre el cambio
    print('Long press reset');
  }
}

final postNotifierProvider =
    StateNotifierProvider.family<PostNotifier, List<CommentModel>, String>(
        (ref, postId) {
  return PostNotifier();
});
