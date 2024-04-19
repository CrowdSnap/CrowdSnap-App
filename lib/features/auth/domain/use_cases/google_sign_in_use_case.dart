import 'package:crowd_snap/features/auth/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'google_sign_in_use_case.g.dart';

class GoogleSignInUseCase {
  final AuthRepository _authRepository;

  GoogleSignInUseCase(this._authRepository);

  Future<UserModel> execute() {
    return _authRepository.signInWithGoogle();
  }
}

final _logger = Logger('GoogleSignInUseCase');

@riverpod
GoogleSignInUseCase googleSignInUseCase(GoogleSignInUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  _logger.info('GoogleSignInUseCase');
  return GoogleSignInUseCase(authRepository);
}