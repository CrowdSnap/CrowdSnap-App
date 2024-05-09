import 'package:crowd_snap/core/data/models/like_model.dart';

abstract class LikeRepository {
  Future<List<LikeModel>> getLikesByPostId(String postId);
  Future<void> createLike(LikeModel like);
  Future<void> removeLike(String postId, String userId);
}