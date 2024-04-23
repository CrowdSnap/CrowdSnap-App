import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
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
Future<void> authRedirect(AuthRedirectRef ref) async {
  final authState = ref.watch(authStateChangesProvider);
  final router = ref.watch(appRouterProvider);
  final firestoreRepository = ref.read(firestoreRepositoryProvider);

  authState.whenData((user) async {
    if (user != null) {
      final userModel = await firestoreRepository.getUser(user.uid);
      if (userModel.firstTime) {
        // El usuario acaba de crear una cuenta nueva, redirigir a subir avatar
        router.go('/avatar-upload');
        print('New user, redirecting to avatar upload');
      } else {
        // El usuario ha iniciado sesión con una cuenta existente, redirigir al home
        router.go('/');
        print('Existing user, redirecting to home');
      }
    } else {
      router.go('/login');
      print('Not authenticated, redirecting to login');
    }
  });
}
