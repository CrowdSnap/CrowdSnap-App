import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_get_use_case.g.dart';

class GetPostsRandomByDateRangeUseCase {
  final PostRepository _postRepository;

  GetPostsRandomByDateRangeUseCase(this._postRepository);

  Future<List<PostModel>> execute(
      String location, DateTime startDate, DateTime endDate, int limit) {
    return _postRepository.getPostsRandomByDateRange(
        location, startDate, endDate, limit);
  }
}

@riverpod
GetPostsRandomByDateRangeUseCase getPostsRandomByDateRangeUseCase(
    GetPostsRandomByDateRangeUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return GetPostsRandomByDateRangeUseCase(postRepository);
}
