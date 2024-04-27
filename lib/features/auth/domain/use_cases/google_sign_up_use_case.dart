import 'dart:io';

import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/google_user_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/google_user_repository.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_upload_use_case.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'google_sign_up_use_case.g.dart';

class GoogleSignUpUseCase {
  final FirestoreRepository _firestoreRepository;
  final StoreUserUseCase _storeUserUseCase;
  final AvatarUploadUseCase _avatarUploadUseCase;
  final GoogleUserRepository _googleUserRepository;

  GoogleSignUpUseCase(this._firestoreRepository, this._storeUserUseCase,
      this._avatarUploadUseCase, this._googleUserRepository);

  Future<void> execute(
      String name, String userName, DateTime birthDate, String userImage) async {
    try {
      final googleUser = await _googleUserRepository.getGoogleUser();
      final String userAvatar;
      if (userImage.isEmpty) {
        print('Downloading google avatar ${googleUser.avatarUrl}');
        final avatar = googleUser.avatarUrl;
        final dio = Dio();
        final directory = await getApplicationDocumentsDirectory();
        final avatarFile = File('${directory.path}/$avatar');
        await dio.download(avatar!, avatarFile.path);
        userAvatar = await _avatarUploadUseCase.execute(avatarFile, userName: userName);
      } else {
        print('Uploading user selected avatar $userImage');
        userAvatar = await _avatarUploadUseCase.execute(File(userImage), userName: userName);
      }
      print('UserImage: $userAvatar');
      UserModel user = UserModel(
        userId: googleUser.userId,
        username: userName,
        name: name,
        email: googleUser.email!,
        birthDate: birthDate,
        joinedAt: DateTime.now(),
        firstTime: true,
        avatarUrl: userAvatar,
      );
      print('User Avatar: ${user.avatarUrl}');
      print('Uploaded user selected avatar ${user.avatarUrl}');
      await _storeUserUseCase.execute(user);
      await _firestoreRepository.saveUser(user);
      print('Signed up successfully with Google');
    } on Exception catch (e) {
      print('Error: $e');
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
  _logger.info('GoogleSignUpUseCase');
  return GoogleSignUpUseCase(firestoreRepository, storeUserUseCase,
      avatarUpLoadUseCase, googleUserRepository);
}
