import 'package:crowd_snap/features/auth/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:crowd_snap/features/auth/domain/repositories/firestore_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'sign_in_use_case.g.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;

  SignInUseCase(this._authRepository, this._firestoreRepository);

  Future<UserModel> execute(String email, String password) async {
    try {
      // Iniciar sesión con email y contraseña
      final user =
          await _authRepository.signInWithEmailAndPassword(email, password);

      // Recuperar datos adicionales del usuario desde Firestore
      final userModel = await _firestoreRepository.getUser(user.userId);
      return userModel;
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
  _logger.info('SignInUseCase');
  return SignInUseCase(authRepository, firestoreRepository);
}
