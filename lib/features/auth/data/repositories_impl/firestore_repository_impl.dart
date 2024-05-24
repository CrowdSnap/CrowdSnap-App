import 'package:crowd_snap/features/auth/data/data_sources/firestore_data_source.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'firestore_repository_impl.g.dart';

// @Riverpod(keepAlive: true) mantiene viva esta instancia a lo largo del ciclo de vida de la aplicación.
// Crea y proporciona una instancia de `FirestoreRepository` dentro del árbol de providers de Riverpod.
// Esta instancia se encarga de interactuar con la base de datos Firestore.
@Riverpod(keepAlive: true)
FirestoreRepository firestoreRepository(FirestoreRepositoryRef ref) {
  final firestoreDataSource = ref.watch(firestoreDataSourceProvider);
  return FirestoreRepositoryImpl(firestoreDataSource);
}

final _logger = Logger('FirestoreRepository');

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreDataSource _firestoreDataSource;

  FirestoreRepositoryImpl(this._firestoreDataSource);

  // Guarda un usuario en Firestore utilizando `firestoreDataSource`.
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

  // Obtiene un usuario de Firestore utilizando `firestoreDataSource`.
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

  // Actualiza un usuario en Firestore utilizando `firestoreDataSource`.
  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestoreDataSource.updateUser(user);
      _logger.info('User updated in Firestore: ${user.email}');
    } catch (e) {
      _logger.severe('Error updating user in Firestore: $e');
      throw Exception('Failed to update user in Firestore');
    }
  }

  // Actualiza la URL del avatar del usuario en Firestore utilizando `firestoreDataSource`.
  @override
  Future<void> updateUserAvatar(String avatarUrl, String blurHash) async {
    try {
      print('Avatar URL: $avatarUrl');
      await _firestoreDataSource.updateUserAvatar(avatarUrl, blurHash);
      _logger.info('User avatar updated in Firestore');
    } catch (e) {
      _logger.severe('Error updating user avatar in Firestore: $e');
      throw Exception('Failed to update user avatar in Firestore');
    }
  }

  // Elimina un usuario de Firestore utilizando `firestoreDataSource`.
  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _firestoreDataSource.deleteUser(userId);
      _logger.info('User deleted from Firestore: $userId');
    } catch (e) {
      _logger.severe('Error deleting user from Firestore: $e');
      throw Exception('Failed to delete user from Firestore');
    }
  }
}
