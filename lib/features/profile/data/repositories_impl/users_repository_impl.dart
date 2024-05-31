import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/profile/data/data_source/users_data_source.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_repository_impl.g.dart';

@Riverpod(keepAlive: true)
UsersRepository usersRepository(UsersRepositoryRef ref) {
  final usersDataSource = ref.watch(usersDataSourceProvider);
  return UsersRepositoryImpl(usersDataSource);
}

class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource _usersModelDataSource;

  UsersRepositoryImpl(this._usersModelDataSource);

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final usersModel = await _usersModelDataSource.getUser(userId);
      return usersModel;
    } catch (e) {
      throw Exception('Failed to get user from Firestore');
    }
  }

  @override
  Future<void> updateUserFCMToken(UserModel user, String fcmToken) async {
    try {
      await _usersModelDataSource.updateUserFCMToken(user, fcmToken);
    } catch (e) {
      throw Exception('Failed to update user FCM token: $e');
    }
  }

  @override
  Future<void> addConnection(String localUserId, String userId) async {
    await _usersModelDataSource.addConnection(localUserId, userId);
  }

  @override
  Future<void> removeConnection(String localUserId, String userId) async {
    await _usersModelDataSource.removeConnection(localUserId, userId);
  }

  @override
  Future<bool> checkConnection(String localUserId, String userId) async {
    final result =
        await _usersModelDataSource.checkConnection(localUserId, userId);
    return result;
  }

  @override
  Future<List<Map<String, DateTime>>> getUserConnections(String userId,
      {String? startAfter, int limit = 30}) async {
    try {
      return await _usersModelDataSource.getUserConnections(
        userId,
        startAfter: startAfter,
        limit: limit,
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
