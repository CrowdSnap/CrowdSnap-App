import 'package:crowd_snap/features/auth/data/data_sources/firestore_data_source.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_data_source.g.dart';

// Una clase abstracta que define el contrato para las fuentes de datos de autenticación.
abstract class AuthDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(String email,
      String password, String username, String name, DateTime birthDate);
  Future<void> signOut();
  bool isAuthenticated();
  Future<void> recoverPassword(String email);
}

final _logger = Logger('AuthDataSource');

// Provee una instancia de [AuthDataSource] utilizando Riverpod.
// La instancia se mantiene viva incluso si no hay consumidores.
@Riverpod(keepAlive: true)
AuthDataSource authDataSource(AuthDataSourceRef ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDataSource = ref.watch(firestoreDataSourceProvider);
  return AuthDataSourceImpl(firebaseAuth, firestoreDataSource);
}

// Implementación concreta de [AuthDataSource] que utiliza Firebase Authentication y Firestore.
class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirestoreDataSource _firestoreDataSource;

  AuthDataSourceImpl(this._firebaseAuth, this._firestoreDataSource);

  // Inicia sesión con correo electrónico y contraseña.
  // Devuelve un modelo de usuario si la autenticación es exitosa.
  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    print(user);
    if (user != null) {
      print('User: ${user.email} Firebase User signed in');
      final userModel = await _firestoreDataSource.getUser(user.uid);
      print(userModel);
      // Verificar el valor de firstTime y actualizarlo si es necesario
      if (userModel.firstTime) {
        final updatedUserModel = userModel.copyWith(firstTime: false);
        await _firestoreDataSource.updateUser(updatedUserModel);
        print('User updated: $updatedUserModel');
        return updatedUserModel;
      } else {
        return userModel;
      }
    } else {
      throw Exception('User not found');
    }
  }

  // Crea un nuevo usuario con correo electrónico, contraseña, nombre de usuario, nombre y fecha de nacimiento.
  // Devuelve un modelo de usuario si la creación de usuario es exitosa.
  @override
  Future<UserModel> createUserWithEmailAndPassword(String email,
      String password, String username, String name, DateTime birthDate) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      _logger.info('User: ${user.email} Firebase User created');
      final userModel = UserModel(
        userId: user.uid,
        name: name,
        username: username,
        email: user.email!,
        birthDate: birthDate,
        firstTime: true,
        joinedAt: DateTime.now(),
        connectionsCount: '0',
      );
      return userModel;
    } else {
      throw Exception('User creation failed');
    }
  }

  // Cierra la sesión del usuario actual.
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Verifica si hay un usuario autenticado actualmente.
  // Devuelve true si hay un usuario autenticado, false de lo contrario.
  @override
  bool isAuthenticated() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  // Envía un correo electrónico para recuperar la contraseña del usuario.
  @override
  Future<void> recoverPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
