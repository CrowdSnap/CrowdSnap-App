import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_data_source.g.dart';

abstract class GoogleAuthDataSource {
  Future<UserModel> signInWithGoogle();
}

@Riverpod(keepAlive: true)
GoogleAuthDataSource googleAuthDataSource(GoogleAuthDataSourceRef ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  return GoogleAuthDataSourceImpl(firebaseAuth, googleSignIn);
}

class GoogleAuthDataSourceImpl implements GoogleAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  @override
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final existingUser = await _getUserFromFirestore(user.uid);

      if (existingUser != null) {
        // User already exists, return the existing user
        final updatedUserModel = existingUser.copyWith(firstTime: false);
        await _saveUserToFirestore(updatedUserModel);
        return updatedUserModel;
      } else {
        final userModel = UserModel(
          userId: user.uid,
          username: user.displayName ?? '',
          name: user.displayName ?? '',
          email: user.email ?? '',
          firstTime: true,
          joinedAt: user.metadata.creationTime ?? DateTime.now(),
        );

        await _saveUserToFirestore(userModel);
        return userModel;
      }
    } else {
      throw Exception('Google sign-in failed');
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.userId);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set(user.toJson());
    }
  }

  Future<UserModel?> _getUserFromFirestore(String userId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      return UserModel.fromJson(userSnapshot.data()!);
    }

    return null;
  }
}
