import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Clase `BirthDateInputGoogleSignUp` que extiende `ConsumerWidget` para utilizar datos de un proveedor.
class BirthDateInputGoogleSignUp extends ConsumerWidget {
  // Constructor que crea una instancia de la clase y pasa la clave (un identificador único) al superconstructor.
  const BirthDateInputGoogleSignUp({super.key});

  // Método privado que obtiene el borde del campo de entrada de fecha de nacimiento según el estado del formulario.
  InputBorder _getBorder(BuildContext context, formValues,
      {bool isError = false}) {
    // Obtiene el tema actual.
    final theme = Theme.of(context);
    // Obtiene el esquema de colores del tema.
    final colorScheme = theme.colorScheme;

    // Si la fecha de nacimiento está vacía, establece el borde predeterminado.
    if (formValues.birthDate == null) {
      return theme.inputDecorationTheme.enabledBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
          );
      // Si hay un error o la fecha de nacimiento no es válida, establece el borde de error.
    } else if (isError || !formValues.isBirthDateValid) {
      return theme.inputDecorationTheme.errorBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
          );
      // Si no hay errores, establece el borde para el estado enfocado.
    } else {
      return theme.inputDecorationTheme.focusedBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
          );
    }
  }

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene el estado actual del proveedor `googleSignUpNotifierProvider`.
    final formState = ref.watch(googleSignUpNotifierProvider.notifier);
    // Obtiene una referencia directa al proveedor `googleSignUpNotifierProvider` para acceder a los datos del formulario.
    final formValues = ref.watch(googleSignUpNotifierProvider);

    // Columna con el campo de entrada de fecha de nacimiento.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // InkWell para mostrar el selector de fecha al tocar el campo.
        InkWell(
          onTap: () async {
            // Muestra el selector de fecha.
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: formValues.birthDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              locale: const Locale('es', 'ES'),
              initialEntryMode: DatePickerEntryMode.calendar,
              initialDatePickerMode: DatePickerMode.day,
            );
            // Si se selecciona una fecha, la actualiza en el estado del formulario y valida visualmente.
            if (selectedDate != null) {
              formState.updateBirthDate(selectedDate);
              formState.validateBirthDateVisual();
            }
          },
          child: InputDecorator(
            // Decoración del campo de entrada con etiqueta, hint y bordes según el estado del formulario.
            decoration: InputDecoration(
              labelText: 'Fecha de nacimiento',
              hintText: 'dd/mm/yyyy',
              enabledBorder: _getBorder(context, formValues),
              focusedBorder: _getBorder(context, formValues),
              errorBorder: _getBorder(context, formValues, isError: true),
              focusedErrorBorder:
                  _getBorder(context, formValues, isError: true),
            ),
            child: Text(
              // Muestra la fecha de nacimiento seleccionada en formato dd/MM/yyyy.
              formValues.birthDate != null
                  ? DateFormat('dd/MM/yyyy').format(formValues.birthDate!)
                  : '',
            ),
          ),
        ),
        // Widget Visibility que muestra un mensaje de error si la fecha de nacimiento no es válida (menor de 18 años).
        Visibility(
          visible: formValues.birthDate != null && !formValues.isBirthDateValid,
          child: const Column(
            children: [
              SizedBox(height: 12),
              Text(
                '✗  Debes tener al menos 18 años para registrarte',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
