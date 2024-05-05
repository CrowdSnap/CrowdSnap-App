import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/data/data_sources/post_data_source.dart';
import 'package:crowd_snap/features/home/domain/repositories/post_repository.dart';
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
      String city, DateTime startDate, DateTime endDate, int limit) {
    return _postDataSource.getPostsRandomByDateRange(city, startDate, endDate, limit);
  }

  @override
  Future<void> createPost(PostModel post) {
    return _postDataSource.createPost(post);
  }
}