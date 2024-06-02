import 'package:crowd_snap/core/data/data_source/push_notification_data_source.dart';
import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accept_connection_use_case.g.dart';

class AcceptConnectionUseCase {
  final UsersRepository _repository;
  final PushNotificationDataSource _notificationDataSource;

  AcceptConnectionUseCase(this._repository, this._notificationDataSource);

  Future<void> execute(UserModel user, String receiverId, String receiverFcmToken) async {
    await _repository.acceptConnection(user.userId, receiverId);
    await _notificationDataSource.sendPushNotification(
      PushNotificationModel(
        fcmToken: receiverFcmToken,
        title: '${user.name} ha aceptado tu solicitud de conexión!',
        body: '${user.username} ahora es una persona más en tu lista de conexiones',
        imageUrl: user.avatarUrl,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
AcceptConnectionUseCase acceptConnectionUseCase(AcceptConnectionUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  final notificationDataSource = ref.watch(pushNotificationDataSourceProvider);
  return AcceptConnectionUseCase(usersRepository, notificationDataSource);
}