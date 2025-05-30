import 'package:crowd_snap/features/auth/data/models/google_user_model.dart';
import 'package:crowd_snap/features/auth/data/data_sources/auth_data_source.dart';
import 'package:crowd_snap/features/auth/data/data_sources/google_auth_data_source.dart';
import 'package:crowd_snap/features/profile/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_repository_impl.g.dart';

// Mantiene viva esta instancia a lo largo del ciclo de vida de la aplicación.
// Crea y proporciona una instancia de `AuthRepository` dentro del árbol de providers de Riverpod.
// Esta instancia es responsable de manejar la autenticación del usuario en la aplicación.
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

  // Inicia sesión con correo electrónico y contraseña utilizando `authDataSource`.
  // Devuelve un `UserModel` si el inicio de sesión es exitoso.
  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final userModel =
        await _authDataSource.signInWithEmailAndPassword(email, password);
    _logger.info('UserModel: $userModel Desde el repositorio');
    return userModel;
  }

  // Crea un usuario con correo electrónico y contraseña utilizando `authDataSource`.
  // Devuelve un `UserModel` si la creación es exitosa.
  @override
  Future<UserModel> createUserWithEmailAndPassword(String email,
      String password, String username, String name, DateTime birthDate) async {
    final userModel = await _authDataSource.createUserWithEmailAndPassword(
        email, password, username, name, birthDate);
    _logger.info('UserModel: $userModel Desde el repositorio');
    return userModel;
  }

  // Inicia sesión con Google utilizando `googleAuthDataSource`.
  // Devuelve un `GoogleUserModel` si el inicio de sesión es exitoso.
  @override
  Future<GoogleUserModel> signInWithGoogle() async {
    return await _googleAuthDataSource.signInWithGoogle();
  }

  // Cierra la sesión actual utilizando `authDataSource`.
  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  // Verifica si el usuario actual está autenticado utilizando `authDataSource`.
  // Devuelve `true` si el usuario está autenticado, `false` en caso contrario.
  @override
  bool isAuthenticated() {
    return _authDataSource.isAuthenticated();
  }

  // Recupera la contraseña de un usuario utilizando `authDataSource`.
  @override
  Future<void> recoverPassword(String email) async {
    await _authDataSource.recoverPassword(email);
  }
}
