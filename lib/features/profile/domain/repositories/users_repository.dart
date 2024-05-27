import 'package:crowd_snap/core/data/models/user_model.dart';

abstract class UsersRepository {
  Future<UserModel> getUser(String userId);
}
