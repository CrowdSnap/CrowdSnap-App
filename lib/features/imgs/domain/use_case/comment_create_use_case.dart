import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/comment_repository_impl.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/comment_repository.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_create_use_case.g.dart';

class CreateCommentUseCase {
  final CommentRepository _commentRepository;
  final GetUserUseCase _getUserUseCase;
  final PostRepository _postRepository;

  CreateCommentUseCase(this._commentRepository, this._getUserUseCase, this._postRepository);

  Future<void> execute(String text, String postId) async {
    final userModel = await _getUserUseCase.execute();
    final userId = userModel.userId;

    final comment = CommentModel(
      postId: postId,
      userId: userId,
      text: text,
      createdAt: DateTime.now(),
      likes: 0,
    );
    print('Comment created with text: $text');
    _commentRepository.createComment(comment);
    _postRepository.incrementCommentCount(postId);
  }
}

@riverpod
CreateCommentUseCase createCommentUseCase(CreateCommentUseCaseRef ref) {
  final commentRepository = ref.watch(commentRepositoryProvider);
  final getUserUseCase = ref.watch(getUserUseCaseProvider);
  final postRepository = ref.watch(postRepositoryProvider);
  return CreateCommentUseCase(commentRepository, getUserUseCase, postRepository);
}