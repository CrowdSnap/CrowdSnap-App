import 'package:crowd_snap/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/google_sign_up_use_case.dart';
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
  googleSignUp
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<SignUpResult> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signInUseCaseProvider).execute(email, password);
      state = const AsyncValue.data(null);
      return SignUpResult.emailAlreadyInUse;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');
      return SignUpResult.error;
    }
  }

  Future<SignUpResult> signUp(String email, String password, String username,
      String name, DateTime birthDate) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(signUpUseCaseProvider)
          .execute(email, password, username, name, birthDate);
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

  Future<SignUpResult> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final registered = await ref.read(googleSignInUseCaseProvider).execute();
      if (!registered) {
      state = const AsyncValue.data(null);
      return SignUpResult.googleSignUp;
    }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return SignUpResult.error;
    }
    return SignUpResult.success;
  }

  Future<SignUpResult> signUpWithGoogle(
      String name, String userName, DateTime birthDate, String userImage) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(googleSignUpUseCaseProvider)
          .execute(name, userName, birthDate, userImage);
      state = const AsyncValue.data(null);
      print('SignUpWithGoogle: Success');
      return SignUpResult.success;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');
      return SignUpResult.error;
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
