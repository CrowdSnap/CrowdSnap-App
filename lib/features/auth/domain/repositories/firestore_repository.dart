import 'package:crowd_snap/features/auth/data/models/user_model.dart';

abstract class FirestoreRepository {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser(String userId);
}