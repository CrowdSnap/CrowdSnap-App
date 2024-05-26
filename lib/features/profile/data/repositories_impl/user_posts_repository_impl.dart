import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/profile/data/data_source/user_posts_data_source.dart';
import 'package:crowd_snap/features/profile/domain/repositories/user_posts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_post_repository_impl.g.dart';

@Riverpod(keepAlive: true)
UserPostsRepository userPostsRepository(UserPostsRepositoryRef ref) {
  final userPostsDataSource = ref.watch(userPostsDataSourceProvider);
  return UserPostsRepositoryImpl(userPostsDataSource);
}

class UserPostsRepositoryImpl implements UserPostsRepository {
  final UserPostsDataSource _userPostsDataSource;

  UserPostsRepositoryImpl(this._userPostsDataSource);

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final userPosts = await _userPostsDataSource.getUserPosts(userId);
      return userPosts;
    } catch (e) {
      throw Exception('Failed to get user posts from SharedPreferences');
    }
  }
}