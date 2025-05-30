import 'package:crowd_snap/core/data/data_source/push_notification_data_source.dart';
import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:crowd_snap/features/profile/data/models/user_model.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accept_tagged_use_case.g.dart';

class AcceptTaggedUseCase {
  final UsersRepository _usersRepository;
  final PostRepository _postRepository;
  final PushNotificationDataSource _notificationDataSource;

  AcceptTaggedUseCase(this._usersRepository, this._notificationDataSource, this._postRepository);

  Future<void> execute(UserModel user, String receiverId, String receiverFcmToken, String imageUrl, String postId) async {
    await _usersRepository.acceptTaggingConnection(user.userId, receiverId);
    await _postRepository.acceptPendingTaggedToPost(postId, user.userId);
    await _notificationDataSource.sendPushNotification(
      PushNotificationModel(
        fcmToken: receiverFcmToken,
        title: '${user.name} ha aceptado aparecer en la foto!',
        body: '${user.username} ahora es una persona más en tu lista de conexiones',
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
AcceptTaggedUseCase acceptTaggedUseCase(AcceptTaggedUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  final postRepository = ref.watch(postRepositoryProvider);
  final notificationDataSource = ref.watch(pushNotificationDataSourceProvider);
  return AcceptTaggedUseCase(usersRepository, notificationDataSource, postRepository);
}