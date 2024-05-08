import 'package:crowd_snap/core/data/models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPostsRandomByDateRange(
      String location, DateTime startDate, DateTime endDate, int limit);
  Future<void> createPost(PostModel post);
  Future<void> addLikeToPost(String postId, String userId);
  Future<void> removeLikeFromPost(String postId, String userId);
}
