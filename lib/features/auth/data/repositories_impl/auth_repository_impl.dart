import 'package:crowd_snap/core/data/models/google_user_model.dart';
import 'package:crowd_snap/features/auth/data/data_sources/auth_data_source.dart';
import 'package:crowd_snap/features/auth/data/data_sources/google_auth_data_source.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final authDataSource = ref.watch(authDataSourceProvider);
  final googleAuthDataSource = ref.watch(googleAuthDataSourceProvider);
  return AuthRepositoryImpl(authDataSource, googleAuthDataSource);
}

final _logger = Logger('AuthRepository');

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final GoogleAuthDataSource _googleAuthDataSource;

  AuthRepositoryImpl(this._authDataSource, this._googleAuthDataSource);

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final userModel =
        await _authDataSource.signInWithEmailAndPassword(email, password);
    _logger.info('UserModel: $userModel Desde el repositorio');
    return UserModel(
        userId: userModel.userId,
        username: userModel.username,
        name: userModel.name,
        email: userModel.email,
        joinedAt: userModel.joinedAt,
        firstTime: userModel.firstTime
        );
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password, String username, String name) async {
    final userModel = await _authDataSource.createUserWithEmailAndPassword(
        email, password, username, name);
    _logger.info('UserModel: $userModel Desde el repositorio');
    return UserModel(
        userId: userModel.userId,
        username: userModel.username,
        name: userModel.name,
        email: userModel.email,
        joinedAt: userModel.joinedAt,
        firstTime: userModel.firstTime
        );
  }

  @override
  Future<GoogleUserModel> signInWithGoogle() async {
    return await _googleAuthDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  bool isAuthenticated() {
    return _authDataSource.isAuthenticated();
  }

  @override
  Future<void> recoverPassword(String email) async {
    await _authDataSource.recoverPassword(email);
  }
}
