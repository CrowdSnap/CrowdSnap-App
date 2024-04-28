import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/app/router/redirect/shared_preferences/store_auth_state.dart';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_redirect_provider.g.dart';

final _logger = Logger('AuthRedirect');

@riverpod
void authRedirect(AuthRedirectRef ref) {
  final authStatus = ref.watch(authStateProvider);
  final router = ref.watch(appRouterProvider);

  authStatus.when(
    data: (status) {
      switch (status) {
        case AuthStatus.loggedOut:
          router.go('/login');
          break;
        case AuthStatus.avatarUpload:
          router.go('/avatar-upload');
          break;
        case AuthStatus.loggedIn:
          router.go('/');
          break;
        case AuthStatus.googleSignUp:
          router.go('/google-sign-up');
          break;
      }
    },
    loading: () {
      // Handle loading state if needed
    },
    error: (error, stackTrace) {
      // Handle error state if needed
    },
  );
}
