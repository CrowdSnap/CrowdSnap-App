import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/profile/data/models/user_model.dart';
import 'package:crowd_snap/core/errors/exceptions.dart';
import 'package:crowd_snap/core/errors/result.dart';

abstract class UserRepository {
  Future<Result<void, AppException>> saveUser(UserModel user);
  Future<Result<void, AppException>> updateUserAvatar(String avatarUrl, String blurHash);
  Future<Result<void, AppException>> updateUserFCMToken(String fcmToken);
  Future<Result<UserModel, AppException>> getUser();
  Future<Result<void, AppException>> savePosts(List<PostModel> posts);
  Future<Result<List<PostModel>, AppException>> getPosts();
  Future<Result<void, AppException>> deleteUser();
}
