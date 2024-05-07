import 'package:crowd_snap/core/data/models/google_user_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';

// Interfaz base que define los métodos para manejar la autenticación de usuarios en la aplicación.
abstract class AuthRepository {
  // Inicia sesión con correo electrónico y contraseña.
  //
  // Devuelve un `Future<UserModel>` que se resuelve a un objeto `UserModel` si el inicio de sesión es exitoso.
  // Lanza una excepción si el inicio de sesión falla.
  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  // Crea un nuevo usuario con correo electrónico y contraseña.
  //
  // Devuelve un `Future<UserModel>` que se resuelve a un objeto `UserModel` si la creación es exitosa.
  // Lanza una excepción si la creación del usuario falla.
  Future<UserModel> createUserWithEmailAndPassword(String email,
      String password, String username, String name, DateTime birthDate);

  // Inicia sesión con Google.
  //
  // Devuelve un `Future<GoogleUserModel>` que se resuelve a un objeto `GoogleUserModel` si el inicio de sesión es exitoso.
  // Lanza una excepción si el inicio de sesión falla.
  Future<GoogleUserModel> signInWithGoogle();

  // Cierra la sesión del usuario actual.
  //
  // Devuelve un `Future<void>`.
  Future<void> signOut();

  // Verifica si el usuario está actualmente autenticado.
  //
  // Devuelve `true` si el usuario está autenticado, `false` en caso contrario.
  bool isAuthenticated();

  // Recupera la contraseña de un usuario enviando un correo electrónico de restablecimiento.
  //
  // Devuelve un `Future<void>`.
  // Lanza una excepción si el proceso de recuperación falla.
  Future<void> recoverPassword(String email);
}
