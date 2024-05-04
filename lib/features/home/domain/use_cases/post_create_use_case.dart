import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/home/domain/repositories/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_use_case.g.dart';

class CreatePostUseCase {
  final PostRepository _postRepository;

  CreatePostUseCase(this._postRepository);

  Future<void> execute(PostModel post, String city) {
    return _postRepository.createPost(post, city);
  }
}

@riverpod
CreatePostUseCase createPostUseCase(CreatePostUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return CreatePostUseCase(postRepository);
}
