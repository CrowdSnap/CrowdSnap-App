import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/features/auth/data/data_sources/firestore_data_source.dart';
import 'package:crowd_snap/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_data_source.g.dart';

abstract class AuthDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String username, String name, int age);
  Future<void> signOut();
  bool isAuthenticated();
  Future<void> recoverPassword(String email);
}

final _logger = Logger('AuthDataSource');

@Riverpod(keepAlive: true)
AuthDataSource authDataSource(AuthDataSourceRef ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDataSource = ref.watch(firestoreDataSourceProvider);
  return AuthDataSourceImpl(firebaseAuth, firestoreDataSource);
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirestoreDataSource _firestoreDataSource;

  AuthDataSourceImpl(this._firebaseAuth, this._firestoreDataSource);

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      _logger.info('User: ${user.email} Firebase User signed in');
      final userModel = await _firestoreDataSource.getUser(user.uid);
      return userModel;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String username, String name, int age) async {
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
        age: age,
        joinedAt: DateTime.now(),
      );
      await _saveUserToFirestore(userModel);
      return userModel;
    } else {
      throw Exception('User creation failed');
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.userId);
    await userDoc.set(user.toJson());
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  bool isAuthenticated() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  @override
  Future<void> recoverPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
