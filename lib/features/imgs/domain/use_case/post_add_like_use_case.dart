import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_add_like_use_case.g.dart';

class PostAddLikeUseCase {
  final PostRepository _postRepository;

  PostAddLikeUseCase(this._postRepository);

  Future<void> execute(String postId, String userId) async {

    await _postRepository.addLikeToPost(postId, userId);
  }
}

@riverpod
PostAddLikeUseCase postAddLikeUseCase(PostAddLikeUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostAddLikeUseCase(postRepository);
}