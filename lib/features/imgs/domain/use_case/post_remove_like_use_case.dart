import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_remove_like_use_case.g.dart';

class PostRemoveLikeUseCase {
  final PostRepository _postRepository;
  final GetUserUseCase _getUserUseCase;

  PostRemoveLikeUseCase(this._postRepository, this._getUserUseCase);

  Future<void> execute(String postId) async {
    final userModel = await _getUserUseCase.execute();
    final userId = userModel.userId;
    return _postRepository.removeLikeFromPost(postId, userId);
  }
}

@riverpod
PostRemoveLikeUseCase postRemoveLikeUseCase(PostRemoveLikeUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final getUserUseCase = ref.watch(getUserUseCaseProvider);
  return PostRemoveLikeUseCase(postRepository, getUserUseCase);
}