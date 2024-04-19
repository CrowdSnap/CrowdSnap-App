import 'package:crowd_snap/features/auth/data/data_sources/firestore_data_source.dart';
import 'package:crowd_snap/features/auth/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'firestore_repository_impl.g.dart';

@Riverpod(keepAlive: true)
FirestoreRepository firestoreRepository(FirestoreRepositoryRef ref) {
  final firestoreDataSource = ref.watch(firestoreDataSourceProvider);
  return FirestoreRepositoryImpl(firestoreDataSource);
}

final _logger = Logger('FirestoreRepository');

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreDataSource _firestoreDataSource;

  FirestoreRepositoryImpl(this._firestoreDataSource);

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestoreDataSource.saveUser(user);
      _logger.info('User saved to Firestore: ${user.email}');
    } catch (e) {
      _logger.severe('Error saving user to Firestore: $e');
      throw Exception('Failed to save user to Firestore');
    }
  }

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final userModel = await _firestoreDataSource.getUser(userId);
      _logger.info('User retrieved from Firestore: ${userModel.email}');
      return userModel;
    } catch (e) {
      _logger.severe('Error getting user from Firestore: $e');
      throw Exception('Failed to get user from Firestore');
    }
  }
}
