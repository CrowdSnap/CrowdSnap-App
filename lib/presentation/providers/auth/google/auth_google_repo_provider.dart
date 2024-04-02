import 'package:crowd_snap/data/auth/google_auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_google_repo_provider.g.dart';


@riverpod
Future<UserCredential> authGoogle(AuthGoogleRef ref) async {
  return signInWithGoogle();
}