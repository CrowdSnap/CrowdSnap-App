import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Widget que representa la vista para la funcionalidad "Recuperar contraseña".
class ForgotPasswordView extends ConsumerWidget {
  // Constructor para el widget `ForgotPasswordView`.
  //
  // - `key`: Clave opcional para la identificación del widget.
  const ForgotPasswordView({super.key});

  // Método que construye la interfaz de usuario utilizando providers de Riverpod.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene el notifier de autenticación del provider `authNotifierProvider`.
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    // Obtiene el notifier del estado del formulario del provider `formNotifierProvider`.
    final formState = ref.watch(formNotifierProvider.notifier);
    // Obtiene el estado actual del formulario del provider `formNotifierProvider`.
    final formValues = ref.watch(formNotifierProvider);
    // Obtiene el router de la aplicación del provider `appRouterProvider`.
    final router = ref.watch(appRouterProvider);

    // Scaffold que proporciona la estructura general de la ventana de la aplicación.
    return Scaffold(
      // AppBar que muestra el título "Recuperar contraseña".
      appBar: AppBar(title: const Text('Recover Password')),
      // Padding que agrega espacio alrededor del contenido dentro del body.
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // Column que organiza los widgets secundarios verticalmente.
        child: Column(
          children: [
            // TextFormField que permite al usuario ingresar su dirección de correo electrónico.
            TextFormField(
              // Valor inicial para el campo de correo electrónico basado en `formValues.email`.
              initialValue: formValues.email,
              // Decoración para el campo de correo electrónico con una etiqueta "Correo electrónico".
              decoration: const InputDecoration(
                labelText: email,
              ),
              // Actualiza el estado del formulario con el valor del correo electrónico ingresado utilizando `formState.updateEmail`.
              onChanged: (value) => formState.updateEmail(value),
            ),
            // SizedBox que agrega espacio vertical entre el campo de correo electrónico y el botón.
            const SizedBox(height: 16),
            // ElevatedButton que representa el botón "Recuperar contraseña".
            ElevatedButton(
              // Acción desencadenada cuando se presiona el botón.
              onPressed: formValues.email.isNotEmpty
                  ? () {
                      // Inicia la recuperación de contraseña con el correo electrónico proporcionado.
                      authNotifier.recoverPassword(formValues.email);

                      // Navega a la ruta `/login` después de iniciar la recuperación.
                      router.go('/login');
                    }
                  : null,

              // Estilo del botón configurado en función del correo electrónico ingresado:
              // - Aspecto deshabilitado con baja opacidad cuando no se ingresa ningún correo electrónico.
              // - Aspecto habilitado con el esquema de color primario cuando se ingresa un correo electrónico.
              style: ElevatedButton.styleFrom(
                backgroundColor: formValues.email.isNotEmpty
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                foregroundColor: formValues.email.isNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary.withOpacity(0.38),
              ),

              // Texto del botón "Recuperar contraseña".
              child: const Text('Recover Password'),
            ),
          ],
        ),
      ),
    );
  }
}
