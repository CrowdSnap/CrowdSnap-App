import 'dart:io';

import 'package:crowd_snap/core/data/data_source/push_notification_data_source.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_upload_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_use_case.g.dart';

class CreatePostUseCase {
  final PostRepository _postRepository;
  final GetUserLocalUseCase _getUserUseCase;
  final ImageUploadUseCase _imageUploadUseCase;
  final PushNotificationDataSource _notificationDataSource;

  CreatePostUseCase(this._postRepository, this._getUserUseCase,
      this._imageUploadUseCase, this._notificationDataSource);

  Future<void> execute(File image, List<String> taggedUserIds) async {
    final userModel = await _getUserUseCase.execute();
    final userName = userModel.username;
    final avatarBlurHash = userModel.blurHashImage;

    final (imageUrl, blurHash, aspectRatio) =
        await _imageUploadUseCase.execute(image, userName: userName);
    final post = PostModel(
      userId: userModel.userId,
      userName: userName,
      userAvatarUrl: userModel.avatarUrl!,
      location: 'Madrid', //TODO: get location method
      taggedUserIds: taggedUserIds, // Add tagged user IDs here
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
      likes: [],
      comments: [],
      blurHashImage: blurHash,
      blurHashAvatar: avatarBlurHash!,
      aspectRatio: aspectRatio,
    );
    print('Post created with image url: $imageUrl');
    _postRepository.createPost(post);

    final pushNotification = PushNotificationModel(
      title: '${userModel.username} te ha etiquetado en una publicación!',
      body:
          '¡Revisa su perfil para aceptar su conexión y que la publicación también sea tuya!',
      imageUrl: imageUrl,
      userId: userModel.userId,
      username: userModel.username,
      avatarUrl: userModel.avatarUrl!,
      blurHashImage: userModel.blurHashImage!,
    );

    // Send push notification to tagged users
    await _notificationDataSource.sendPushNotifications(
      taggedUserIds,
      pushNotification,
    );
  }
}

@riverpod
CreatePostUseCase createPostUseCase(CreatePostUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final imageUploadUseCase = ref.watch(imageUploadUseCaseProvider);
  final getUserUseCase = ref.watch(getUserLocalUseCaseProvider);
  final notificationDataSource = ref.watch(pushNotificationDataSourceProvider);

  return CreatePostUseCase(postRepository, getUserUseCase, imageUploadUseCase,
      notificationDataSource);
}
