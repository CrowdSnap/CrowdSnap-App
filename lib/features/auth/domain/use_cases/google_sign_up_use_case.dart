import 'dart:io';

import 'package:crowd_snap/features/profile/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/data/repositories/google_user_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/google_user_repository.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_upload_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'google_sign_up_use_case.g.dart';

class GoogleSignUpUseCase {
  final FirestoreRepository _firestoreRepository;
  final StoreUserUseCase _storeUserUseCase;
  final AvatarUploadUseCase _avatarUploadUseCase;
  final GoogleUserRepository _googleUserRepository;
  final ProfileNotifier _profileNotifier;
  final GetUserLocalUseCase _getUserUseCase;
  final AvatarGetUseCase _avatarGetUseCase;

  GoogleSignUpUseCase(
      this._firestoreRepository,
      this._storeUserUseCase,
      this._avatarUploadUseCase,
      this._googleUserRepository,
      this._profileNotifier,
      this._getUserUseCase,
      this._avatarGetUseCase);

  Future<void> execute(String name, String userName, DateTime birthDate,
      String userImage) async {
    try {
      final googleUser = await _googleUserRepository.getGoogleUser();
      final String userAvatar;
      final String blurHash;
      if (userImage.isEmpty) {
        final avatar = googleUser.avatarUrl;
        final dio = Dio();
        final directory = await getApplicationDocumentsDirectory();
        final avatarFile = File('${directory.path}/$avatar');
        await dio.download(avatar!, avatarFile.path);
        (userAvatar, blurHash) = await _avatarUploadUseCase.execute(avatarFile,
            userName: userName, googleAvatar: true);
      } else {
        (userAvatar, blurHash) = await _avatarUploadUseCase.execute(File(userImage),
            userName: userName);
      }
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      final fcmToken = await messaging.getToken();
      UserModel user = UserModel(
        userId: googleUser.userId,
        username: userName,
        name: name,
        email: googleUser.email!,
        birthDate: birthDate,
        joinedAt: DateTime.now(),
        firstTime: true,
        fcmToken: fcmToken,
        avatarUrl: userAvatar,
        blurHashImage: blurHash,
        connectionsCount: 0,
      );
      await _storeUserUseCase.execute(user);
      await _firestoreRepository.saveUser(user);
      _getUserUseCase.execute().then((user) {
        _profileNotifier.updateUserId(user.userId);
        _profileNotifier.updateName(user.name);
        _profileNotifier.updateEmail(user.email);
        _profileNotifier.updateUserName(user.username);
        _profileNotifier.updateAge(user.birthDate);

        _avatarGetUseCase.execute(user.username).then((avatar) {
          _profileNotifier.updateImage(avatar);
        });
      });
    } on Exception {
      rethrow;
    }
  }
}

final _logger = Logger('GoogleSignInUseCase');

@riverpod
GoogleSignUpUseCase googleSignUpUseCase(GoogleSignUpUseCaseRef ref) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  final storeUserUseCase = ref.watch(storeUserUseCaseProvider);
  final avatarUpLoadUseCase = ref.watch(avatarUploadUseCaseProvider);
  final googleUserRepository = ref.watch(googleUserRepositoryProvider);
  final profileNotifier = ref.read(profileNotifierProvider.notifier);
  final getUserUseCase = ref.read(getUserLocalUseCaseProvider);
  final avatarGetUseCase = ref.watch(avatarGetUseCaseProvider);

  _logger.info('GoogleSignUpUseCase');
  return GoogleSignUpUseCase(
      firestoreRepository,
      storeUserUseCase,
      avatarUpLoadUseCase,
      googleUserRepository,
      profileNotifier,
      getUserUseCase,
      avatarGetUseCase);
}
