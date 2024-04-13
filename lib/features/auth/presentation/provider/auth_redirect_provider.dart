import 'package:firebase_auth/firebase_auth.dart';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_redirect_provider.g.dart';

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
void authRedirect(AuthRedirectRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  final router = ref.watch(appRouterProvider);

  authState.when(
    data: (user) {
      if (user != null) {
        router.go('/');
        print('Authenticated, redirecting to home');
      } else {
        router.go('/login');
        print('Not authenticated, redirecting to login');
      }
    },
    error: (error, stackTrace) {
      print('Error occurred: $error');
    },
    loading: () {
      print('Loading authentication state...');
    },
  );
}
