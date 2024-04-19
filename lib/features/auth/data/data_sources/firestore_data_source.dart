import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/features/auth/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'firestore_data_source.g.dart';

abstract class FirestoreDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser(String userId);
}

final _logger = Logger('FirestoreDataSource');

@Riverpod(keepAlive: true)
FirestoreDataSource firestoreDataSource(FirestoreDataSourceRef ref) {
  final firestore = FirebaseFirestore.instance;
  return FirestoreDataSourceImpl(firestore);
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSourceImpl(this._firestore);

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
}
