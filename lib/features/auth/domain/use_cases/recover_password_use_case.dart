import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recover_password_use_case.g.dart';

class RecoverPasswordUseCase {
  final AuthRepository _authRepository;

  RecoverPasswordUseCase(this._authRepository);

  Future<void> execute(String email) {
    return _authRepository.recoverPassword(email);
  }
}

@riverpod
RecoverPasswordUseCase recoverPasswordUseCase(RecoverPasswordUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RecoverPasswordUseCase(authRepository);
}