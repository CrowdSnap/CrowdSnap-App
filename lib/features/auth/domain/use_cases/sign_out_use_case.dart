import 'package:crowd_snap/core/domain/use_cases/shared_preferences/delete_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_use_case.g.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;
  final DeleteUserUseCase _deleteUserUseCase;

  SignOutUseCase(this._authRepository, this._deleteUserUseCase);

  Future<void> execute() async {
    await _authRepository.signOut();
    await _deleteUserUseCase.execute();
  }
}

@riverpod
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final deleteUserUseCase = ref.watch(deleteUserUseCaseProvider);
  return SignOutUseCase(authRepository, deleteUserUseCase);
}
