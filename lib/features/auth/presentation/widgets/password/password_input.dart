import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart'
    as form_notifier;
import 'package:crowd_snap/features/auth/presentation/widgets/password/text_password_requirements.dart';
import 'package:crowd_snap/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `PasswordInput` que extiende `ConsumerWidget` para utilizar datos de un proveedor.
class PasswordInput extends ConsumerWidget {
  // Bandera para mostrar u ocultar los requisitos de contraseña.
  final bool showPasswordRequirements;

  // Constructor que crea una instancia de la clase y permite opcionalmente ocultar los requisitos de contraseña.
  const PasswordInput({
    super.key,
    this.showPasswordRequirements = true,
  });

  // Método privado que obtiene el borde del campo de entrada de contraseña según el estado del formulario.
  InputBorder _getBorder(
      BuildContext context, form_notifier.FormState formValues,
      {bool isError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Si la contraseña está vacía, establece el borde predeterminado.
    if (formValues.password.isEmpty) {
      // Establece el borde predeterminado del tema o un borde predeterminado si no se define el tema.
      return theme.inputDecorationTheme.enabledBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
          );
    } else if (isError || !formValues.isPasswordValid) {
      // Si hay un error o la contraseña no es válida, establece el borde de error.
      return theme.inputDecorationTheme.errorBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
          );
    } else {
      // Si no hay errores y la contraseña es válida, establece el borde para el estado enfocado.
      return theme.inputDecorationTheme.focusedBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
          );
    }
  }

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene el estado actual del proveedor `formNotifierProvider`.
    final formState = ref.watch(form_notifier.formNotifierProvider.notifier);
    // Obtiene una referencia directa al proveedor `formNotifierProvider` para acceder a los datos del formulario.
    final formValues = ref.watch(form_notifier.formNotifierProvider);

    // Columna con el campo de entrada de contraseña.
    return Column(
      children: [
        // TextFormField para la contraseña.
        TextFormField(
          // Valor inicial establecido con la contraseña del formulario.
          initialValue: formValues.password,
          decoration: InputDecoration(
            // Etiqueta ("Contraseña")
            labelText: password,
            // Ícono de candado que cambia según la visibilidad de la contraseña.
            suffixIcon: IconButton(
                icon: Icon(formState.getPasswordIcon()),
                onPressed: () => formState.togglePasswordVisibility()),
            // Bordes según el estado del formulario (vacío, error, etc.).
            enabledBorder: _getBorder(context, formValues),
            focusedBorder: _getBorder(context, formValues),
            errorBorder: _getBorder(context, formValues, isError: true),
            focusedErrorBorder: _getBorder(context, formValues, isError: true),
          ),
          // Oculta la contraseña por defecto (se puede mostrar con el ícono).
          obscureText: !formValues.showPassword,
          // Actualiza la contraseña en el estado del formulario al escribir.
          onChanged: (value) {
            formState.updatePassword(value);
            formState.validatePasswordVisual();
          },
          // Teclado para contraseñas visibles (opcional, dependiendo del diseño).
          keyboardType: TextInputType.visiblePassword,
        ),
        const SizedBox(height: 16),
        // Widget Visibility que muestra los requisitos de contraseña si están habilitados.
        Visibility(
            visible: showPasswordRequirements,
            child: const TextPasswordRequirements()),
      ],
    );
  }
}
