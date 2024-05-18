import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/comment_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/comment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_create_use_case.g.dart';

class CreateCommentUseCase {
  final GetUserUseCase _getUserUseCase;
  final CommentRepository _commentRepository;

  CreateCommentUseCase(this._getUserUseCase, this._commentRepository);

  Future<CommentModel> execute(String text, String postId) async {
    final userModel = await _getUserUseCase.execute();
    final userId = userModel.userId;

    final comment = CommentModel(
      userId: userId,
      text: text,
      createdAt: DateTime.now(),
      likes: 0,
    );

    await _commentRepository.createComment(postId, comment);
    return comment;
  }
}

@riverpod
CreateCommentUseCase createCommentUseCase(CreateCommentUseCaseRef ref) {
  final getUserUseCase = ref.watch(getUserUseCaseProvider);
  final commentRepository = ref.watch(commentRepositoryProvider);
  return CreateCommentUseCase(getUserUseCase, commentRepository);
}