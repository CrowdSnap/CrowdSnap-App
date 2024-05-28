import 'package:crowd_snap/core/data/models/user_model.dart';

abstract class UsersRepository {
  Future<UserModel> getUser(String userId);
  Future<void> addConnection(String localUserId, String userId);
  Future<void> removeConnection(String localUserId, String userId);
  Future<bool> checkConnection(String localUserId, String userId);
  Future<void> getUserConnections(String userId);
}
