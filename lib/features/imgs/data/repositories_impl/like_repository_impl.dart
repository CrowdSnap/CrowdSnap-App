import 'package:crowd_snap/core/data/models/like_model.dart';
import 'package:crowd_snap/features/imgs/data/data_source/like_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/repository/like_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_repository_impl.g.dart';

@Riverpod(keepAlive: true)
LikeRepositoryImpl likeRepository(LikeRepositoryRef ref) {
  final likeDataSource = ref.watch(likeDataSourceProvider);
  return LikeRepositoryImpl(likeDataSource);
}

class LikeRepositoryImpl implements LikeRepository {
  final LikeDataSource _likeDataSource;

  LikeRepositoryImpl(this._likeDataSource);

  @override
  Future<List<LikeModel>> getLikesByPostId(String postId) {
    return _likeDataSource.getLikesByPostId(postId);
  }

  @override
  Future<void> createLike(LikeModel like) {
    return _likeDataSource.createLike(like);
  }

  @override
  Future<void> removeLike(String postId, String userId) {
    return _likeDataSource.removeLike(postId, userId);
  }
}