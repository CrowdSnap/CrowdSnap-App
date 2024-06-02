import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_ranking_use_case.g.dart';

class PostRankingUseCase {
  final PostRepository _postRepository;

  PostRankingUseCase(this._postRepository);

  Future<List<PostModel>> execute(
      String location, DateTime startDate, DateTime endDate, int limit, List<String> excludeIds) {
    return _postRepository.getPostsOrderedByLikes(
        location, startDate, endDate, limit, excludeIds);
  }
}

@riverpod
PostRankingUseCase postRankingUseCase(
    PostRankingUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostRankingUseCase(postRepository);
}