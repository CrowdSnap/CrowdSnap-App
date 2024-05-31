
import 'package:crowd_snap/core/data/data_source/shared_preferences/user_data_source.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository_impl.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final userModelDataSource = ref.watch(userModelDataSourceProvider);
  return UserRepositoryImpl(userModelDataSource);
}

class UserRepositoryImpl implements UserRepository {
  final UserModelDataSource _userModelDataSource;

  UserRepositoryImpl(this._userModelDataSource);

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _userModelDataSource.saveUserModel(user);
    } catch (e) {
      throw Exception('Failed to save user to SharedPreferences');
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final userModel = await _userModelDataSource.getUserModel();
      return userModel;
    } catch (e) {
      throw Exception('Failed to get user from SharedPreferences');
    } 
  }

  @override
  Future<void> updateUserAvatar(String avatarUrl, String blurHash) async {
    try {
      await _userModelDataSource.updateUserAvatar(avatarUrl, blurHash);
    } catch (e) {
      throw Exception('Failed to update user avatar in SharedPreferences');
    }
  }

  @override
  Future<void> updateUserFCMToken(String fcmToken) async {
    try {
      await _userModelDataSource.updateUserFCMToken(fcmToken);
    } catch (e) {
      throw Exception('Failed to update user FCM token in SharedPreferences');
    }
  }

  @override
  Future<void> savePosts(List<PostModel> posts) async {
    try {
      await _userModelDataSource.savePosts(posts);
    } catch (e) {
      throw Exception('Failed to save posts to SharedPreferences');
    }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final posts = await _userModelDataSource.getPosts();
      return posts;
    } catch (e) {
      throw Exception('Failed to get posts from SharedPreferences');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await _userModelDataSource.deleteUserModel();
    } catch (e) {
      throw Exception('Failed to delete user from SharedPreferences');
    }
  }
}