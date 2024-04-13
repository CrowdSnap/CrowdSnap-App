import 'package:crowd_snap/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

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
      print('Error: $e StackTrace: $stackTrace');
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signUpUseCaseProvider).execute(email, password);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');
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
}
