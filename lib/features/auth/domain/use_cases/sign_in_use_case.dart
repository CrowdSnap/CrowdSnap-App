import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_in_use_case.g.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final StoreUserUseCase _storeUserUseCase;
  final AvatarGetUseCase _avatarGetUseCase;

  SignInUseCase(this._authRepository, this._storeUserUseCase, this._avatarGetUseCase);

  Future<void> execute(String email, String password) async {
    try {
      final userModel =
          await _authRepository.signInWithEmailAndPassword(email, password);
      await _storeUserUseCase.execute(userModel);
      await _avatarGetUseCase.execute();
    } catch (e) {
      _logger.severe('Error al iniciar sesión: $e');
      throw Exception('Error al iniciar sesión');
    }
  }
}

final _logger = Logger('SignInUseCase');

@riverpod
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storeUserUseCase = ref.watch(storeUserUseCaseProvider);
  final avatarGetUseCase = ref.watch(avatarGetUseCaseProvider);
  _logger.info('SignInUseCase');
  return SignInUseCase(authRepository, storeUserUseCase, avatarGetUseCase);
}
