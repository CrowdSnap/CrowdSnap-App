import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_in_use_case.g.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final StoreUserUseCase _storeUserUseCase;
  final AvatarBucketRepository _avatarBucketRepository;

  SignInUseCase(this._authRepository, this._firestoreRepository, this._storeUserUseCase, this._avatarBucketRepository);

  Future<void> execute(String email, String password) async {
    try {
      final user =
          await _authRepository.signInWithEmailAndPassword(email, password);
      final userModel = await _firestoreRepository.getUser(user.userId);
      await _storeUserUseCase.execute(userModel);
      await _avatarBucketRepository.getUserAvatar();
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
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  final storeUserUseCase = ref.watch(storeUserUseCaseProvider);
  final avatarBucketRepository = ref.watch(avatarBucketRepositoryProvider);
  _logger.info('SignInUseCase');
  return SignInUseCase(authRepository, firestoreRepository, storeUserUseCase, avatarBucketRepository);
}
