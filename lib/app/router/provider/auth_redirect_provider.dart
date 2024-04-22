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

  authState.when(
    data: (user) {
      if (user != null) {
        final metadata = user.metadata;
        if (metadata.creationTime == metadata.lastSignInTime) {
          // El usuario acaba de crear una cuenta nueva, redirigir a subir avatar
          router.go('/avatar-upload');
          _logger.info('New user, redirecting to avatar upload');
          print('New user, redirecting to avatar upload');
        } else {
          // El usuario ha iniciado sesión con una cuenta existente, redirigir al home
          router.go('/');
          _logger.info('Existing user, redirecting to home');
        }
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
