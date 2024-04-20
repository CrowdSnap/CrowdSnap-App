import 'package:crowd_snap/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/recover_password_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_notifier.g.dart';

final _logger = Logger('AuthNotifier');

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signInUseCaseProvider).execute(email, password);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      _logger.severe('Error: $e StackTrace: $stackTrace');
    }
  }

  Future<void> signUp(String email, String password, String username, String name) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signUpUseCaseProvider).execute(email, password, username, name);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      _logger.severe('Error: $e StackTrace: $stackTrace');
    }
  }

  Future<void> signInWithGoogle() async {
  state = const AsyncValue.loading();
  try {
    await ref.read(googleSignInUseCaseProvider).execute();
    state = const AsyncValue.data(null);
  } catch (e, stackTrace) {
    state = AsyncValue.error(e, stackTrace);
    _logger.severe('Error: $e StackTrace: $stackTrace');
  }
}

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signOutUseCaseProvider).execute();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> recoverPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(recoverPasswordUseCaseProvider).execute(email);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
