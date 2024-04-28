import 'package:crowd_snap/core/data/models/google_user_model.dart';

abstract class GoogleUserRepository {
  Future<void> saveGoogleUser(GoogleUserModel googleUser);
  Future<GoogleUserModel> getGoogleUser();
  Future<void> deleteGoogleUser();
}