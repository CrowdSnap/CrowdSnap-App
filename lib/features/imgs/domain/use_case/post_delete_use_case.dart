import 'package:crowd_snap/features/imgs/data/repositories_impl/image_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/image_bucket_repository.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_delete_use_case.g.dart';

class DeletePostUseCase {
  final PostRepository _postRepository;
  final ImageBucketRepository _imageBucketRepository;

  DeletePostUseCase(this._postRepository, this._imageBucketRepository);

  Future<void> execute(String postId, String imageUrl) async {
    final imageName = imageUrl.split('/').last;
    await _postRepository.deletePost(postId);
    await _imageBucketRepository.deleteImage(imageName);
  }
}

@riverpod
DeletePostUseCase deletePostUseCase(DeletePostUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final imageBucketRepository = ref.watch(imageBucketRepositoryProvider);

  return DeletePostUseCase(postRepository, imageBucketRepository);
}