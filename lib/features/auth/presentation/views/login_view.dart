import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/login_button_form_submit.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/password/password_input.dart';
import 'package:crowd_snap/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Clase `LoginView` que extiende `ConsumerWidget` para utilizar datos de un proveedor.
class LoginView extends ConsumerWidget {
  // Constructor que crea una instancia de la clase y pasa la clave (un identificador único) al superconstructor.
  const LoginView({super.key});

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
        // Barra de aplicaciones con el título "Login".
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          // Widget `Align` que posiciona una imagen del logotipo de inicio de sesión ligeramente por encima del centro de la pantalla.
          Align(
            alignment: const Alignment(0, -1.25),
            child: Image.asset(
              // Imagen del logotipo desde la carpeta de recursos del proyecto.
              'assets/icons/crowd_snap_logo.png',
              width: 300, // Ajusta el ancho
              height: 300, // Ajusta la altura
            ),
          ),
          // Widget `SafeArea` que garantiza que el contenido no se oculte por las barras del sistema (barra de estado o barra de navegación).
          SafeArea(
            child: Column(
              children: [
                // Widget `Expanded` que asegura que la columna de contenido ocupe el espacio restante en la pantalla.
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Espacio adicional entre el logotipo y el formulario.
                          const SizedBox(height: 16),
                          // Widget `Padding` que agrega márgenes alrededor del formulario.
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                // Campo de entrada de contraseña con requisitos de contraseña ocultos.
                                const PasswordInput(
                                    showPasswordRequirements: false),
                                // Espacio adicional entre el campo de contraseña y el botón de inicio de sesión.
                                const SizedBox(height: 30),
                                // Botón de inicio de sesión personalizado.
                                const LoginButtonFormSubmit(),
                                // Espacio adicional entre el botón de inicio de sesión y las opciones de inicio de sesión alternativas.
                                const SizedBox(height: 30),
                                // Fila con opciones de inicio de sesión alternativas: divisor, texto, divisor y botón de registro.
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Divider()),
                                    Text('   O   ',
                                        style: TextStyle(fontSize: 14)),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                // Espacio adicional entre las opciones de inicio de sesión alternativas y el enlace para contraseña olvidada.
                                const SizedBox(height: 30),
                                const GoogleSignInButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Botón para recuperar la contraseña olvidada.
                TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: const Text('¿Olvidaste tu contraseña?')),
                // Línea divisoria para separar el enlace de "Olvidaste tu contraseña" de las opciones de registro.
                const Divider(),
                // Fila con opciones de registro: texto "¿No tienes cuenta?" y botón "Regístrate".
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta?'),
                    TextButton(
                        onPressed: () {
                          router.push('/register');
                        },
                        child: const Text('Regístrate'))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
