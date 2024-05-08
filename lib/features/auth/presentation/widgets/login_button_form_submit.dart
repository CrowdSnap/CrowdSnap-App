import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `LoginButtonFormSubmit` que extiende `ConsumerWidget` para utilizar datos de proveedores.
class LoginButtonFormSubmit extends ConsumerWidget {
  // Constructor simple sin parámetros.
  const LoginButtonFormSubmit({super.key});

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene referencias a los proveedores necesarios.
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);
    final authState = ref.watch(authStateProvider.notifier);

    // Botón elevado para iniciar sesión.
    return ElevatedButton(
      // Condición para habilitar el botón (correo válido y contraseña válida)
      onPressed: formValues.isPasswordValid && formValues.email.isNotEmpty
          ? () async {
              // Indica que el botón está cargando (deshabilita interacción).
              formState.startLoading();

              // Intento de inicio de sesión utilizando el proveedor de autenticación.
              final signInSuccess = await authNotifier.signIn(
                  formValues.email, formValues.password);
              if (signInSuccess == SignUpResult.emailAlreadyInUse) {
                // Maneja el caso especial de correo electrónico en uso (probablemente inicio de sesión).
                authState.loggedIn();
              } else {
                // ignore: use_build_context_synchronously
                // Maneja otros posibles errores de inicio de sesión.
                // Evita el uso de `buildContext` de forma sincrona dentro de un async (mejor usar Provider).
                // Muestra un snackbar indicando el error y ofreciendo la opción de registrarse.
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error al iniciar sesión'),
                    TextButton(
                        onPressed: () => router.push('/register'),
                        child: const Text('Regístrate'))
                  ],
                )));
              }
              // Detiene la animación de carga del botón.
              formState.stopLoading();
            }
          : null,
      // Estilo del botón dependiendo de si los campos del formulario están completos y son válidos.
      style: ElevatedButton.styleFrom(
        backgroundColor:
            formValues.isPasswordValid && formValues.email.isNotEmpty
                ? Theme.of(context).colorScheme.surface // Color de fondo activo
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.12), // Color de fondo inactivo
        foregroundColor:
            formValues.isPasswordValid && formValues.email.isNotEmpty
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
          // Indicador de carga circular si el botón está en proceso de inicio de sesión.
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
          const Text('Login'),
        ],
      ),
    );
  }
}
