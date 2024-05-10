import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/data/data_source/post_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository_impl.g.dart';

@Riverpod(keepAlive: true)
PostRepositoryImpl postRepository(PostRepositoryRef ref) {
  final postDataSource = ref.watch(postDataSourceProvider);
  return PostRepositoryImpl(postDataSource);
}

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _postDataSource;

  PostRepositoryImpl(this._postDataSource);

  @override
  Future<List<PostModel>> getPostsRandomByDateRange(
      String location, DateTime startDate, DateTime endDate, int limit) {
    return _postDataSource.getPostsRandomByDateRange(location, startDate, endDate, limit);
  }

  @override
  Future<void> createPost(PostModel post) {
    return _postDataSource.createPost(post);
  }

  @override
  Future<void> addLikeToPost(String postId, String userId) {
    return _postDataSource.addLikeToPost(postId, userId);
  }

  @override
  Future<void> removeLikeFromPost(String postId, String userId) {
    return _postDataSource.removeLikeFromPost(postId, userId);
  }

  @override
  Future<List<PostModel>> getPostsByUser(String userId) {
    return _postDataSource.getPostsByUser(userId);
  }

  @override
  Future<void> incrementCommentCount(String postId) {
    return _postDataSource.incrementCommentCount(postId);
  }

  @override
  Future<void> decrementCommentCount(String postId) {
    return _postDataSource.decrementCommentCount(postId);
  }
}