import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/avatar_local_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/avatar_local_repository.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/delete_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_use_case.g.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;
  final DeleteUserUseCase _deleteUserUseCase;
  final AvatarLocalRepository _avatarLocalRepository;
  final AuthState _authStateNotifier;

  SignOutUseCase(this._authRepository, this._deleteUserUseCase,
      this._avatarLocalRepository, this._authStateNotifier);

  Future<void> execute() async {
    _authStateNotifier.loggedOut();
    await _authRepository.signOut();
    await _avatarLocalRepository.deleteAvatar();
    await _deleteUserUseCase.execute();
  }
}

@riverpod
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final deleteUserUseCase = ref.watch(deleteUserUseCaseProvider);
  final deleteDeleteAvatarLocal = ref.watch(avatarLocalRepositoryProvider);
  final authState = ref.watch(authStateProvider.notifier);
  return SignOutUseCase(
      authRepository, deleteUserUseCase, deleteDeleteAvatarLocal, authState);
}
