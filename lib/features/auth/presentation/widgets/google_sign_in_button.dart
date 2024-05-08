import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `GoogleSignInButton` que extiende `ConsumerWidget` para utilizar datos de proveedores.
class GoogleSignInButton extends ConsumerWidget {
  // Constructor simple sin parámetros.
  const GoogleSignInButton({
    super.key,
  });

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene referencias a los proveedores necesarios.
    final authState = ref.watch(authStateProvider.notifier);
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);

    // Botón elevado para iniciar sesión con Google.
    return ElevatedButton(
      onPressed: () async {
        // Indica que el botón está cargando (deshabilita interacción).
        formState.startGoogleLoading();

        // Intento de inicio de sesión con Google utilizando el proveedor de autenticación.
        final signInSuccess = await authNotifier.signInWithGoogle();
        if (signInSuccess == SignUpResult.success) {
          // Actualiza el estado de autenticación (indica que el usuario inició sesión).
          authState.loggedIn();
          // Detiene la animación de carga del botón.
          formState.stopGoogleLoading();
        } else if (signInSuccess == SignUpResult.googleSignUp) {
          // Redirige al flujo de registro de Google si es necesario.
          authState.googleSignUp();
          // Detiene la animación de carga del botón.
          formState.stopGoogleLoading();
        } else {
          // Maneja otros posibles resultados del inicio de sesión (errores, etc.).
          // Detiene la animación de carga del botón.
          formState.stopGoogleLoading();
        }
        formState.stopGoogleLoading();
      },
      // Estilo del botón con fondo blanco, texto negro, bordes redondeados grises.
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Ajusta el ancho del botón al contenido.
        children: [
          // Indicador de carga circular o icono de Google según el estado del formulario.
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: formValues.isLoadingGoogle
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ))
                : const Image(
                    image: AssetImage('assets/icons/google_icon.png'),
                    height: 24,
                  ),
          ),
          const Text('Sign in with Google'),
        ],
      ),
    );
  }
}
