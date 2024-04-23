import 'package:crowd_snap/core/data/models/user_model.dart';

abstract class UserRepository {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser();
  Future<void> deleteUser();
}