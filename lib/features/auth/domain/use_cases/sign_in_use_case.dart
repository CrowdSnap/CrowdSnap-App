import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/post_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/post_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_in_use_case.g.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final StoreUserUseCase _storeUserUseCase;
  final AvatarGetUseCase _avatarGetUseCase;
  final ProfileNotifier _profileNotifier;
  final GetUserUseCase _getUserUseCase;
  final PostRepository _postRepository;

  SignInUseCase(this._authRepository, this._storeUserUseCase,
      this._avatarGetUseCase, this._profileNotifier, this._getUserUseCase, this._postRepository);

  Future<void> execute(String email, String password) async {
    try {
      final userModel =
          await _authRepository.signInWithEmailAndPassword(email, password);
      final avatarUrl = userModel.avatarUrl;
      await _storeUserUseCase.execute(userModel);
      await _avatarGetUseCase.execute(avatarUrl!);

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

        _postRepository.getPostsByUser(user.userId).then((posts) {
              _profileNotifier.updatePosts(posts);
            });
      });
    } catch (e) {
      _logger.severe('Error al iniciar sesión: $e');
      throw Exception('Error al iniciar sesión $e');
    }
  }
}

final _logger = Logger('SignInUseCase');

@riverpod
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storeUserUseCase = ref.watch(storeUserUseCaseProvider);
  final avatarGetUseCase = ref.watch(avatarGetUseCaseProvider);
  final profileNotifier = ref.read(profileNotifierProvider.notifier);
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  final postRepository = ref.read(postRepositoryProvider);
  _logger.info('SignInUseCase');
  return SignInUseCase(authRepository, storeUserUseCase, avatarGetUseCase,
      profileNotifier, getUserUseCase, postRepository);
}
