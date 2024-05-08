import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_add_like_use_case.g.dart';

class PostAddLikeUseCase {
  final PostRepository _postRepository;
  final GetUserUseCase _getUserUseCase;

  PostAddLikeUseCase(this._postRepository, this._getUserUseCase);

  Future<void> execute(String postId) async {
    final userModel = await _getUserUseCase.execute();
    final userId = userModel.userId;
    return _postRepository.addLikeToPost(postId, userId);
  }
}

@riverpod
PostAddLikeUseCase postAddLikeUseCase(PostAddLikeUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final getUserUseCase = ref.watch(getUserUseCaseProvider);
  return PostAddLikeUseCase(postRepository, getUserUseCase);
}