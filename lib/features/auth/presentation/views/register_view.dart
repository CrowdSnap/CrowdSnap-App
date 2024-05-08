import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/age/birth_date_input_register.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/password/password_input.dart';
import 'package:crowd_snap/core/constants.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/register_button_form_submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `RegisterView` que extiende `ConsumerWidget` para utilizar datos de un proveedor.
class RegisterView extends ConsumerWidget {
  // Constructor que crea una instancia de la clase y pasa la clave (un identificador único) al superconstructor.
  const RegisterView({super.key});

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene el estado actual del proveedor `formNotifierProvider`.
    final formState = ref.watch(formNotifierProvider.notifier);

    // Obtiene una referencia directa al proveedor `formNotifierProvider` para acceder a los datos del formulario.
    final formValues = ref.watch(formNotifierProvider);

    // Obtiene una referencia al enrutador de la aplicación para la navegación.
    final router = ref.watch(appRouterProvider);

    // Widget `Scaffold` que proporciona la estructura básica de la aplicación con una `AppBar` y un `body`.
    return Scaffold(
      appBar: AppBar(
        // Barra de aplicaciones con el título "Registro".
        title: const Text('Register'),
      ),
      // Widget `SafeArea` que garantiza que el contenido no se oculte por las barras del sistema (barra de estado o barra de navegación).
      body: SafeArea(
        child: Column(
          children: [
            // Widget `Expanded` que asegura que la columna de contenido ocupe el espacio restante en la pantalla.
            Expanded(
              // Centra el contenido dentro del espacio disponible.
              child: Center(
                child: SingleChildScrollView(
                  // Permite el desplazamiento del contenido si excede el tamaño de la pantalla.
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Agrega márgenes alrededor del formulario de registro.
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Campo de entrada de texto para el nombre.
                            TextFormField(
                              initialValue: formValues.name,
                              decoration: const InputDecoration(
                                labelText: name,
                              ),
                              onChanged: (value) =>
                                  formState.updateNombre(value),
                              keyboardType: TextInputType.name,
                            ),
                            // Campo de entrada de texto para el nombre de usuario.
                            TextFormField(
                              initialValue: formValues.name,
                              decoration: const InputDecoration(
                                labelText: userName,
                              ),
                              onChanged: (value) =>
                                  formState.updateUserName(value),
                              keyboardType: TextInputType.name,
                            ),
                            // Campo de entrada de texto para el correo electrónico.
                            TextFormField(
                              initialValue: formValues.email,
                              decoration: const InputDecoration(
                                labelText: email,
                              ),
                              onChanged: (value) =>
                                  formState.updateEmail(value),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            // Campo personalizado para la fecha de nacimiento.
                            const BirthDateInputRegister(),
                            // Campo personalizado para la contraseña.
                            const PasswordInput(),
                            // Espacio adicional entre campos de formulario.
                            const SizedBox(height: 30),
                            // Botón de registro personalizado.
                            const RegisterButtonFormSubmit(),
                            // Espacio adicional entre el botón de registro y las opciones de registro alternativas.
                            const SizedBox(height: 30),
                            // Fila con opciones de inicio de sesión alternativas: divisor, texto, divisor y botón de inicio de sesión.
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Divider()),
                                Text('   O   ', style: TextStyle(fontSize: 14)),
                                Expanded(child: Divider()),
                              ],
                            ),
                            // Espacio adicional entre las opciones de inicio de sesión alternativas y el botón de inicio de sesión con Google.
                            const SizedBox(height: 30),
                            // Botón de inicio de sesión con Google.
                            const GoogleSignInButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Línea divisoria para separar el formulario de registro del enlace para iniciar sesión.
            const Divider(),
            // Fila con enlace para iniciar sesión: texto "¿Ya tienes cuenta?" y botón "Inicia Sesión".
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                    onPressed: () {
                      router.go('/login');
                    },
                    child: const Text('Inicia Sesión'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
