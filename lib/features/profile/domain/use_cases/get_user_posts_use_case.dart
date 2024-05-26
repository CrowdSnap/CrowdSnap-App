import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/user_posts_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/user_posts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_posts_use_case.g.dart';

class GetUserPostsUseCase {
  final UserPostsRepository _repository;

  GetUserPostsUseCase(this._repository);

  Future<List<PostModel>> execute(String userId) async {
    return await _repository.getUserPosts(userId);
  }
}

@riverpod
Future<List<PostModel>> userPostsProvider(UserPostsProviderRef ref, String userId) async {
  final getUserPostsUseCase = ref.watch(getUserPostsUseCaseProvider);
  return await getUserPostsUseCase.execute(userId);
}

@Riverpod(keepAlive: true)
GetUserPostsUseCase getUserPostsUseCase(GetUserPostsUseCaseRef ref) {
  final postsRepository = ref.watch(userPostsRepositoryProvider);
  return GetUserPostsUseCase(postsRepository);
}