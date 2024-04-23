import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'google_sign_in_use_case.g.dart';

class GoogleSignInUseCase {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;

  GoogleSignInUseCase(this._authRepository, this._firestoreRepository);

  Future<UserModel> execute() async {
    final userModel = await _authRepository.signInWithGoogle();
    await _firestoreRepository.saveUser(userModel);
    return userModel;
  }
}

final _logger = Logger('GoogleSignInUseCase');

@riverpod
GoogleSignInUseCase googleSignInUseCase(GoogleSignInUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  _logger.info('GoogleSignInUseCase');
  return GoogleSignInUseCase(authRepository, firestoreRepository);
}
