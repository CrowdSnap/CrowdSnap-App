import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/google_user_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/google_user_repository.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'google_sign_in_use_case.g.dart';

class GoogleSignInUseCase {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final StoreUserUseCase _storeUserUseCase;
  final AvatarGetUseCase _avatarGetUseCase;
  final GoogleUserRepository _googleUserRepository;

  GoogleSignInUseCase(
      this._authRepository,
      this._firestoreRepository,
      this._storeUserUseCase,
      this._avatarGetUseCase,
      this._googleUserRepository);

  Future<bool> execute() async {
    final googleUserModel = await _authRepository.signInWithGoogle();

    try {
      final UserModel userModel =
          await _firestoreRepository.getUser(googleUserModel.userId);
      await _storeUserUseCase.execute(userModel);
      try {
        await _avatarGetUseCase.execute(userModel.avatarUrl!);
      } on Exception catch (e) {
        print('Avatar extraido de Firestore: $e');
      }
      return true;
    } catch (e) {
      print('Usuario no existe en firestore: $e');
      await _googleUserRepository.saveGoogleUser(googleUserModel);
      print('GoogleUser guardado en SharedPreferences: $googleUserModel');
      return false;
    }
  }
}

final _logger = Logger('GoogleSignInUseCase');

@riverpod
GoogleSignInUseCase googleSignInUseCase(GoogleSignInUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  final storeUserUseCase = ref.watch(storeUserUseCaseProvider);
  final avatarGetUseCase = ref.watch(avatarGetUseCaseProvider);
  final googleUserRepository = ref.watch(googleUserRepositoryProvider);
  _logger.info('GoogleSignInUseCase');
  return GoogleSignInUseCase(authRepository, firestoreRepository,
      storeUserUseCase, avatarGetUseCase, googleUserRepository);
}
