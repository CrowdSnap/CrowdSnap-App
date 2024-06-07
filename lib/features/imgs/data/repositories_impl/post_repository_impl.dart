import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/data/data_source/post_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository_impl.g.dart';

@Riverpod(keepAlive: true)
PostRepositoryImpl postRepository(PostRepositoryRef ref) {
  final postDataSource = ref.watch(postDataSourceProvider);
  final usersRepository = ref.watch(usersRepositoryProvider);
  return PostRepositoryImpl(postDataSource, usersRepository);
}

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _postDataSource;
  final UsersRepository _usersRepository;

  PostRepositoryImpl(this._postDataSource, this._usersRepository);

  @override
  Future<List<PostModel>> getPostsRandomByDateRange(
      String location,
      DateTime startDate,
      DateTime endDate,
      int limit,
      List<String> excludeIds) {
    return _postDataSource.getPostsRandomByDateRange(
        location, startDate, endDate, limit, excludeIds);
  }

  @override
  Future<List<PostModel>> getPostsOrderedByLikes(
      String location,
      DateTime startDate,
      DateTime endDate,
      int limit,
      List<String> excludeIds) {
    return _postDataSource.getPostsOrderedByLikes(
        location, startDate, endDate, limit, excludeIds);
  }

  @override
  Future<List<PostModel>> getTaggedPostsByUserId(String userId) async {
    final taggedPosts = [];
    final taggedInOthers = await _postDataSource.getTaggedPostsByUserId(userId);
    final taggedInOwn = await _postDataSource.getPostsByUser(userId);
    for (final post in taggedInOwn) {
      if (post.taggedUserIds.isNotEmpty) {
        if (post.taggedUserIds.length == 1) {
          // Extraer el userId del array y crear una nueva instancia de PostModel con el userId modificado
          final newUserId = post.taggedUserIds.first;
          final newUser = await _usersRepository.getUser(newUserId);
          final updatedPost = post.copyWith(userId: newUserId, blurHashAvatar: newUser.blurHashImage!, userName: newUser.username, userAvatarUrl: newUser.avatarUrl!);
          taggedPosts.add(updatedPost);
        } else {
          taggedPosts.add(post);
        }
      }
    }
    return [...taggedInOthers, ...taggedPosts];
  }

  @override
  Future<String> createPost(PostModel post) {
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

  @override
  Future<void> deletePendingTaggedFromPost(String postId, String userId) {
    return _postDataSource.deletePendingTaggedFromPost(postId, userId);
  }

  @override
  Future<void> acceptPendingTaggedToPost(String postId, String userId) {
    return _postDataSource.acceptPendingTaggedToPost(postId, userId);
  }

  @override
  Future<void> deletePost(String postId) {
    return _postDataSource.deletePost(postId);
  }
}
