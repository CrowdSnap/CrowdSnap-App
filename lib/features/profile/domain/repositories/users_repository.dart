import 'package:crowd_snap/core/data/models/user_model.dart';

abstract class UsersRepository {
  Future<UserModel> getUser(String userId);
  Future<void> addConnection(String userId, String connectionId);
  Future<void> removeConnection(String userId, String connectionId);
}
