import 'dart:convert';

import 'package:crowd_snap/features/auth/data/models/google_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_user_data_source.g.dart';

abstract class GoogleUserModelDataSource {
  Future<void> saveGoogleUserModel(GoogleUserModel userModel);
  Future<GoogleUserModel> getGoogleUserModel();
  Future<void> deleteGoogleUserModel();
}

@Riverpod(keepAlive: true)
GoogleUserModelDataSource googleUserModelDataSource(GoogleUserModelDataSourceRef ref) {
  return GoogleUserModelDataSourceImpl();
}

class GoogleUserModelDataSourceImpl implements GoogleUserModelDataSource {
  GoogleUserModelDataSourceImpl();

  @override
  Future<void> saveGoogleUserModel(GoogleUserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    String userModelJson = jsonEncode(userModel.toJson());
    await prefs.setString('googleUserModel', userModelJson);
  }

  @override
  Future<GoogleUserModel> getGoogleUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final userModelJson = prefs.getString('googleUserModel');
    if (userModelJson != null) {
      Map<String, dynamic> userModelMap = jsonDecode(userModelJson);
      return GoogleUserModel.fromJson(userModelMap);
    } else {
      throw Exception('UserModel not found in SharedPreferences');
    }
  }

  @override
  Future<void> deleteGoogleUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('googleUserModel');
  }
}
