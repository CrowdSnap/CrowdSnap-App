import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_up_use_case.g.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final StoreUserUseCase _storeUserUseCase;
  final ProfileNotifier _profileNotifier;
  final GetUserUseCase _getUserUseCase;
  final AvatarGetUseCase _avatarGetUseCase;

  SignUpUseCase(this._authRepository, this._firestoreRepository,
      this._storeUserUseCase, this._profileNotifier, this._getUserUseCase, this._avatarGetUseCase);

  Future<void> execute(String email, String password, String username,
      String name, DateTime birthDate) async {
    final userModel = await _authRepository.createUserWithEmailAndPassword(
        email, password, username, name, birthDate);
    await _storeUserUseCase.execute(userModel);
    await _firestoreRepository.saveUser(userModel);

    _getUserUseCase.execute().then((user) {
        _profileNotifier.updateUserId(user.userId);
        _profileNotifier.updateName(user.name);
        _profileNotifier.updateEmail(user.email);
        _profileNotifier.updateUserName(user.username);
        _profileNotifier.updateAge(user.birthDate);

        _avatarGetUseCase.execute(user.username).then((avatar) {
          _profileNotifier.updateImage(
              avatar); // Actualiza el estado del perfil con el avatar.
        });
      });
  }
}

final _logger = Logger('SignUpUseCase');

@riverpod
SignUpUseCase signUpUseCase(SignUpUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  final storeUserUseCase = ref.watch(storeUserUseCaseProvider);
  final profileNotifier = ref.read(profileNotifierProvider.notifier);
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  final getAvatarUseCase = ref.read(avatarGetUseCaseProvider);
  _logger.info('SignUpUseCase');
  return SignUpUseCase(
      authRepository, firestoreRepository, storeUserUseCase, profileNotifier, getUserUseCase, getAvatarUseCase);
}
