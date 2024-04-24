import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'firestore_data_source.g.dart';

abstract class FirestoreDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<void> updateUserAvatar(String avatarUrl);
}

final _logger = Logger('FirestoreDataSource');

@Riverpod(keepAlive: true)
FirestoreDataSource firestoreDataSource(FirestoreDataSourceRef ref) {
  final firestore = FirebaseFirestore.instance;
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  return FirestoreDataSourceImpl(firestore, getUserUseCase);
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final GetUserUseCase _getUserUseCase;

  FirestoreDataSourceImpl(this._firestore, this._getUserUseCase);

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.userId);
      await userDoc.set(user.toJson());
      _logger.info('User saved to Firestore: ${user.email}');
    } catch (e) {
      _logger.severe('Error saving user to Firestore: $e');
      throw Exception('Failed to save user to Firestore');
    }
  }

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
      _logger.severe('Error getting user from Firestore: $e');
      throw Exception('Failed to get user from Firestore');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.userId);
      await userDoc.update(user.toJson());
      _logger.info('User updated in Firestore: ${user.email}');
    } catch (e) {
      _logger.severe('Error updating user in Firestore: $e');
      throw Exception('Failed to update user in Firestore');
    }
  }

  @override
  Future<void> updateUserAvatar(String avatarUrl) async {
    final userModel = await _getUserUseCase.execute();
    final userId = userModel.userId;
    try {
      final userDoc = _firestore.collection('users').doc(userId);
      print('User ID: $userId');
      print('Avatar URL: $avatarUrl');
      print('User Doc: $userDoc');
      await userDoc.update({'avatarUrl': avatarUrl});
      _logger.info('User avatar updated in Firestore: $avatarUrl');
    } catch (e) {
      _logger.severe('Error updating user avatar in Firestore: $e');
      throw Exception('Failed to update user avatar in Firestore');
    }
  }
}
