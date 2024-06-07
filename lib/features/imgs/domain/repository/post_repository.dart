import 'package:crowd_snap/core/data/models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPostsRandomByDateRange(String location,
      DateTime startDate, DateTime endDate, int limit, List<String> excludeIds);
  Future<List<PostModel>> getPostsOrderedByLikes(String location,
      DateTime startDate, DateTime endDate, int limit, List<String> excludeIds);
  Future<List<PostModel>> getTaggedPostsByUserId(String userId);
  Future<String> createPost(PostModel post);
  Future<void> addLikeToPost(String postId, String userId);
  Future<void> removeLikeFromPost(String postId, String userId);
  Future<List<PostModel>> getPostsByUser(String userId);
  Future<void> incrementCommentCount(String postId);
  Future<void> decrementCommentCount(String postId);
  Future<void> deletePendingTaggedFromPost(String postId, String userId);
  Future<void> acceptPendingTaggedToPost(String postId, String userId);
  Future<void> deletePost(String postId);
}
