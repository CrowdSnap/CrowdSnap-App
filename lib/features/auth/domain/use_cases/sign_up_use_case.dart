import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/entities/user.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_up_use_case.g.dart';

class SignUpUseCase {
	final AuthRepository _authRepository;

	SignUpUseCase(this._authRepository);

	Future<User> execute(String email, String password) {
		return _authRepository.createUserWithEmailAndPassword(email, password);
	}
}

final _logger = Logger('SignUpUseCase');

@riverpod
SignUpUseCase signUpUseCase(SignUpUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  _logger.info('SignUpUseCase');
  return SignUpUseCase(authRepository);
}