import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'firestore_data_source.g.dart';

// Clase abstracta que define una interfaz para interactuar con Firestore para la gestión de usuarios.
abstract class FirestoreDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<void> updateUserAvatar(String avatarUrl, String blurHash);
  Future<void> deleteUser(String userId);
  Future<bool> userNamesExists(String userName);
}

final _logger = Logger('FirestoreDataSource');
// Función provider que crea y proporciona una instancia de FirestoreDataSource.
@Riverpod(keepAlive: true)
FirestoreDataSource firestoreDataSource(FirestoreDataSourceRef ref) {
  final firestore = FirebaseFirestore.instance;
  final getUserUseCase = ref.read(getUserLocalUseCaseProvider);
  return FirestoreDataSourceImpl(firestore, getUserUseCase);
}

// Implementación concreta de FirestoreDataSource que utiliza Firestore.
class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;
  final GetUserLocalUseCase _getUserUseCase;

  FirestoreDataSourceImpl(this._firestore, this._getUserUseCase);

  // Implementación del método `saveUser` de FirestoreDataSource.
  // Guarda un nuevo objeto de usuario (`user`) en Firestore.
  // Devuelve un `Future<void>` que indica la finalización asincrónica.
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

  // Implementación del método `getUser` de FirestoreDataSource.
  // Recupera un objeto de usuario de Firestore basado en el `userId` proporcionado.
  // Devuelve un `Future<UserModel>` que se resuelve al objeto de usuario recuperado o a un error.
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

  // Implementación del método `updateUser` de FirestoreDataSource.
  // Actualiza un objeto de usuario existente (`user`) en Firestore.
  // Devuelve un `Future<void>` que indica la finalización asincrónica.
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

  // Implementación del método `updateUserAvatar` de FirestoreDataSource.
  // Actualiza solo la URL del avatar del usuario actual en Firestore.
  // Devuelve un `Future<void>` que indica la finalización asincrónica.
  @override
  Future<void> updateUserAvatar(String avatarUrl, String blurHash) async {
    final userModel = await _getUserUseCase.execute();
    final userId = userModel.userId;
    try {
      final userDoc = _firestore.collection('users').doc(userId);
      await userDoc.update({'avatarUrl': avatarUrl, 'blurHashImage': blurHash});
      _logger.info('User avatar updated in Firestore: $avatarUrl');
    } catch (e) {
      _logger.severe('Error updating user avatar in Firestore: $e');
      throw Exception('Failed to update user avatar in Firestore');
    }
  }

  // Implementación del método `deleteUser` de FirestoreDataSource.
  // Elimina el usuario identificado por el `userId` proporcionado de Firestore.
  // Devuelve un `Future<void>` que indica la finalización asincrónica.
  @override
  Future<void> deleteUser(String userId) async {
    try {
      final userDoc = _firestore.collection('users').doc(userId);
      await userDoc.delete();
      _logger.info('User deleted from Firestore: $userId');
    } catch (e) {
      _logger.severe('Error deleting user from Firestore: $e');
      throw Exception('Failed to delete user from Firestore');
    }
  }

  // Implementación del método `userNamesExists` de FirestoreDataSource.
  // Comprueba si el nombre de usuario (`userName`) proporcionado ya existe en Firestore.
  // Devuelve un `Future<bool>` que indica si el nombre de usuario ya existe o no.
  // Devuelve `true` si el nombre de usuario ya existe, `false` si no existe.
  @override
  Future<bool> userNamesExists(String userName) async {
    try {
      final userQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: userName)
          .get();
      return userQuery.docs.isNotEmpty;
    } catch (e) {
      _logger.severe('Error checking user name in Firestore: $e');
      throw Exception('Failed to check user name in Firestore');
    }
  }
}
