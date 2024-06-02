import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `RegisterButtonFormSubmit` que extiende `ConsumerWidget` para utilizar datos de proveedores.
class RegisterButtonFormSubmit extends ConsumerWidget {
  // Constructor simple sin parámetros.
  const RegisterButtonFormSubmit({super.key});

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene referencias a los proveedores necesarios.
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);
    final authState = ref.watch(authStateProvider.notifier);

    // Botón elevado para registrarse.
    return ElevatedButton(
      // Condición para habilitar el botón (todos los campos del formulario deben ser válidos)
      onPressed: formValues.isPasswordValid &&
              formValues.email.isNotEmpty &&
              formValues.userName.isNotEmpty &&
              formValues.name.isNotEmpty &&
              formValues.isBirthDateValid &&
              formValues.isUserNameValid &&
              !formValues.userNamesExists
          ? () async {
              // Indica que el botón está cargando (deshabilita interacción).
              formState.startLoading();

              // Intento de registro utilizando el proveedor de autenticación.
              final signUpResult = await authNotifier.signUp(
                formValues.email,
                formValues.password,
                formValues.userName,
                formValues.name,
                formValues.birthDate!,
              );
              if (signUpResult == SignUpResult.success) {
                // Actualiza el estado de autenticación (indica que el usuario se registró).
                authState.avatarUpload();
              } else {
                // Maneja diferentes errores de registro.
                String errorMessage;
                switch (signUpResult) {
                  case SignUpResult.emailAlreadyInUse:
                    errorMessage = 'El correo ya está registrado';
                    break;
                  case SignUpResult.accountExistsWithGoogle:
                    errorMessage = 'La cuenta ya está registrada con Google';
                    break;
                  default:
                    errorMessage = 'Error al registrarse';
                }
                // ignore: use_build_context_synchronously
                // Evita el uso de `buildContext` de forma sincrona dentro de un async (mejor usar Provider).
                // Muestra un snackbar indicando el error y ofreciendo la opción de iniciar sesión
                // (solo si el error es por correo en uso o cuenta existente con Google).
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage),
                      if (signUpResult == SignUpResult.emailAlreadyInUse ||
                          signUpResult == SignUpResult.accountExistsWithGoogle)
                        TextButton(
                          onPressed: () => router.go('/login'),
                          child: const Text('Inicia sesión'),
                        ),
                    ],
                  )),
                );
              }
              // Detiene la animación de carga del botón.
              formState.stopLoading();
            }
          : null,
      style: ElevatedButton.styleFrom(
        // Estilo del botón dependiendo de si los campos del formulario están completos y son válidos
        backgroundColor: formValues.isPasswordValid &&
                formValues.email.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.name.isNotEmpty &&
                formValues.isBirthDateValid
            ? Theme.of(context).colorScheme.surface // Color de fondo activo
            : Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.12), // Color de fondo inactivo
        foregroundColor: formValues.isPasswordValid &&
                formValues.email.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.name.isNotEmpty &&
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
          const Text('Registro'),
        ],
      ),
    );
  }
}
