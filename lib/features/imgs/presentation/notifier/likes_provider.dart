import 'package:crowd_snap/core/data/models/like_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_provider.g.dart';

@Riverpod(keepAlive: true)
class LikesNotifier extends _$LikesNotifier {
  @override
  List<LikeModel> build() {
    return [];
  }

  void addLike(LikeModel like) {
    state = [...state, like];
  }

  void removeLike(String userId) {
    state = state.where((like) => like.userId != userId).toList();
  }

  void setLikes(List<LikeModel> likes) {
    state = likes;
  }
}