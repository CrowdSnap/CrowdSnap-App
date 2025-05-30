import 'package:crowd_snap/core/data/data_source/push_notification_data_source.dart';
import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:crowd_snap/features/profile/data/models/user_model.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reject_tagged_use_case.g.dart';

class RejectTaggedUseCase {
  final UsersRepository _usersRepository;
  final PostRepository _postRepository;
  final PushNotificationDataSource _notificationDataSource;

  RejectTaggedUseCase(this._usersRepository, this._notificationDataSource, this._postRepository);

  Future<void> execute(UserModel user, String receiverId, String receiverFcmToken, String imageUrl, String postId) async {
    await _usersRepository.removeTaggingConnection(user.userId, receiverId);
    await _postRepository.deletePendingTaggedFromPost(postId, user.userId);
    await _notificationDataSource.sendPushNotification(
      PushNotificationModel(
        fcmToken: receiverFcmToken,
        title: '${user.name} ha rechazado aparecer en la foto!',
        body: '${user.username} podrás probar suerte en otra foto!',
        imageUrl: imageUrl,
        userId: user.userId,
        username: user.username,
        avatarUrl: user.avatarUrl!,
        blurHashImage: user.blurHashImage!,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
RejectTaggedUseCase rejectTaggedUseCase(RejectTaggedUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  final postRepository = ref.watch(postRepositoryProvider);
  final notificationDataSource = ref.watch(pushNotificationDataSourceProvider);
  return RejectTaggedUseCase(usersRepository, notificationDataSource, postRepository);
}