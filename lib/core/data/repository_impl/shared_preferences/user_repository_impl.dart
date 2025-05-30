import 'package:crowd_snap/core/errors/exceptions.dart';
import 'package:crowd_snap/core/errors/result.dart';
import 'package:fpdart/fpdart.dart';
import 'package:crowd_snap/core/data/data_source/shared_preferences/user_data_source.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/profile/data/models/user_model.dart';
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
  Future<Result<void, AppException>> saveUser(UserModel user) async {
    try {
      await _userModelDataSource.saveUserModel(user);
      return const Right(unit);
    } catch (e) {
      // TODO: Add logging
      return Left(CacheException('Failed to save user to SharedPreferences: ${e.toString()}'));
    }
  }

  @override
  Future<Result<UserModel, AppException>> getUser() async {
    try {
      final userModel = await _userModelDataSource.getUserModel();
      return Right(userModel);
    } catch (e) {
      // TODO: Add logging
      return Left(CacheException('Failed to get user from SharedPreferences: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, AppException>> updateUserAvatar(String avatarUrl, String blurHash) async {
    try {
      await _userModelDataSource.updateUserAvatar(avatarUrl, blurHash);
      return const Right(unit);
    } catch (e) {
      // TODO: Add logging
      return Left(CacheException('Failed to update user avatar in SharedPreferences: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, AppException>> updateUserFCMToken(String fcmToken) async {
    try {
      await _userModelDataSource.updateUserFCMToken(fcmToken);
      return const Right(unit);
    } catch (e) {
      // TODO: Add logging
      return Left(CacheException('Failed to update user FCM token in SharedPreferences: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, AppException>> savePosts(List<PostModel> posts) async {
    try {
      await _userModelDataSource.savePosts(posts);
      return const Right(unit);
    } catch (e) {
      // TODO: Add logging
      return Left(CacheException('Failed to save posts to SharedPreferences: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<PostModel>, AppException>> getPosts() async {
    try {
      final posts = await _userModelDataSource.getPosts();
      return Right(posts);
    } catch (e) {
      // TODO: Add logging
      return Left(CacheException('Failed to get posts from SharedPreferences: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, AppException>> deleteUser() async {
    try {
      await _userModelDataSource.deleteUserModel();
      return const Right(unit);
    } catch (e) {
      // TODO: Add logging
      return Left(CacheException('Failed to delete user from SharedPreferences: ${e.toString()}'));
    }
  }
}