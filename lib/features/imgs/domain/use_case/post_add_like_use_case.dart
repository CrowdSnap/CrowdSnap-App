import 'package:crowd_snap/core/data/models/like_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/like_repository_impl.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/like_repository.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_add_like_use_case.g.dart';

class PostAddLikeUseCase {
  final LikeRepository _likeRepository;
  final PostRepository _postRepository;

  PostAddLikeUseCase(this._likeRepository, this._postRepository);

  Future<void> execute(String postId, String userId) async {

    final like = LikeModel(
      postId: postId,
      userId: userId,
      createdAt: DateTime.now(),
    );

    _likeRepository.createLike(like);
    _postRepository.addLikeToPost(postId, userId);
  }
}

@riverpod
PostAddLikeUseCase postAddLikeUseCase(PostAddLikeUseCaseRef ref) {
  final likeRepository = ref.watch(likeRepositoryProvider);
  final postRepository = ref.watch(postRepositoryProvider);
  return PostAddLikeUseCase(likeRepository, postRepository);
}
