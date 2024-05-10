import 'package:crowd_snap/features/imgs/data/repositories_impl/like_repository_impl.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/like_repository.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_remove_like_use_case.g.dart';

class PostRemoveLikeUseCase {
  final PostRepository _postRepository;
  final LikeRepository _likeRepository;

  PostRemoveLikeUseCase(this._postRepository, this._likeRepository);

  Future<void> execute(String postId, String userId) async {
    _likeRepository.removeLike(postId, userId);
    _postRepository.removeLikeFromPost(postId, userId);
  }
}

@riverpod
PostRemoveLikeUseCase postRemoveLikeUseCase(PostRemoveLikeUseCaseRef ref) {
  final likeRepository = ref.watch(likeRepositoryProvider);
  final postRepository = ref.watch(postRepositoryProvider);
  return PostRemoveLikeUseCase(postRepository, likeRepository);
}
