import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_up_use_case.g.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final StoreUserUseCase _storeUserUseCase;

  SignUpUseCase(
      this._authRepository, this._firestoreRepository, this._storeUserUseCase);

  Future<void> execute(String email, String password, String username,
      String name, DateTime birthDate) async {
    final userModel = await _authRepository.createUserWithEmailAndPassword(
        email, password, username, name, birthDate);

    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();

    final fcmTokenUserModel = userModel.copyWith(fcmToken: fcmToken);

    await _storeUserUseCase.execute(fcmTokenUserModel);
    await _firestoreRepository.saveUser(fcmTokenUserModel);
  }
}

final _logger = Logger('SignUpUseCase');

@riverpod
SignUpUseCase signUpUseCase(SignUpUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  final storeUserUseCase = ref.watch(storeUserUseCaseProvider);
  _logger.info('SignUpUseCase');
  return SignUpUseCase(authRepository, firestoreRepository, storeUserUseCase);
}
