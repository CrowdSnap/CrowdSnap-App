import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_remove_like_use_case.g.dart';

class PostRemoveLikeUseCase {
  final PostRepository _postRepository;

  PostRemoveLikeUseCase(this._postRepository);

  Future<void> execute(String postId, String userId) async {
    _postRepository.removeLikeFromPost(postId, userId);
  }
}

@riverpod
PostRemoveLikeUseCase postRemoveLikeUseCase(PostRemoveLikeUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostRemoveLikeUseCase(postRepository);
}
