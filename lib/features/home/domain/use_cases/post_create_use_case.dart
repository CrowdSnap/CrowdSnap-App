import 'dart:io';

import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/home/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/home/domain/repositories/post_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_upload_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_use_case.g.dart';

class CreatePostUseCase {
  final PostRepository _postRepository;
  final GetUserUseCase _getUserUseCase;
  final ImageUploadUseCase _imageUploadUseCase;

  CreatePostUseCase(
      this._postRepository, this._getUserUseCase, this._imageUploadUseCase);

  Future<void> execute(File image) async {
    final userModel = await _getUserUseCase.execute();
    final userName = userModel.username;
    final imageUrl =
        await _imageUploadUseCase.execute(image, userName: userName);
    final post = PostModel(
      userId: userModel.userId,
      location: 'Madrid', //TODO: get location method
      taggedUserIds: [],
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    print('Post created with image url: $imageUrl');
    _postRepository.createPost(post);
  }
}

@riverpod
CreatePostUseCase createPostUseCase(CreatePostUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final imageUploadUseCase = ref.watch(imageUploadUseCaseProvider);
  final getUserUseCase = ref.watch(getUserUseCaseProvider);

  return CreatePostUseCase(postRepository, getUserUseCase, imageUploadUseCase);
}
