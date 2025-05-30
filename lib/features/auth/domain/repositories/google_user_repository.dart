import 'package:crowd_snap/features/auth/data/models/google_user_model.dart';

abstract class GoogleUserRepository {
  Future<void> saveGoogleUser(GoogleUserModel googleUser);
  Future<GoogleUserModel> getGoogleUser();
  Future<void> deleteGoogleUser();
}