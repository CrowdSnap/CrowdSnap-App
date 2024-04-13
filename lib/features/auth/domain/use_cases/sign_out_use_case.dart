import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_use_case.g.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> execute() {
    return _authRepository.signOut();
  }
}

@riverpod
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(authRepository);
}
