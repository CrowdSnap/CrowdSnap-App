import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `GoogleRegisterButtonSubmit` que extiende `ConsumerWidget` para utilizar datos de proveedores.
class GoogleRegisterButtonSubmit extends ConsumerWidget {
  // Constructor simple sin parámetros.
  const GoogleRegisterButtonSubmit({super.key});

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene referencias a los proveedores necesarios.
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(googleSignUpNotifierProvider.notifier);
    final formValues = ref.watch(googleSignUpNotifierProvider);
    final authState = ref.watch(authStateProvider.notifier);

    // Botón elevado para el registro con Google.
    return ElevatedButton(
      onPressed: formValues.userName.isNotEmpty &&
              formValues.name.isNotEmpty &&
              formValues.isBirthDateValid &&
              !formValues.isLoading &&
              formValues.isUserNameValid &&
              !formValues.userNamesExists
          ? () async {
              // Indica que el botón está cargando (deshabilita interacción).
              formState.updateIsLoading(true);
              // Intento de registro con Google utilizando el proveedor de autenticación.
              final signUpResult = await authNotifier.signUpWithGoogle(
                formValues.name,
                formValues.userName,
                formValues.birthDate!,
                formValues.userImage,
              );
              if (signUpResult == SignUpResult.success) {
                print('Sign up success');
                // Actualiza el estado de autenticación (indica que el usuario inició sesión).
                authState.loggedIn();
              }
              print('Sign up result: $signUpResult');
              // Habilita nuevamente la interacción con el botón.
              formState.updateIsLoading(false);
            }
          : null,
      // Estilo del botón dependiendo de si los campos del formulario están completos.
      style: ElevatedButton.styleFrom(
        backgroundColor: formValues.name.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.isBirthDateValid
            ? Theme.of(context).colorScheme.surface // Color de fondo activo
            : Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.12), // Color de fondo inactivo
        foregroundColor: formValues.name.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.isBirthDateValid
            ? Theme.of(context).colorScheme.primary // Color de texto activo
            : Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.38), // Color de texto inactivo
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Ajusta el ancho del botón al contenido.
        children: [
          // Indicador de carga circular si el botón está en proceso de registro.
          if (formValues.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          // Texto del botón ("Completa tu cuenta").
          const Text('Completa tu cuenta'),
        ],
      ),
    );
  }
}
