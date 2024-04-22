import 'package:crowd_snap/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String username, String name, int age);
  // Google Sign In
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  bool isAuthenticated();
  // Password Recovery
  Future<void> recoverPassword(String email);
}