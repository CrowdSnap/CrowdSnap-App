// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:crowd_snap/features/auth/data/data_sources/auth_data_source.dart';
import 'package:crowd_snap/features/auth/data/data_sources/google_auth_data_source.dart';
import 'package:crowd_snap/features/auth/domain/entities/user.dart';
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
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userModel = await _authDataSource.signInWithEmailAndPassword(email, password);
    _logger.info('UserModel: $userModel Desde el repositorio');
    return User(uid: userModel.uid, email: userModel.email);
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async {
    final userModel = await _authDataSource.createUserWithEmailAndPassword(email, password);
    _logger.info('UserModel: $userModel Desde el repositorio');
    return User(uid: userModel.uid, email: userModel.email);
  }

  @override
  Future<User> signInWithGoogle() async {
    final userModel = await _googleAuthDataSource.signInWithGoogle();
    _logger.info('UserModel: $userModel Desde el repositorio');
    return User(uid: userModel.uid, email: userModel.email);
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  bool isAuthenticated() {
    return _authDataSource.isAuthenticated();
  }
}
