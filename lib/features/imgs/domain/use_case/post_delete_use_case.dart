import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_delete_use_case.g.dart';

class DeletePostUseCase {
  final PostRepository _postRepository;

  DeletePostUseCase(this._postRepository);

  Future<void> execute(String postId) async {
    await _postRepository.deletePost(postId);
  }
}

@riverpod
DeletePostUseCase deletePostUseCase(DeletePostUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);

  return DeletePostUseCase(postRepository);
}