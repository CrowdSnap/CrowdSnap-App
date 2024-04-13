// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:crowd_snap/features/auth/data/data_sources/auth_data_source.dart';
import 'package:crowd_snap/features/auth/domain/entities/user.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final authDataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(authDataSource);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userModel = await _authDataSource.signInWithEmailAndPassword(email, password);
    print('UserModel: $userModel Desde el repositorio');
    return User(uid: userModel.uid, email: userModel.email);
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async {
    final userModel = await _authDataSource.createUserWithEmailAndPassword(email, password);
    print('UserModel: $userModel Desde el repositorio');
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
