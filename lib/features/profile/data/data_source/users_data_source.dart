import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_data_source.g.dart';

abstract class UsersDataSource {
  Future<UserModel> getUser(String userId);
}

@Riverpod(keepAlive: true)
UsersDataSource usersDataSource(UsersDataSourceRef ref) {
  final firestore = FirebaseFirestore.instance;
  return UsersDataSourceImpl(firestore);
}

class UsersDataSourceImpl implements UsersDataSource {
  final FirebaseFirestore _firestore;

  UsersDataSourceImpl(this._firestore);

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        return UserModel.fromJson(userData!);
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      throw Exception('Failed to get user from Firestore');
    }
  }
}