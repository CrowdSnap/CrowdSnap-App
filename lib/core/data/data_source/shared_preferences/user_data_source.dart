import 'dart:convert';

import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_source.g.dart';

abstract class UserModelDataSource {
  Future<void> saveUserModel(UserModel userModel);
  Future<UserModel> getUserModel();
  Future<void> updateUserAvatar(String avatarUrl, String blurHash);
  Future<void> updateUserFCMToken(String fcmToken);
  Future<void> savePosts(List<PostModel> posts);
  Future<List<PostModel>> getPosts();
  Future<void> deleteUserModel();
}

@Riverpod(keepAlive: true)
UserModelDataSource userModelDataSource(UserModelDataSourceRef ref) {
  return UserModelDataSourceImpl();
}

class UserModelDataSourceImpl implements UserModelDataSource {
  UserModelDataSourceImpl();

  @override
  Future<void> saveUserModel(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    String userModelJson = jsonEncode(userModel.toJson());
    print('Saving user model: $userModel');
    await prefs.setString('userModel', userModelJson);
  }

  @override
  Future<void> savePosts(List<PostModel> posts) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> postList = posts.map((post) => post.toJson()).toList();
    String postsJson = jsonEncode(postList);
    await prefs.setString('posts', postsJson);
  }

  @override
  Future<List<PostModel>> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString('posts');
    if (postsJson != null) {
      List<dynamic> postList = jsonDecode(postsJson);
      return postList.map((post) => PostModel.fromJson(post)).toList();
    } else {
      throw Exception('Posts not found in SharedPreferences');
    }
  }

  @override
  Future<UserModel> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final userModelJson = prefs.getString('userModel');
    if (userModelJson != null) {
      Map<String, dynamic> userModelMap = jsonDecode(userModelJson);
      print('UserModel found in SharedPreferences: $userModelMap');
      return UserModel.fromJson(userModelMap);
    } else {
      print('UserModel not found in SharedPreferences');
      throw Exception('UserModel not found in SharedPreferences');
    }
  }

  @override
  Future<void> updateUserAvatar(String avatarUrl, String blurHash) async {
    final prefs = await SharedPreferences.getInstance();
    final userModelJson = prefs.getString('userModel');
    if (userModelJson != null) {
      Map<String, dynamic> userModelMap = jsonDecode(userModelJson);
      userModelMap['avatarUrl'] = avatarUrl;
      userModelMap['blurHashImage'] = blurHash;
      String updatedUserModelJson = jsonEncode(userModelMap);
      await prefs.setString('userModel', updatedUserModelJson);
    } else {
      throw Exception('UserModel not found in SharedPreferences');
    }
  }

  @override
  Future<void> updateUserFCMToken(String fcmToken) async {
    final prefs = await SharedPreferences.getInstance();
    final userModelJson = prefs.getString('userModel');
    if (userModelJson != null) {
      Map<String, dynamic> userModelMap = jsonDecode(userModelJson);
      userModelMap['fcmToken'] = fcmToken;
      String updatedUserModelJson = jsonEncode(userModelMap);
      await prefs.setString('userModel', updatedUserModelJson);
    } else {
      throw Exception('UserModel not found in SharedPreferences');
    }
  }

  @override
  Future<void> deleteUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userModel');
  }
}
