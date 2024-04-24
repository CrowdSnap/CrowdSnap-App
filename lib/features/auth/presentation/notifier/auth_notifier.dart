import 'package:crowd_snap/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/recover_password_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_notifier.g.dart';

final _logger = Logger('AuthNotifier');

enum SignUpResult {
  success,
  emailAlreadyInUse,
  accountExistsWithGoogle,
  error,
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signInUseCaseProvider).execute(email, password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');
      return false;
    }
  }

  Future<SignUpResult> signUp(
      String email, String password, String username, String name, int age) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(signUpUseCaseProvider)
          .execute(email, password, username, name, age);
      state = const AsyncValue.data(null);
      return SignUpResult.success;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // El correo ya está registrado
          return SignUpResult.emailAlreadyInUse;
        } else if (e.code == 'account-exists-with-different-credential') {
          // La cuenta ya está registrada con Google
          return SignUpResult.accountExistsWithGoogle;
        }
      }

      // Otro error ocurrió
      return SignUpResult.error;
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
