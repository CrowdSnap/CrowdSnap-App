import 'package:crowd_snap/core/provider/page_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_redirect_provider.g.dart';

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

final _logger = Logger('AuthRedirect');

@riverpod
void authRedirect(AuthRedirectRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  final router = ref.watch(appRouterProvider);
  final pageAuth = ref.watch(pageAuthProvider);

  authState.when(
    data: (user) {
      if (user != null) {
        if (pageAuth) {
          router.go('/avatar-upload');
        } else{
          router.go('/');
        }
        _logger.info('Authenticated, redirecting to home');
      } else {
        router.go('/login');
        _logger.info('Not authenticated, redirecting to login');
      }
    },
    error: (error, stackTrace) {
      _logger.severe('Error occurred: $error');
    },
    loading: () {
      _logger.info('Loading authentication state...');
    },
  );
}