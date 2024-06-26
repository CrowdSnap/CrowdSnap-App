import 'dart:io';

import 'package:crowd_snap/core/data/data_source/push_notification_data_source.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_upload_use_case.dart';
import 'package:crowd_snap/features/profile/data/models/connection_status.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_use_case.g.dart';

class CreatePostUseCase {
  final PostRepository _postRepository;
  final GetUserLocalUseCase _getUserUseCase;
  final ImageUploadUseCase _imageUploadUseCase;
  final PushNotificationDataSource _notificationDataSource;
  final UsersRepository _usersRepository;

  CreatePostUseCase(
      this._postRepository,
      this._getUserUseCase,
      this._imageUploadUseCase,
      this._notificationDataSource,
      this._usersRepository);

  Future<void> execute(File image, List<String> taggedUserIds) async {
    final userModel = await _getUserUseCase.execute();
    final userName = userModel.username;
    final avatarBlurHash = userModel.blurHashImage;
    List<String> finalTaggedUserIds = [];
    List<String> pendingTaggedUserIds = [];

    final (imageUrl, blurHash, aspectRatio) =
        await _imageUploadUseCase.execute(image, userName: userName);
    
    print('Image uploaded with url: $imageUrl');

    for (final receiverId in taggedUserIds) {
      final receiverUser =
          await _usersRepository.checkConnection(userModel.userId, receiverId);
      print('Receiver user: $receiverUser');
      if (receiverUser.connectionStatus == ConnectionStatus.connected) {
        finalTaggedUserIds.add(receiverId);
      } else {
        pendingTaggedUserIds.add(receiverId);
      }
    }

    print('Final tagged user IDs: $finalTaggedUserIds and pending tagged user IDs: $pendingTaggedUserIds');

    final post = PostModel(
      userId: userModel.userId,
      userName: userName,
      userAvatarUrl: userModel.avatarUrl!,
      location: 'Madrid', //TODO: get location method
      taggedUserIds: finalTaggedUserIds, // Add tagged user IDs here
      taggedPendingUserIds: pendingTaggedUserIds,
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
    final postId = await _postRepository.createPost(post);

    print('Post created with ID: $postId');

    for (final receiverId in pendingTaggedUserIds) {
      await _usersRepository.addTaggingConnection(
        userModel.userId,
        receiverId,
        imageUrl,
        postId,
      );
    }

    print('Tagging connections added!');

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

    print('Push notifications sent to tagged users!');
  }
}

@riverpod
CreatePostUseCase createPostUseCase(CreatePostUseCaseRef ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final imageUploadUseCase = ref.watch(imageUploadUseCaseProvider);
  final getUserUseCase = ref.watch(getUserLocalUseCaseProvider);
  final notificationDataSource = ref.watch(pushNotificationDataSourceProvider);
  final usersRepository = ref.watch(usersRepositoryProvider);

  return CreatePostUseCase(postRepository, getUserUseCase, imageUploadUseCase,
      notificationDataSource, usersRepository);
}
