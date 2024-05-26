import 'package:crowd_snap/core/data/models/post_model.dart';

abstract class UserPostsRepository {
  Future<List<PostModel>> getUserPosts(String userId);
}