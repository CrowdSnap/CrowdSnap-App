import 'package:crowd_snap/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  // Google Sign In
  Future<User> signInWithGoogle();
  Future<void> signOut();
  bool isAuthenticated();
}