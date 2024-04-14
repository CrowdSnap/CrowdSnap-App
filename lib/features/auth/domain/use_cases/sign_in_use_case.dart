import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/entities/user.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_in_use_case.g.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<User> execute(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }
}

final _logger = Logger('SignInUseCase');

@riverpod
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  _logger.info('SignInUseCase');
  return SignInUseCase(authRepository);
}
