import 'package:crowd_snap/core/data/models/google_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_data_source.g.dart';

abstract class GoogleAuthDataSource {
  Future<GoogleUserModel> signInWithGoogle();
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
  Future<GoogleUserModel> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    
    if (user != null) {
      return GoogleUserModel(
        userId: user.uid,
        email: user.email,
        name: user.displayName,
        avatarUrl: user.photoURL,
        joinedAt: DateTime.now(),
      );
    } else {
      throw Exception('User not found');
    }
  }
}
