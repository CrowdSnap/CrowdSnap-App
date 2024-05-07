import 'package:crowd_snap/core/data/models/user_model.dart';

// Interfaz base que define los métodos para interactuar con los datos de usuario en Firestore.
abstract class FirestoreRepository {
  /// Guarda un usuario en la base de datos Firestore.
  ///
  /// Devuelve un `Future<void>` que se completa cuando el usuario se guarda correctamente en Firestore.
  /// Lanza una excepción si ocurre algún error durante el proceso de guardado.
  Future<void> saveUser(UserModel user);

  /// Obtiene un usuario de la base de datos Firestore.
  ///
  /// Devuelve un `Future<UserModel>` que se resuelve a un objeto `UserModel` si el usuario se encuentra.
  /// Lanza una excepción si ocurre algún error durante la recuperación del usuario.
  Future<UserModel> getUser(String userId);

  /// Actualiza los datos de un usuario existente en Firestore.
  ///
  /// Devuelve un `Future<void>` que se completa cuando el usuario se actualiza correctamente en Firestore.
  /// Lanza una excepción si ocurre algún error durante el proceso de actualización.
  Future<void> updateUser(UserModel user);

  /// Actualiza la URL del avatar del usuario en Firestore.
  ///
  /// Devuelve un `Future<void>` que se completa cuando la URL del avatar se actualiza correctamente.
  /// Lanza una excepción si ocurre algún error durante la actualización del avatar.
  Future<void> updateUserAvatar(String avatarUrl);

  /// Elimina un usuario de la base de datos Firestore.
  ///
  /// Devuelve un `Future<void>` que se completa cuando el usuario se elimina correctamente.
  /// Lanza una excepción si ocurre algún error durante el proceso de eliminación.
  Future<void> deleteUser(String userId);
}
