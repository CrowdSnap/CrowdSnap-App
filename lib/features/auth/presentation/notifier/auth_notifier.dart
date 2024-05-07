import 'package:crowd_snap/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/google_sign_up_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/recover_password_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

part 'auth_notifier.g.dart';

final _logger = Logger('AuthNotifier');

enum SignUpResult {
  success,
  emailAlreadyInUse,
  accountExistsWithGoogle,
  error,
  googleSignUp
}

// Clase `AuthNotifier` que administra el estado y la lógica para la autenticación de usuarios en una aplicación Riverpod.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  // Estado inicial del valor asíncrono.
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  // Inicia sesión con correo electrónico y contraseña.
  //
  // - `email`: El correo electrónico del usuario.
  // - `password`: La contraseña del usuario.
  //
  // Devuelve un `Future<SignUpResult>` que se resuelve a:
  //   - `SignUpResult.emailAlreadyInUse`: Si el correo electrónico ya está en uso.
  //   - `SignUpResult.error`: Si ocurre un error durante el inicio de sesión.
  Future<SignUpResult> signIn(String email, String password) async {
    // Establece el estado como 'cargando' mientras se procesa.
    state = const AsyncValue.loading();
    try {
      // Intenta iniciar sesión utilizando el `signInUseCaseProvider`.
      await ref.read(signInUseCaseProvider).execute(email, password);

      // Si el inicio de sesión es exitoso:
      // - Establece el estado de vuelta a 'data(null)'.
      // - Devuelve `SignUpResult.emailAlreadyInUse` (probablemente un marcador de posición, ajustarlo según el comportamiento real).
      state = const AsyncValue.data(null);
      return SignUpResult.emailAlreadyInUse;
    } catch (e, stackTrace) {
      // Si se produce un error:
      // - Establece el estado como 'error' con la excepción y la traza de pila.
      // - Imprime los detalles del error.
      // - Devuelve `SignUpResult.error`.
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');
      return SignUpResult.error;
    }
  }

  // Crea un nuevo usuario con correo electrónico y contraseña.
  //
  // - `email`: El correo electrónico del usuario.
  // - `password`: La contraseña del usuario.
  // - `username`: El nombre de usuario del usuario.
  // - `name`: El nombre completo del usuario.
  //  - `birthDate`: La fecha de nacimiento del usuario.
  //
  // Devuelve un `Future<SignUpResult>` que se resuelve a:
  //   - `SignUpResult.success`: Si el registro se realiza correctamente.
  //   - `SignUpResult.emailAlreadyInUse`: Si el correo electrónico ya está en uso.
  //   - `SignUpResult.accountExistsWithGoogle`: Si la cuenta ya existe con Google.
  //   - `SignUpResult.error`: Si ocurre un error durante el registro.
  Future<SignUpResult> signUp(String email, String password, String username,
      String name, DateTime birthDate) async {
    state = const AsyncValue.loading();

    try {
      // Si el registro es exitoso:
      // - Establece el estado de vuelta a 'data(null)'.
      // - Devuelve `SignUpResult.success`.
      await ref
          .read(signUpUseCaseProvider)
          .execute(email, password, username, name, birthDate);
      state = const AsyncValue.data(null);
      return SignUpResult.success;
    } catch (e, stackTrace) {
      // Maneja `FirebaseAuthException` específicamente:
      // - Comprueba si `email-already-in-use` y devuelve `SignUpResult.emailAlreadyInUse`.
      // - Comprueba si `account-exists-with-different-credential` y devuelve `SignUpResult.accountExistsWithGoogle`.
      // - Para otros errores:
      //   - Establece el estado como 'error' e imprime detalles.
      //   - Devuelve `SignUpResult.error`.
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // El correo ya está registrado
          return SignUpResult.emailAlreadyInUse;
        } else if (e.code == 'account-exists-with-different-credential') {
          // La cuenta ya está registrada con Google
          return SignUpResult.accountExistsWithGoogle;
        }
      }

      // Otro error ocurrió
      return SignUpResult.error;
    }
  }

  // Inicia sesión con Google.
  //
  // Devuelve un `Future<SignUpResult>` que se resuelve a:
  //   - `SignUpResult.googleSignUp`: Si el inicio de sesión con Google es exitoso y el usuario no estaba previamente registrado.
  //   - `SignUpResult.success`: Si el inicio de sesión con Google es exitoso y el usuario ya estaba registrado.
  //   - `SignUpResult.error`: Si ocurre un error durante el inicio de sesión con Google.
  Future<SignUpResult> signInWithGoogle() async {
    // Establece el estado como 'cargando' mientras se procesa.
    state = const AsyncValue.loading();
    try {
      // Intenta iniciar sesión con Google utilizando `googleSignInUseCaseProvider`.
      final registered = await ref.read(googleSignInUseCaseProvider).execute();

      // Si el inicio de sesión es exitoso:
      if (!registered) {
        // Si el usuario no estaba registrado previamente:
        // - Establece el estado de vuelta a 'data(null)'.
        // - Devuelve `SignUpResult.googleSignUp` (indica registro nuevo con Google).
        state = const AsyncValue.data(null);
        return SignUpResult.googleSignUp;
      }
    } catch (e) {
      // Si se produce un error:
      // - Establece el estado como 'error' con la excepción y la traza de pila.
      // - Devuelve `SignUpResult.error`.
      state = AsyncValue.error(e, StackTrace.current);
      return SignUpResult.error;
    }
    // Si el usuario ya estaba registrado:
    // - Devuelve directamente `SignUpResult.success`.
    return SignUpResult.success;
  }

  // Crea un nuevo usuario utilizando el inicio de sesión con Google.
  //
  // - `name`: El nombre completo del usuario.
  // - `userName`: El nombre de usuario del usuario.
  // - `birthDate`: La fecha de nacimiento del usuario.
  // - `userImage`: La URL de la imagen de perfil del usuario (opcional).
  //
  // Devuelve un `Future<SignUpResult>` que se resuelve a:
  //   - `SignUpResult.success`: Si el registro con Google es exitoso.
  //   - `SignUpResult.error`: Si ocurre un error durante el registro con Google.
  Future<SignUpResult> signUpWithGoogle(String name, String userName,
      DateTime birthDate, String userImage) async {
    // Establece el estado como 'cargando' mientras se procesa.
    state = const AsyncValue.loading();
    try {
      // Intenta registrar al usuario utilizando el inicio de sesión con Google y la información proporcionada.
      await ref
          .read(googleSignUpUseCaseProvider)
          .execute(name, userName, birthDate, userImage);

      // Si el registro es exitoso:
      // - Establece el estado de vuelta a 'data(null)'.
      // - Imprime un mensaje de éxito (opcional).
      // - Devuelve `SignUpResult.success`.
      state = const AsyncValue.data(null);
      print('SignUpWithGoogle: Success');
      return SignUpResult.success;
    } catch (e, stackTrace) {
      // Si se produce un error:
      // - Establece el estado como 'error' con la excepción y la traza de pila.
      // - Imprime los detalles del error.
      // - Devuelve `SignUpResult.error`.
      state = AsyncValue.error(e, stackTrace);
      print('Error: $e StackTrace: $stackTrace');
      return SignUpResult.error;
    }
  }

  // Cierra la sesión del usuario actual.
  //
  // Devuelve un `Future<void>` que se completa cuando se cierra la sesión correctamente.
  Future<void> signOut() async {
    // Establece el estado como 'cargando' mientras se procesa.
    state = const AsyncValue.loading();
    try {
      // Intenta cerrar la sesión utilizando `signOutUseCaseProvider`.
      await ref.read(signOutUseCaseProvider).execute();

      // Si el cierre de sesión es exitoso:
      // - Establece el estado de vuelta a 'data(null)'.
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      // Si se produce un error:
      // - Establece el estado como 'error' con la excepción y la traza de pila
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Solicita la recuperación de la contraseña de un usuario.
  //
  // - `email`: El correo electrónico del usuario para el que se solicita la recuperación.
  //
  // Devuelve un `Future<void>` que se completa cuando se envía la solicitud de recuperación.
  Future<void> recoverPassword(String email) async {
    // Establece el estado como 'cargando' mientras se procesa.
    state = const AsyncValue.loading();
    try {
      // Intenta enviar la solicitud de recuperación utilizando `recoverPasswordUseCaseProvider`.
      await ref.read(recoverPasswordUseCaseProvider).execute(email);

      // Si la solicitud se envía correctamente:
      // - Establece el estado de vuelta a 'data(null)'.
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      // Si se produce un error:
      // - Establece el estado como 'error' con la excepción y la traza de pila
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
