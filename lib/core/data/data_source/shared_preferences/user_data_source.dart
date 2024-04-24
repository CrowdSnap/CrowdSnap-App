import 'dart:convert';

import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_source.g.dart';

abstract class UserModelDataSource {
  Future<void> saveUserModel(UserModel userModel);
  Future<UserModel> getUserModel();
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
    await prefs.setString('userModel', userModelJson);
  }

  @override
  Future<UserModel> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final userModelJson = prefs.getString('userModel');
    if (userModelJson != null) {
      Map<String, dynamic> userModelMap = jsonDecode(userModelJson);
      return UserModel.fromJson(userModelMap);
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
