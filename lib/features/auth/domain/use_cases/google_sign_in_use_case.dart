import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/google_user_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/google_user_repository.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'google_sign_in_use_case.g.dart';

class GoogleSignInUseCase {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final StoreUserUseCase _storeUserUseCase;
  final AvatarGetUseCase _avatarGetUseCase;
  final GoogleUserRepository _googleUserRepository;
  final ProfileNotifier _profileNotifier;
  final GetUserLocalUseCase _getUserUseCase;
  final PostRepository _postRepository;

  GoogleSignInUseCase(
      this._authRepository,
      this._firestoreRepository,
      this._storeUserUseCase,
      this._avatarGetUseCase,
      this._googleUserRepository,
      this._profileNotifier,
      this._getUserUseCase,
      this._postRepository);

  Future<bool> execute() async {
    final googleUserModel = await _authRepository.signInWithGoogle();

    try {
      final UserModel userModel =
          await _firestoreRepository.getUser(googleUserModel.userId);
      if (userModel.firstTime) {
        final updatedUserModel = userModel.copyWith(firstTime: false);
        await _firestoreRepository.saveUser(updatedUserModel);
        print('User updated false fistTime: $updatedUserModel');
      }
      await _storeUserUseCase.execute(userModel);
      try {
        await _avatarGetUseCase.execute(userModel.avatarUrl!);
      } on Exception catch (e) {
        print('Avatar extraido de Firestore: $e');
      }

      // Añade este código dentro de la función execute
      _getUserUseCase.execute().then((user) {
        _profileNotifier.updateUserId(user.userId);
        _profileNotifier.updateName(user.name);
        _profileNotifier.updateEmail(user.email);
        _profileNotifier.updateUserName(user.username);
        _profileNotifier.updateAge(user.birthDate);

        _avatarGetUseCase.execute(user.username).then((avatar) {
          _profileNotifier.updateImage(avatar);
        });

        _postRepository.getPostsByUser(user.userId).then((posts) {
              _profileNotifier.updatePosts(posts);
            });
      });

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
  final profileNotifier = ref.read(profileNotifierProvider.notifier);
  final getUserUseCase = ref.read(getUserLocalUseCaseProvider);
  final postRepository = ref.read(postRepositoryProvider);
  _logger.info('GoogleSignInUseCase');
  return GoogleSignInUseCase(
      authRepository,
      firestoreRepository,
      storeUserUseCase,
      avatarGetUseCase,
      googleUserRepository,
      profileNotifier,
      getUserUseCase,
      postRepository);
}
