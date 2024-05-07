import 'package:crowd_snap/core/data/models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPostsRandomByDateRange(
      String location, DateTime startDate, DateTime endDate, int limit);
  Future<void> createPost(PostModel post);
}
