import 'dart:io';

import 'package:crowd_snap/core/data/data_source/push_notification_data_source.dart';
import 'package:crowd_snap/core/data/models/push_notification_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/image_bucket_repository_impl.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_connection_tagged_use_case.g.dart';

class AddConnectionTaggedUseCase {
  final UsersRepository _repository;
  final PushNotificationDataSource _notificationDataSource;
  final ImageBucketRepositoryImpl _imageBucketRepository;

  AddConnectionTaggedUseCase(this._repository, this._notificationDataSource,
      this._imageBucketRepository);

  Future<void> execute(UserModel localUser, String receiverId, File image) async {
    final imageUrl = await _imageBucketRepository.uploadImage(image, localUser.userId);
    final receiverUser = await _repository.getUser(receiverId);
    await _repository.addConnection(localUser.userId, receiverId);
    await _notificationDataSource.sendPushNotification(
      PushNotificationModel(
        fcmToken: receiverUser.fcmToken!,
        title: '${localUser.name} te quiere etiquetar en una foto!',
        body:
            '¡Conecta con ${localUser.username} para que podáis subir esta foto en vuestros perfiles y conectar!',
        imageUrl: imageUrl,
        userId: localUser.userId,
        username: localUser.username,
        avatarUrl: localUser.avatarUrl!,
        blurHashImage: localUser.blurHashImage!,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
AddConnectionTaggedUseCase addConnectionTaggedUseCase(
    AddConnectionTaggedUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  final notificationDataSource = ref.watch(pushNotificationDataSourceProvider);
  final imageBucketRepository = ref.watch(imageBucketRepositoryProvider);
  return AddConnectionTaggedUseCase(
      usersRepository, notificationDataSource, imageBucketRepository);
}
