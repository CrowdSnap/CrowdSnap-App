import 'package:crowd_snap/core/data/data_source/push_notification_data_source.dart';
import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reject_connection_use_case.g.dart';

class RejectConnectionUseCase {
  final UsersRepository _repository;
  final PushNotificationDataSource _notificationDataSource;

  RejectConnectionUseCase(this._repository, this._notificationDataSource);

  Future<void> execute(
      UserModel user, String receiverId, String receiverFcmToken) async {
    await _repository.rejectConnection(user.userId, receiverId);
    await _notificationDataSource.sendPushNotification(
      PushNotificationModel(
        fcmToken: receiverFcmToken,
        title: '${user.name} ha rechazado tu solicitud de conexión!',
        body: '${user.username} no desea ser tu amigo en este momento',
        imageUrl: user.avatarUrl!,
        userId: user.userId,
        username: user.username,
        avatarUrl: user.avatarUrl!,
        blurHashImage: user.blurHashImage!,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
RejectConnectionUseCase rejectConnectionUseCase(
    RejectConnectionUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  final notificationDataSource = ref.watch(pushNotificationDataSourceProvider);
  return RejectConnectionUseCase(usersRepository, notificationDataSource);
}
