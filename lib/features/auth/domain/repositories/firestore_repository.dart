import 'package:crowd_snap/core/data/models/user_model.dart';

abstract class FirestoreRepository {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<void> updateUserAvatar(String avatarUrl);
  Future<void> deleteUser(String userId);
}