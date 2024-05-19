import 'package:crowd_snap/core/data/models/like_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikesNotifier extends StateNotifier<List<LikeModel>> {
  bool _isFirstLoad = true;

  LikesNotifier() : super([]);

  void addLike(LikeModel like) {
    state = [...state, like];
  }

  void removeLike(String userId) {
    state = state.where((like) => like.userId != userId).toList();
  }

  void setLikes(List<LikeModel> likes) {
    state = likes;
  }

  bool get isFirstLoad => _isFirstLoad;

  void markAsLoaded() {
    _isFirstLoad = false;
  }
}

final likesNotifierProvider =
    StateNotifierProvider.family<LikesNotifier, List<LikeModel>, String>(
        (ref, postId) {
  return LikesNotifier();
});
